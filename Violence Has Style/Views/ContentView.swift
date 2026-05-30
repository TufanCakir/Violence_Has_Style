//
//  ContentView.swift
//  Violence Has Style
//
//  Created by Tufan Cakir on 30.05.26.
//

import AVFoundation
import SwiftUI

struct ContentView: View {
    @State private var currentScreen: GameScreen = .title
    @State private var game = GameState()
    @State private var screenShakeOffset = CGSize.zero
    @State private var damageFlashOpacity = 0.0
    @State private var finisherFlashOpacity = 0.0
    @State private var brokenPulse = false
    @State private var styleGodPulse = false
    @State private var isShowingFightIntro = false
    @State private var remoteAudioPlayers: [String: AVPlayer] = [:]
    @State private var remoteContentRefreshID = UUID()
    @State private var isRemoteContentLoading = true
    @State private var isRemoteContentReady = false
    @State private var remoteContentStatus = "CONNECTING TO STYLE SERVER"
    @AppStorage("galleryBestFightsCleared") private
        var galleryBestFightsCleared = 0
    @AppStorage("galleryBestMaxCombo") private var galleryBestMaxCombo = 0
    @AppStorage("galleryBestStyleScore") private var galleryBestStyleScore = 0
    @AppStorage("galleryUnlockedRewards") private var galleryUnlockedRewards =
        ""
    @AppStorage("galleryBossVerdicts") private var galleryBossVerdicts = ""
    @AppStorage("eventCurrencyBalances") private var eventCurrencyBalances = ""
    @AppStorage("eventPurchasedItems") private var eventPurchasedItems = ""
    @AppStorage("settingsSFXEnabled") private var isSFXEnabled = true
    @AppStorage("settingsScreenShakeEnabled") private var isScreenShakeEnabled =
        true
    @AppStorage("settingsFlashFXEnabled") private var isFlashFXEnabled = true

    private var galleryBestStyleRank: StyleRank {
        StyleRank(score: galleryBestStyleScore)
    }

    private var activeEvent: EventDefinition? {
        EventCatalog.shared.activeEvent
    }

