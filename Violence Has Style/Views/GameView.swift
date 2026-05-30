//
//  GameView.swift
//  Violence Has Style
//
//  Created by Tufan Cakir on 30.05.26.
//

import AVFoundation
import SwiftData
import SwiftUI

struct GameView: View {

    @Environment(\.modelContext) private var modelContext

    @Query private var progressEntries: [PlayerProgress]
    @Query private var wallets: [EventWallet]
    @State private var network = NetworkMonitor.shared
    @State private var currentScreen: GameScreen = .title
    @State private var game = GameState()
    @State private var screenShakeOffset = CGSize.zero
    @State private var damageFlashOpacity = 0.0
    @State private var finisherFlashOpacity = 0.0
    @State private var brokenPulse = false
    @State private var styleGodPulse = false
    @State private var isShowingFightIntro = false
    @State private var musicQueuePlayer: AVQueuePlayer?
    @State private var remoteContentRefreshID = UUID()
    @State private var isRemoteContentLoading = true
    @State private var isRemoteContentReady = false
    @State private var remoteContentStatus = "CONNECTING TO STYLE SERVER"
    @AppStorage("settingsScreenShakeEnabled") private var isScreenShakeEnabled =
        true
    @AppStorage("settingsFlashFXEnabled") private var isFlashFXEnabled = true

    private var activeEvent: EventDefinition? {
        EventCatalog.shared.activeEvent
    }

    private var progress: PlayerProgress {
        if let progress = progressEntries.first {
            return progress
        }

        let progress = PlayerProgress()
        modelContext.insert(progress)
        try? modelContext.save()
        return progress
    }

    private func wallet(for currencyId: String) -> EventWallet {
        if let existing = wallets.first(where: { $0.currencyId == currencyId })
        {
            return existing
        }

        let wallet = EventWallet(currencyId: currencyId)

        modelContext.insert(wallet)

        try? modelContext.save()

        return wallet
    }

    private var battleView: some View {
        BattleSceneView(
            game: game,
            screenShakeOffset: screenShakeOffset,
            brokenPulse: brokenPulse,
            styleGodPulse: styleGodPulse
        )
    }

    var body: some View {
        RootView(
            styleRank: game.styleRank,
            coins: progress.coins,
            crystals: progress.crystals,
            eventTitle: activeEvent?.currencyTitle,
            eventBalance: activeEventBalance,
            selectedScreen: currentScreen,
            selectScreen: selectFooterScreen
        ) {
            screenContent
        }
            .overlay { flashOverlay }
            .overlay { runOverlay }
            .overlay { connectionOverlay }
            .contentShape(Rectangle())
            .onTapGesture {
                startAttack()
            }
            .gesture(
                DragGesture(minimumDistance: 28)
                    .onEnded { value in
                        handleSwipe(width: value.translation.width)
                    }
            )
            .onAppear {
                styleGodPulse = true
            }
            .task {
                await refreshRemoteContent()
            }
            .onChange(of: game.isEnemyBroken) { _, newValue in
                brokenPulse = newValue
            }
            .onChange(of: network.isConnected) { _, connected in
                if connected && !isRemoteContentReady {
                    Task {
                        await refreshRemoteContent()
                    }
                }
            }
            .onAppear {

                if progressEntries.isEmpty {

                    let progress = PlayerProgress()

                    modelContext.insert(progress)

                    try? modelContext.save()
                }
            }
    }

    @ViewBuilder
    private var screenContent: some View {
        switch currentScreen {
        case .title:
            TitleScreenView {
                triggerFinisherImpact()
                currentScreen = .menu
            }
        case .menu:
            MainMenuView(
                presentedCharacter: game.currentCharacter,
                activeEvent: activeEvent,
                eventBalance: activeEventBalance,
                openStoryMode: { currentScreen = .storyMode },
                openEventMode: { currentScreen = .eventMode },
                openEndlessMode: { currentScreen = .endlessMode },
                openCharacterSelect: { currentScreen = .characterSelect },
                openStyleMode: { currentScreen = .styleLab },
                openGallery: { currentScreen = .gallery },
                openSettings: { currentScreen = .settings }
            )
        case .storyMode:
            StoryModeView(
                chapters: StoryCatalog.shared.chapters,
                completedChapterCount: progress.storyCompletedChapterCount,
                startChapter: { chapter in
                    startRun(mode: .story, storyChapter: chapter)
                },
                back: { currentScreen = .menu }
            )
        case .eventMode:
            EventModeView(
                event: activeEvent,
                balance: activeEventBalance,
                startEventRun: { startRun(mode: .event) },
                openShop: { currentScreen = .eventShop },
                back: { currentScreen = .menu }
            )
        case .endlessMode:
            EndlessModeView(
                highScore: progress.endlessHighScore,
                bestFights: progress.endlessBestFights,
                startEndless: { startRun(mode: .endless) },
                back: { currentScreen = .menu }
            )
        case .characterSelect:
            CharacterSelectView(
                characters: CharacterCatalog.shared.characters,
                selectedCharacter: game.currentCharacter,
                selectCharacter: { character in
                    game.currentCharacter = character
                    restartRun()
                },
                back: { currentScreen = .menu }
            )
        case .styleLab:
            StyleLabView {
                currentScreen = .menu
            }
        case .gallery:
            GalleryView(
                bestStyleRank: StyleRank(score: progress.bestStyleScore),
                bestFightsCleared: progress.bestFightsCleared,
                bestMaxCombo: progress.bestMaxCombo,
                unlockedRewards: progress.unlockedRewards,
                bossVerdicts: progress.bossVerdicts,
                back: { currentScreen = .menu }
            )
        case .eventShop:
            EventShopView(
                event: activeEvent,
                balance: activeEventBalance,
                purchasedItemIds: activeEvent.map {
                    wallet(for: $0.currencyId).purchasedItemIds
                } ?? [],
                buyItem: buyEventItem,
                back: { currentScreen = .menu }
            )
        case .leaderboard:
            LeaderboardView()
        case .settings:
            SettingsView(
                isScreenShakeEnabled: $isScreenShakeEnabled,
                isFlashFXEnabled: $isFlashFXEnabled,
                resetGalleryData: resetGalleryData,
                back: { currentScreen = .menu }
            )
        case .run:
            battleView
        }
    }

    private var flashOverlay: some View {
        ZStack {
            Color.red
                .opacity(damageFlashOpacity)
                .ignoresSafeArea()
                .allowsHitTesting(false)

            Color.white
                .opacity(finisherFlashOpacity)
                .ignoresSafeArea()
                .allowsHitTesting(false)
        }
    }

    @ViewBuilder
    private var runOverlay: some View {
        if currentScreen == .run && isShowingFightIntro {
            FightIntroView(
                fightLevel: game.fightLevel,
                level: game.currentLevel,
                enemy: game.currentEnemy,
                character: game.currentCharacter,
                start: {
                    isShowingFightIntro = false
                }
            )
        }

        if game.isChoosingReward {
            RewardChoiceOverlayView(
                fightLevel: game.fightLevel,
                rewards: game.rewardChoices,
                chooseReward: chooseReward
            )
        }

        if game.isGameOver {
            RunEndedOverlayView(
                game: game,
                restart: restartRun,
                mainMenu: {
                    restartRun()
                    currentScreen = .menu
                }
            )
        }
    }

    @ViewBuilder
    private var connectionOverlay: some View {
        if !network.isConnected {
            OfflineView()
        } else if isRemoteContentLoading || !isRemoteContentReady {
            OnlineRequiredView(
                isLoading: isRemoteContentLoading,
                status: remoteContentStatus,
                retry: {
                    Task {
                        await refreshRemoteContent()
                    }
                }
            )
        }
    }