    var body: some View {
        ZStack {
            arenaBackground

            VStack(spacing: 18) {
                header

                Spacer(minLength: 12)

                ZStack(alignment: .bottom) {
                    floorGlow
                    paintLayer

                    HStack(alignment: .bottom) {
                        FighterSprite(
                            assetName: game.playerFrame,
                            fallbackTitle: "PLAYER",
                            tint: game.currentCharacter.tint,
                            isEnemy: false
                        )
                        .frame(width: 150, height: 220)
                        .scaleEffect(styleGodScale)
                        .offset(x: game.playerOffset)
                        .shadow(
                            color: game.activeStyle.tint.opacity(
                                playerAuraOpacity
                            ),
                            radius: playerAuraRadius
                        )
                        .shadow(
                            color: game.currentCharacter.tint.opacity(0.35),
                            radius: 8
                        )
                        .animation(
                            .snappy(duration: 0.12),
                            value: game.attackFrameIndex
                        )
                        .animation(
                            .snappy(duration: 0.2),
                            value: game.styleRank
                        )
                        .animation(
                            .snappy(duration: 0.18),
                            value: game.activeStyle
                        )
                        .animation(
                            .easeInOut(duration: 0.55).repeatForever(
                                autoreverses: true
                            ),
                            value: styleGodPulse
                        )

                        Spacer(minLength: 24)

                        FighterSprite(
                            assetName: game.enemyFrame,
                            fallbackTitle: game.isEnemyBroken
                                ? "BROKEN" : "ENEMY",
                            tint: game.flashHit ? .red : game.currentEnemy.tint,
                            isEnemy: true
                        )
                        .frame(width: 150, height: 220)
                        .scaleEffect(enemyScale)
                        .offset(x: game.flashHit ? 14 : 0)
                        .shadow(
                            color: game.currentEnemy.tint.opacity(
                                game.currentEnemy.isBoss ? 0.95 : 0.6
                            ),
                            radius: game.currentEnemy.glowRadius
                        )
                        .animation(
                            .snappy(duration: 0.08),
                            value: game.flashHit
                        )
                        .animation(
                            .snappy(duration: 0.2),
                            value: game.isEnemyBroken
                        )
                        .animation(
                            .easeInOut(duration: 0.58).repeatForever(
                                autoreverses: true
                            ),
                            value: styleGodPulse
                        )
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 24)

                    if game.isEnemyBroken {
                        Text("BROKEN")
                            .font(
                                .system(
                                    size: 42,
                                    weight: .black,
                                    design: .rounded
                                )
                            )
                            .foregroundStyle(game.currentEnemy.brokenColor)
                            .shadow(
                                color: game.currentEnemy.brokenColor.opacity(
                                    0.8
                                ),
                                radius: 10
                            )
                            .scaleEffect(brokenPulse ? 1.08 : 0.96)
                            .offset(x: 78, y: -210)
                            .animation(
                                .easeInOut(duration: 0.45).repeatForever(
                                    autoreverses: true
                                ),
                                value: brokenPulse
                            )
                            .transition(.scale.combined(with: .opacity))
                    }
                }
                .frame(maxWidth: .infinity)
                .frame(height: 300)
                .contentShape(Rectangle())

                bottomStatus
            }
            .padding(20)
            .offset(screenShakeOffset)

            Color.red
                .opacity(damageFlashOpacity)
                .ignoresSafeArea()
                .allowsHitTesting(false)

            Color.white
                .opacity(finisherFlashOpacity)
                .ignoresSafeArea()
                .allowsHitTesting(false)

            if game.isChoosingReward {
                rewardOverlay
            }

            if game.isGameOver {
                gameOverOverlay
            }

            if currentScreen == .run && isShowingFightIntro {
                FightIntroView(
                    fightLevel: game.fightLevel,
                    level: game.currentLevel,
                    enemy: game.currentEnemy,
                    character: game.currentCharacter,
                    start: {
                        playSound("menu")
                        isShowingFightIntro = false
                    }
                )
            }

            switch currentScreen {
            case .title:
                TitleScreenView {
                    playSound("menu")
                    triggerFinisherImpact()
                    currentScreen = .menu
                }
            case .menu:
                MainMenuView(
                    activeEvent: activeEvent,
                    eventBalance: activeEventBalance,
                    startRun: {
                        playSound("menu")
                        restartRun()
                        isShowingFightIntro = true
                        currentScreen = .run
                    },
                    openCharacterSelect: {
                        playSound("menu")
                        currentScreen = .characterSelect
                    },
                    openStyleLab: {
                        playSound("menu")
                        currentScreen = .styleLab
                    },
                    openGallery: {
                        playSound("menu")
                        currentScreen = .gallery
                    },
                    openEventShop: {
                        playSound("menu")
                        currentScreen = .eventShop
                    },
                    openSettings: {
                        playSound("menu")
                        currentScreen = .settings
                    }
                )
            case .characterSelect:
                CharacterSelectView(
                    characters: CharacterCatalog.shared.characters,
                    selectedCharacter: game.currentCharacter,
                    selectCharacter: { character in
                        playSound("menu")
                        game.currentCharacter = character
                        restartRun()
                    },
                    back: {
                        playSound("menu")
                        currentScreen = .menu
                    }
                )
            case .styleLab:
                StyleLabView {
                    playSound("menu")
                    currentScreen = .menu
                }
            case .gallery:
                GalleryView(
                    bestStyleRank: galleryBestStyleRank,
                    bestFightsCleared: galleryBestFightsCleared,
                    bestMaxCombo: galleryBestMaxCombo,
                    unlockedRewards: storedList(galleryUnlockedRewards),
                    bossVerdicts: storedList(galleryBossVerdicts),
                    back: {
                        playSound("menu")
                        currentScreen = .menu
                    }
                )
            case .eventShop:
                EventShopView(
                    event: activeEvent,
                    balance: activeEventBalance,
                    purchasedItemIds: purchasedEventItemIds,
                    buyItem: buyEventItem,
                    back: {
                        playSound("menu")
                        currentScreen = .menu
                    }
                )
            case .settings:
                SettingsView(
                    isSFXEnabled: $isSFXEnabled,
                    isScreenShakeEnabled: $isScreenShakeEnabled,
                    isFlashFXEnabled: $isFlashFXEnabled,
                    resetGalleryData: resetGalleryData,
                    back: {
                        playSound("menu")
                        currentScreen = .menu
                    }
                )
            case .run:
                EmptyView()
            }

            if isRemoteContentLoading || !isRemoteContentReady {
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
    }

    private var styleGodScale: CGFloat {
        guard game.styleRank == .styleGod else { return 1 }

        return styleGodPulse ? 1.17 : 1.09
    }

    private var playerAuraOpacity: Double {
        if game.styleRank == .styleGod {
            return 0.98
        }

        return 0.55 + Double(game.styleRank.score) * 0.12
    }

    private var playerAuraRadius: CGFloat {
        CGFloat(14 + game.styleRank.score * 6)
            + (game.styleRank == .styleGod && styleGodPulse ? 10 : 0)
    }

    private var enemyScale: CGFloat {
        let base = game.isEnemyBroken ? 0.88 : (game.flashHit ? 0.96 : 1)
        let bossPulse: CGFloat =
            game.currentEnemy.isBoss && styleGodPulse ? 1.06 : 1

        return base * game.currentEnemy.scale * bossPulse
    }

    private var activeEventBalance: Int {
        guard let activeEvent else { return 0 }
        return storedIntMap(eventCurrencyBalances)[
            activeEvent.currencyId,
            default: 0
        ]
    }

    private var purchasedEventItemIds: [String] {
        storedList(eventPurchasedItems)
    }

    private var header: some View {
        VStack(spacing: 12) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(game.styleRank.title)
                        .font(
                            .system(size: 24, weight: .black, design: .rounded)
                        )
                        .foregroundStyle(game.styleRank.color)
                        .tracking(1.2)

                    Text("STYLE \(game.style)%")
                        .font(
                            .system(
                                size: 11,
                                weight: .black,
                                design: .monospaced
                            )
                        )
                        .foregroundStyle(.white.opacity(0.7))
                }

                Spacer()

                VStack(alignment: .trailing, spacing: 4) {
                    Text(game.activeStyle.title)
                        .font(
                            .system(size: 15, weight: .black, design: .rounded)
                        )
                        .foregroundStyle(game.activeStyle.tint)
                        .tracking(1)

                    Text("FIGHT \(game.fightLevel)  HP \(game.playerHealth)%")
                        .font(
                            .system(
                                size: 11,
                                weight: .black,
                                design: .monospaced
                            )
                        )
                        .foregroundStyle(.white.opacity(0.72))

                    Text(game.currentCharacter.title)
                        .font(
                            .system(
                                size: 10,
                                weight: .black,
                                design: .monospaced
                            )
                        )
                        .foregroundStyle(
                            game.currentCharacter.tint.opacity(0.8)
                        )

                    Text("ENEMY IN \(game.enemyActionCountdown)")
                        .font(
                            .system(
                                size: 10,
                                weight: .black,
                                design: .monospaced
                            )
                        )
                        .foregroundStyle(.red.opacity(0.78))

                    Text(game.currentEnemy.title)
                        .font(
                            .system(
                                size: 11,
                                weight: .black,
                                design: .monospaced
                            )
                        )
                        .foregroundStyle(game.currentEnemy.tint.opacity(0.9))

                    Text(game.currentLevel.title)
                        .font(
                            .system(
                                size: 10,
                                weight: .black,
                                design: .monospaced
                            )
                        )
                        .foregroundStyle(
                            game.currentLevel.accentColor.opacity(0.82)
                        )
                }
            }

            styleMeter

            if !game.isEnemyBroken {
                healthBar
            }
        }
    }

    private var styleMeter: some View {
        GeometryReader { proxy in
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(.black.opacity(0.35))

                Capsule()
                    .fill(
                        LinearGradient(
                            colors: [.white, game.styleRank.color],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(
                        width: proxy.size.width * CGFloat(game.style)
                            / CGFloat(game.maxStyle)
                    )
            }
        }
        .frame(height: 10)
    }

    private var healthBar: some View {
        GeometryReader { proxy in
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(game.currentEnemy.tint.opacity(0.16))

                Capsule()
                    .fill(
                        LinearGradient(
                            colors: [.red, game.currentEnemy.tint],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(
                        width: proxy.size.width * CGFloat(game.enemyHealth)
                            / CGFloat(game.enemyMaxHealth)
                    )
            }
        }
        .frame(height: 12)
        .overlay(alignment: .trailing) {
            Text(
                game.isEnemyBroken
                    ? "BROKEN"
                    : "\(game.currentEnemy.title) \(game.enemyHealth)/\(game.enemyMaxHealth)"
            )
            .font(.system(size: 10, weight: .black, design: .monospaced))
            .foregroundStyle(.white.opacity(0.8))
            .padding(.trailing, 8)
        }
    }

    private var bottomStatus: some View {
        VStack(spacing: 6) {
            Text("BOSS: \(game.bossVerdict)")
                .font(.system(size: 12, weight: .black, design: .monospaced))
                .foregroundStyle(.white.opacity(0.82))

            Text(
                game.isEnemyBroken
                    ? "TAP FOR FINISHER / SWIPE STYLE"
                    : "TAP ATTACK / SWIPE STYLE"
            )
            .font(.system(size: 13, weight: .black, design: .rounded))
            .foregroundStyle(.white.opacity(0.58))
            .tracking(1.2)
        }
    }

    private var rewardOverlay: some View {
        ZStack {
            Color.black.opacity(0.72)
                .ignoresSafeArea()

            VStack(spacing: 16) {
                Text("CHOOSE YOUR STYLE")
                    .font(.system(size: 24, weight: .black, design: .rounded))
                    .foregroundStyle(.white)
                    .tracking(1.4)

                Text("FIGHT \(game.fightLevel + 1) WAITS")
                    .font(
                        .system(size: 11, weight: .black, design: .monospaced)
                    )
                    .foregroundStyle(.white.opacity(0.58))

                VStack(spacing: 10) {
                    ForEach(game.rewardChoices) { reward in
                        Button {
                            chooseReward(reward)
                        } label: {
                            VStack(alignment: .leading, spacing: 5) {
                                Text(reward.title)
                                    .font(
                                        .system(
                                            size: 16,
                                            weight: .black,
                                            design: .rounded
                                        )
                                    )
                                    .foregroundStyle(reward.color)

                                Text(reward.description)
                                    .font(
                                        .system(
                                            size: 12,
                                            weight: .bold,
                                            design: .monospaced
                                        )
                                    )
                                    .foregroundStyle(.white.opacity(0.74))
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(14)
                            .background(.black.opacity(0.58))
                            .overlay {
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(
                                        reward.color.opacity(0.7),
                                        lineWidth: 1
                                    )
                            }
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .padding(24)
        }
    }

    private var gameOverOverlay: some View {
        ZStack {
            Color.black.opacity(0.82)
                .ignoresSafeArea()

            VStack(spacing: 14) {
                Text("RUN ENDED")
                    .font(.system(size: 34, weight: .black, design: .rounded))
                    .foregroundStyle(.red)
                    .tracking(1.4)

                Text("BEST STYLE \(game.bestStyleRank.title)")
                    .font(.system(size: 16, weight: .black, design: .rounded))
                    .foregroundStyle(game.bestStyleRank.color)

                Text("FIGHTS CLEARED \(game.fightsCleared)")
                    .font(
                        .system(size: 12, weight: .black, design: .monospaced)
                    )
                    .foregroundStyle(.white.opacity(0.76))

                Text("MAX COMBO \(game.maxCombo)")
                    .font(
                        .system(size: 12, weight: .black, design: .monospaced)
                    )
                    .foregroundStyle(.white.opacity(0.76))

                Text("REWARDS \(game.rewardHistoryText)")
                    .font(
                        .system(size: 10, weight: .black, design: .monospaced)
                    )
                    .foregroundStyle(.white.opacity(0.64))
                    .multilineTextAlignment(.center)

                Text("BOSS: \(game.bossVerdict)")
                    .font(
                        .system(size: 12, weight: .black, design: .monospaced)
                    )
                    .foregroundStyle(.white.opacity(0.7))
                    .multilineTextAlignment(.center)

                Button {
                    playSound("menu")
                    restartRun()
                } label: {
                    Text("RESTART RUN")
                        .font(
                            .system(size: 17, weight: .black, design: .rounded)
                        )
                        .frame(maxWidth: .infinity)
                        .frame(height: 52)
                }
                .buttonStyle(.borderedProminent)
                .tint(.red)
                .padding(.top, 8)

                Button {
                    playSound("menu")
                    restartRun()
                    currentScreen = .menu
                } label: {
                    Text("MAIN MENU")
                        .font(
                            .system(size: 14, weight: .black, design: .rounded)
                        )
                        .frame(maxWidth: .infinity)
                        .frame(height: 44)
                }
                .buttonStyle(.bordered)
                .tint(.white)
            }
            .padding(24)
        }
    }

    private var arenaBackground: some View {
        ZStack {
            Color.black

            RadialGradient(
                colors: [game.currentLevel.accentColor.opacity(0.18), .clear],
                center: .center,
                startRadius: 40,
                endRadius: 320
            )

            VStack(spacing: 18) {
                ForEach(0..<18, id: \.self) { _ in
                    Rectangle()
                        .fill(.white.opacity(0.025))
                        .frame(height: 1)
                }
            }
        }
        .ignoresSafeArea()
    }

    private var floorGlow: some View {
        Color.clear
    }

    private var paintLayer: some View {
        Canvas { context, size in
            for stroke in game.paintStrokes {
                var path = Path()
                path.move(
                    to: CGPoint(
                        x: size.width * stroke.startX,
                        y: size.height * stroke.startY
                    )
                )
                path.addCurve(
                    to: CGPoint(
                        x: size.width * stroke.endX,
                        y: size.height * stroke.endY
                    ),
                    control1: CGPoint(
                        x: size.width * stroke.controlX,
                        y: size.height * stroke.controlY
                    ),
                    control2: CGPoint(
                        x: size.width * stroke.control2X,
                        y: size.height * stroke.control2Y
                    )
                )

                context.stroke(
                    path,
                    with: .color(stroke.color.opacity(stroke.opacity)),
                    style: StrokeStyle(
                        lineWidth: stroke.lineWidth,
                        lineCap: .round,
                        lineJoin: .round
                    )
                )
            }
        }
        .blur(radius: 0.4)
        .allowsHitTesting(false)
    }

    private func startAttack() {
        guard isRemoteContentReady else { return }
        guard currentScreen == .run, !game.isChoosingReward, !game.isGameOver
        else { return }
        guard !isShowingFightIntro else {
            playSound("menu")
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
        isRemoteContentLoading = true
        remoteContentStatus = "CONNECTING TO STYLE SERVER"

        await RemoteContentStore.shared.refresh()
        isRemoteContentReady = RemoteContentStore.shared.isOnline
        remoteContentStatus = RemoteContentStore.shared.statusMessage

        if isRemoteContentReady {
            game.refreshDataDefinitions()
            remoteContentRefreshID = UUID()
        }

        isRemoteContentLoading = false
    }

    private func chooseReward(_ reward: RunReward) {
        handleEvents(game.chooseReward(reward))
    }

    private func restartRun() {
        game.restartRun()
        screenShakeOffset = .zero
        damageFlashOpacity = 0
        finisherFlashOpacity = 0
        brokenPulse = false
    }

    private func handleEvents(_ events: [GameEvent]) {
        for event in events {
            switch event {
            case .sound(let name):
                playSound(name)
            case .screenShake(let intensity):
                triggerScreenShake(intensity: intensity)
            case .playerHitImpact:
                triggerPlayerHitImpact()
            case .finisherImpact:
                triggerFinisherImpact()
            case .persistRunProgress(let verdict):
                persistRunProgress(verdict: verdict)
            case .unlockReward(let rewardTitle):
                appendStoredValue(rewardTitle, to: &galleryUnlockedRewards)
                isShowingFightIntro = true
            case .awardEventCurrency(let amount, let currencyId):
                addEventCurrency(amount, currencyId: currencyId)
            }
        }
    }

    private func buyEventItem(_ item: EventShopItem) {
        guard let activeEvent else { return }
        var balances = storedIntMap(eventCurrencyBalances)
        let currentBalance = balances[activeEvent.currencyId, default: 0]
        guard currentBalance >= item.cost,
            !purchasedEventItemIds.contains(item.id)
        else { return }

        balances[activeEvent.currencyId] = currentBalance - item.cost
        eventCurrencyBalances = encodeIntMap(balances)
        appendStoredValue(item.id, to: &eventPurchasedItems)
        playSound("reward")
    }

    private func addEventCurrency(_ amount: Int, currencyId: String) {
        guard amount > 0 else { return }

        var balances = storedIntMap(eventCurrencyBalances)
        balances[currencyId, default: 0] += amount
        eventCurrencyBalances = encodeIntMap(balances)
    }

    private func persistRunProgress(verdict: String) {
        galleryBestFightsCleared = max(
            galleryBestFightsCleared,
            game.fightsCleared
        )
        galleryBestMaxCombo = max(galleryBestMaxCombo, game.maxCombo)
        galleryBestStyleScore = max(
            galleryBestStyleScore,
            game.bestStyleRank.score
        )
        appendStoredValue(verdict, to: &galleryBossVerdicts)
    }

    private func appendStoredValue(_ value: String, to storage: inout String) {
        var values = storedList(storage)
        guard !values.contains(value) else { return }

        values.append(value)
        storage = values.joined(separator: "|")
    }

    private func storedList(_ storage: String) -> [String] {
        storage
            .split(separator: "|")
            .map(String.init)
            .filter { !$0.isEmpty }
    }

    private func storedIntMap(_ storage: String) -> [String: Int] {
        Dictionary(
            uniqueKeysWithValues: storage.split(separator: "|").compactMap {
                pair in
                let parts = pair.split(separator: ":", maxSplits: 1).map(
                    String.init
                )
                guard parts.count == 2, let value = Int(parts[1]) else {
                    return nil
                }
                return (parts[0], value)
            }
        )
    }

    private func encodeIntMap(_ map: [String: Int]) -> String {
        map
            .sorted { $0.key < $1.key }
            .map { "\($0.key):\($0.value)" }
            .joined(separator: "|")
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

    private func playSound(_ name: String) {
        guard isSFXEnabled else { return }
        playRemoteSound(name)
    }

    private func playRemoteSound(_ name: String) {
        let player = AVPlayer(
            url: RemoteContentStore.shared.musicURL(
                named: name,
                fileExtension: "wav"
            )
        )
        player.play()
        remoteAudioPlayers[name] = player
    }

    private func resetGalleryData() {
        playSound("menu")
        galleryBestFightsCleared = 0
        galleryBestMaxCombo = 0
        galleryBestStyleScore = 0
        galleryUnlockedRewards = ""
        galleryBossVerdicts = ""
        eventCurrencyBalances = ""
        eventPurchasedItems = ""
    }

}

#Preview {
    ContentView()
}