    private var activeEventBalance: Int {
        guard let activeEvent else { return 0 }

        return wallet(for: activeEvent.currencyId).balance
    }

    private func selectFooterScreen(_ screen: GameScreen) {
        guard currentScreen != .run || !isShowingFightIntro else { return }
        currentScreen = screen
    }

    private func startAttack() {
        guard isRemoteContentReady else { return }
        guard currentScreen == .run, !game.isChoosingReward, !game.isGameOver
        else { return }
        guard !isShowingFightIntro else {
            isShowingFightIntro = false
            return
        }
        handleEvents(game.startAttack())
    }

    private func handleSwipe(width: CGFloat) {
        guard isRemoteContentReady else { return }
        guard currentScreen == .run, !game.isChoosingReward, !game.isGameOver,
            !isShowingFightIntro
        else { return }
        handleEvents(game.handleSwipe(width: width))
    }

    @MainActor
    private func refreshRemoteContent() async {
        guard network.isConnected else {
            isRemoteContentReady = false
            isRemoteContentLoading = false
            remoteContentStatus = "NO INTERNET CONNECTION"
            return
        }

        isRemoteContentLoading = true
        remoteContentStatus = "CONNECTING TO STYLE SERVER"

        await RemoteContentStore.shared.refresh()
        isRemoteContentReady = RemoteContentStore.shared.isOnline
        remoteContentStatus = RemoteContentStore.shared.statusMessage

        if isRemoteContentReady {
            remoteContentStatus = "PRELOADING REMOTE MEDIA"
            await RemoteContentStore.shared.preloadRemoteMedia()
            game.refreshDataDefinitions()
            startMusicPlaylist()
            remoteContentRefreshID = UUID()
        }

        isRemoteContentLoading = false
    }

    private func chooseReward(_ reward: RunReward) {
        handleEvents(game.chooseReward(reward))
    }

    private func restartRun() {
        game.startRun(mode: .style)
        screenShakeOffset = .zero
        damageFlashOpacity = 0
        finisherFlashOpacity = 0
        brokenPulse = false
    }

    private func startRun(mode: RunMode, storyChapter: StoryChapter? = nil) {
        game.startRun(mode: mode, storyChapter: storyChapter)
        screenShakeOffset = .zero
        damageFlashOpacity = 0
        finisherFlashOpacity = 0
        brokenPulse = false
        isShowingFightIntro = true
        currentScreen = .run
        startMusicPlaylist(mode: mode)
    }

    private func handleEvents(_ events: [GameEvent]) {
        for event in events {
            switch event {
            case .sound:
                break
            case .screenShake(let intensity):
                triggerScreenShake(intensity: intensity)
            case .playerHitImpact:
                triggerPlayerHitImpact()
            case .finisherImpact:
                triggerFinisherImpact()
            case .persistRunProgress(let verdict):
                persistRunProgress(verdict: verdict)
                persistModeProgress()
            case .unlockReward(let rewardTitle):

                if !progress.unlockedRewards.contains(
                    rewardTitle
                ) {
                    progress.unlockedRewards.append(
                        rewardTitle
                    )

                    try? modelContext.save()
                }

                isShowingFightIntro = true
            case .awardEventCurrency(let amount, let currencyId):
                addEventCurrency(amount, currencyId: currencyId)
            }
        }
    }

    private func buyEventItem(
        _ item: EventShopItem
    ) {
        guard let activeEvent else { return }

        let wallet = wallet(
            for: activeEvent.currencyId
        )

        guard wallet.balance >= item.cost else {
            return
        }

        guard !wallet.purchasedItemIds.contains(item.id) else {
            return
        }

        wallet.balance -= item.cost
        wallet.purchasedItemIds.append(item.id)

        try? modelContext.save()
    }

    private func addEventCurrency(
        _ amount: Int,
        currencyId: String
    ) {
        let wallet = wallet(for: currencyId)

        wallet.balance += amount

        try? modelContext.save()
    }

    private func persistRunProgress(
        verdict: String
    ) {
        progress.bestFightsCleared = max(
            progress.bestFightsCleared,
            game.fightsCleared
        )

        progress.bestMaxCombo = max(
            progress.bestMaxCombo,
            game.maxCombo
        )

        progress.bestStyleScore = max(
            progress.bestStyleScore,
            game.bestStyleRank.score
        )

        if !progress.bossVerdicts.contains(verdict) {
            progress.bossVerdicts.append(verdict)
        }

        try? modelContext.save()
    }

    private func persistModeProgress() {

        switch game.runMode {

        case .story:

            if let chapter =
                StoryCatalog.shared.chapter(
                    id: game.storyChapterId
                ),
                game.fightsCleared >= chapter.targetFights
            {

                progress.storyCompletedChapterCount =
                    max(
                        progress.storyCompletedChapterCount,
                        chapter.requiredChapter + 1
                    )
            }

        case .endless:

            let score =
                game.fightsCleared * 1000 + game.maxCombo * 25 + game
                .bestStyleRank.score * 500

            progress.endlessHighScore =
                max(
                    progress.endlessHighScore,
                    score
                )

            progress.endlessBestFights =
                max(
                    progress.endlessBestFights,
                    game.fightsCleared
                )

        case .event, .style:
            break
        }

        try? modelContext.save()
    }

    private func triggerPlayerHitImpact() {
        triggerScreenShake(intensity: 13)
        guard isFlashFXEnabled else { return }

        Task { @MainActor in
            withAnimation(.linear(duration: 0.04)) {
                damageFlashOpacity = 0.42
            }

            try? await Task.sleep(for: .milliseconds(90))

            withAnimation(.easeOut(duration: 0.22)) {
                damageFlashOpacity = 0
            }
        }
    }

    private func triggerFinisherImpact() {
        triggerScreenShake(intensity: 18)
        guard isFlashFXEnabled else { return }

        Task { @MainActor in
            withAnimation(.linear(duration: 0.035)) {
                finisherFlashOpacity = 0.72
            }

            try? await Task.sleep(for: .milliseconds(80))

            withAnimation(.easeOut(duration: 0.28)) {
                finisherFlashOpacity = 0
            }
        }
    }

    private func triggerScreenShake(intensity: CGFloat) {
        guard isScreenShakeEnabled else { return }

        Task { @MainActor in
            let offsets = [
                CGSize(width: intensity, height: -intensity * 0.45),
                CGSize(width: -intensity * 0.85, height: intensity * 0.35),
                CGSize(width: intensity * 0.55, height: intensity * 0.2),
                CGSize(width: -intensity * 0.35, height: -intensity * 0.25),
            ]

            for offset in offsets {
                withAnimation(.linear(duration: 0.035)) {
                    screenShakeOffset = offset
                }
                try? await Task.sleep(for: .milliseconds(35))
            }

            withAnimation(.spring(response: 0.18, dampingFraction: 0.72)) {
                screenShakeOffset = .zero
            }
        }
    }

    private func startMusicPlaylist(mode: RunMode? = nil) {
        let items = MusicCatalog.shared.playlist(for: mode).compactMap {
            track -> AVPlayerItem? in
            guard let url = RemoteContentStore.shared.contentURL(track.url)
            else { return nil }
            return AVPlayerItem(url: url)
        }
        guard !items.isEmpty else { return }

        let player = AVQueuePlayer(items: items)
        player.actionAtItemEnd = .advance
        player.play()
        musicQueuePlayer = player
    }

    private func resetGalleryData() {

        progress.bestFightsCleared = 0
        progress.bestMaxCombo = 0
        progress.bestStyleScore = 0

        progress.unlockedRewards.removeAll()
        progress.bossVerdicts.removeAll()

        for wallet in wallets {
            wallet.balance = 0
            wallet.purchasedItemIds.removeAll()
        }

        try? modelContext.save()
    }
}

#Preview {
    GameView()
}
