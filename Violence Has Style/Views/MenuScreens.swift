//
//  MenuScreens.swift
//  Violence Has Style
//
//  Created by Tufan Cakir on 30.05.26.
//

import SwiftUI

struct TitleScreenView: View {

    let start: () -> Void

    var body: some View {
        let theme = ThemeManager.shared.currentTheme
        let typography = RemoteContentStore.shared.uiConfig.typography

        ZStack {
            titleBackground

            ThemeBackgroundView()
                .ignoresSafeArea()

            VStack(spacing: 22) {
                Spacer()

                logo
                    .frame(maxWidth: 300)
                    .frame(height: 180)
                    .shadow(
                        color: theme.secondaryColor.opacity(0.8),
                        radius: 18
                    )

                VStack(spacing: 2) {
                    Text("VIOLENCE")
                        .font(
                            .vhs(size: 42, weight: .black, design: .rounded)
                        )
                        .foregroundStyle(typography.primaryTextColor)

                    Text("HAS STYLE")
                        .font(
                            .vhs(size: 42, weight: .black, design: .rounded)
                        )
                        .foregroundStyle(typography.secondaryTextColor)
                }
                .tracking(1.2)

                Spacer()

                Text("TAP TO START")
                    .font(
                        .vhs(size: 13, weight: .black, design: .monospaced)
                    )
                    .foregroundStyle(typography.mutedTextColor.opacity(0.9))
                    .tracking(1.4)
                    .padding(.bottom, 28)
            }
            .padding(28)

            VStack(spacing: 12) {
                ForEach(0..<18, id: \.self) { _ in
                    Rectangle()
                        .fill(.white.opacity(0.035))
                        .frame(height: 1)
                }
            }
            .allowsHitTesting(false)
        }
        .contentShape(Rectangle())
        .onTapGesture {
            start()
        }
    }

    private var titleBackground: some View {
        ThemeBackgroundView()
    }

    private var logo: some View {
        let logoAssetId =
            RemoteContentStore.shared.uiConfig.titleLogoAssetId
            ?? "logo_vhs_purple"

        return AsyncImage(
            url: RemoteContentStore.shared.assetURL(named: logoAssetId)
        ) {
            phase in
            if let image = phase.image {
                image
                    .resizable()
                    .scaledToFit()
            } else {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(
                            ThemeManager.shared.currentTheme.secondaryColor
                                .opacity(0.8),
                            lineWidth: 2
                        )
                        .background(
                            ThemeManager.shared.currentTheme.panelColor.opacity(
                                0.42
                            )
                        )

                    Text("Violence Has Style")
                        .font(
                            .vhs(size: 54, weight: .black, design: .rounded)
                        )
                        .foregroundStyle(
                            RemoteContentStore.shared.uiConfig.typography
                                .primaryTextColor
                        )
                        .tracking(3)
                }
            }
        }
    }
}

struct OnlineRequiredView: View {
    let isLoading: Bool
    let status: String
    let retry: () -> Void

    var body: some View {
        ZStack {
            ThemeBackgroundView()

            VStack(spacing: 20) {
                Spacer()

                Text("VIOLENCE")
                    .font(.vhs(size: 40, weight: .black, design: .rounded))
                    .foregroundStyle(.white)

                Text("HAS STYLE")
                    .font(.vhs(size: 40, weight: .black, design: .rounded))
                    .foregroundStyle(.red)

                VStack(spacing: 10) {
                    Text(isLoading ? "LOADING REMOTE GAME" : "ONLINE REQUIRED")
                        .font(
                            .vhs(
                                size: 14,
                                weight: .black,
                                design: .monospaced
                            )
                        )
                        .foregroundStyle(.white.opacity(0.78))

                    Text(
                        isLoading
                            ? "Loading live game data. Media continues in the background."
                            : "This game needs WLAN or mobile data because gameplay data and media are loaded online."
                    )
                    .font(
                        .vhs(
                            size: 12,
                            weight: .bold,
                            design: .rounded
                        )
                    )
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.white.opacity(0.62))
                    .fixedSize(horizontal: false, vertical: true)

                    Text(status)
                        .font(
                            .vhs(
                                size: 10,
                                weight: .black,
                                design: .monospaced
                            )
                        )
                        .foregroundStyle(.red.opacity(0.85))
                }
                .padding(.top, 8)
                .padding(18)
                .frame(maxWidth: .infinity)
                .background(
                    ThemeManager.shared.currentTheme.panelColor.opacity(0.62)
                )
                .overlay {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(
                            ThemeManager.shared.currentTheme.primaryColor
                                .opacity(0.42),
                            lineWidth: 1
                        )
                }
                .clipShape(RoundedRectangle(cornerRadius: 8))

                if isLoading {
                    ProgressView()
                        .tint(.red)
                } else {
                    Button(action: retry) {
                        Text("RETRY CONNECTION")
                            .font(
                                .vhs(
                                    size: 15,
                                    weight: .black,
                                    design: .rounded
                                )
                            )
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.red)
                    .padding(.top, 8)

                    Text("WLAN OR MOBILE DATA NEEDED")
                        .font(
                            .vhs(
                                size: 10,
                                weight: .black,
                                design: .monospaced
                            )
                        )
                        .foregroundStyle(.white.opacity(0.52))
                }

                Spacer()
            }
            .padding(28)
        }
    }
}

struct RemoteLoadingView: View {
    let isLoading: Bool
    let status: String
    let progress: Double
    let loadedItems: Int
    let totalItems: Int
    let downloadedBytes: Int
    let estimatedTotalBytes: Int
    let retry: () -> Void

    var body: some View {
        ZStack {
            ThemeBackgroundView()

            VStack(spacing: 18) {
                Spacer()

                VStack(spacing: 4) {
                    Text("SETTING UP")
                        .font(
                            .vhs(size: 28, weight: .black, design: .rounded)
                        )
                        .foregroundStyle(.white)

                    Text("VIOLENCE HAS STYLE")
                        .font(
                            .vhs(size: 26, weight: .black, design: .rounded)
                        )
                        .foregroundStyle(
                            ThemeManager.shared.currentTheme.primaryColor
                        )
                }

                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Text(
                            isLoading
                                ? "LOADING EVENTS AND REWARDS"
                                : "CONTENT UPDATE FAILED"
                        )
                        .font(
                            .vhs(
                                size: 13,
                                weight: .black,
                                design: .monospaced
                            )
                        )
                        .foregroundStyle(.white.opacity(0.78))

                        Spacer()

                        Text("\(Int(progress * 100))%")
                            .font(
                                .vhs(
                                    size: 13,
                                    weight: .black,
                                    design: .monospaced
                                )
                            )
                            .foregroundStyle(
                                ThemeManager.shared.currentTheme.accentColor
                            )
                    }

                    ProgressView(value: min(1, max(0, progress)))
                        .tint(ThemeManager.shared.currentTheme.primaryColor)

                    HStack {
                        Text("\(loadedItems)/\(max(1, totalItems)) FILES")
                        Spacer()
                        Text(
                            "\(megabytes(downloadedBytes)) / \(megabytes(estimatedTotalBytes)) MB"
                        )
                    }
                    .font(
                        .vhs(size: 10, weight: .black, design: .monospaced)
                    )
                    .foregroundStyle(.white.opacity(0.56))

                    Text(status)
                        .font(
                            .vhs(
                                size: 10,
                                weight: .black,
                                design: .monospaced
                            )
                        )
                        .foregroundStyle(
                            ThemeManager.shared.currentTheme.secondaryColor
                        )
                        .lineLimit(2)
                        .minimumScaleFactor(0.7)

                    Text(helpText)
                        .font(
                            .vhs(size: 12, weight: .bold, design: .rounded)
                        )
                        .foregroundStyle(.white.opacity(0.62))
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(18)
                .background(
                    ThemeManager.shared.currentTheme.panelColor.opacity(0.66)
                )
                .overlay {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(
                            ThemeManager.shared.currentTheme.primaryColor
                                .opacity(0.46),
                            lineWidth: 1
                        )
                }
                .clipShape(RoundedRectangle(cornerRadius: 8))

                if !isLoading {
                    Button(action: retry) {
                        Text("TRY AGAIN")
                            .font(
                                .vhs(
                                    size: 15,
                                    weight: .black,
                                    design: .rounded
                                )
                            )
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(ThemeManager.shared.currentTheme.primaryColor)
                }

                Spacer()
            }
            .padding(28)
        }
    }

    private func megabytes(_ bytes: Int) -> String {
        String(format: "%.1f", Double(bytes) / 1_000_000)
    }

    private var helpText: String {
        if isLoading {
            return
                "The game is getting the latest events, rewards and balance data. If one update file is missing, bundled content will be used so the game can still start."
        }

        return
            "Your internet is connected, but the content update did not finish. Try again in a moment."
    }
}

struct OfflineView: View {
    var body: some View {
        ZStack {
            ThemeManager.shared.currentTheme.backgroundColor
                .ignoresSafeArea()

            VStack(spacing: 16) {
                Text("OFFLINE")
                    .font(.vhs(size: 42, weight: .black, design: .rounded))
                    .foregroundStyle(.red)

                Text("INTERNET REQUIRED")
                    .font(
                        .vhs(size: 14, weight: .black, design: .monospaced)
                    )
                    .foregroundStyle(.white.opacity(0.78))

                Text("WLAN OR MOBILE DATA")
                    .font(
                        .vhs(size: 10, weight: .black, design: .monospaced)
                    )
                    .foregroundStyle(.white.opacity(0.52))
            }
            .padding(28)
        }
    }
}

struct MainMenuView: View {
    let presentedCharacter: PlayerCharacter
    let activeEvent: EventDefinition?
    let eventBalance: Int
    let openStoryMode: () -> Void
    let openEventMode: () -> Void
    let openEndlessMode: () -> Void
    let openCharacterSelect: () -> Void
    let openStyleMode: () -> Void
    let openGallery: () -> Void
    let openStylePasses: () -> Void
    let openGiftBox: () -> Void
    let backToTitle: () -> Void
    let openSettings: () -> Void

    var body: some View {
        let theme = ThemeManager.shared.currentTheme

        ZStack {
            ThemeBackgroundView()
                .ignoresSafeArea()

            FighterSprite(
                assetName: presentedCharacter.idleAsset,
                fallbackTitle: presentedCharacter.title,
                tint: presentedCharacter.tint,
                isEnemy: false
            )
            .frame(width: 220, height: 310)
            .opacity(0.22)
            .offset(x: 116, y: -4)
            .allowsHitTesting(false)

            VStack(alignment: .leading, spacing: 10) {
                VStack(spacing: 6) {
                    MenuActionButton(
                        title: "STORY MODE",
                        color: theme.primaryColor,
                        action: openStoryMode
                    )
                    MenuActionButton(
                        title: "ENDLESS MODE",
                        color: theme.secondaryColor,
                        action: openEndlessMode
                    )
                    if let activeEvent {
                        MenuActionButton(
                            title: "\(activeEvent.title) EVENT",
                            color: activeEvent.themeColor,
                            action: openEventMode
                        )
                    }
                    MenuActionButton(
                        title: "STYLE MODE",
                        color: theme.accentColor,
                        action: openStyleMode
                    )
                    MenuActionButton(
                        title: "CHARACTER SELECT",
                        color: theme.primaryColor.opacity(0.88),
                        action: openCharacterSelect
                    )
                    MenuActionButton(
                        title: "GALLERY",
                        color: theme.secondaryColor.opacity(0.9),
                        action: openGallery
                    )
                    MenuActionButton(
                        title: "STYLE PASS",
                        color: theme.accentColor.opacity(0.9),
                        action: openStylePasses
                    )
                    MenuActionButton(
                        title: "GIFT BOX",
                        color: theme.secondaryColor.opacity(0.8),
                        action: openGiftBox
                    )
                    MenuActionButton(
                        title: "TITLE SCREEN",
                        color: theme.accentColor.opacity(0.75),
                        action: backToTitle
                    )
                    MenuActionButton(
                        title: "SETTINGS",
                        color: theme.primaryColor.opacity(0.75),
                        action: openSettings
                    )
                }

                Spacer()

                Text("TAP ATTACK. SWIPE STYLE. KILL WITH STYLE.")
                    .font(
                        .vhs(size: 10, weight: .black, design: .monospaced)
                    )
                    .foregroundStyle(.white.opacity(0.55))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 24)
            .padding(.top, 18)
            .padding(.bottom, 18)
        }
    }
}

struct EventShopView: View {
    let event: EventDefinition?
    let balance: Int
    let purchasedItemIds: [String]
    let buyItem: (EventShopItem) -> Void
    let back: () -> Void

    var body: some View {
        ZStack {
            ThemeBackgroundView()
                .ignoresSafeArea()

            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Text("EVENT SHOP")
                        .font(
                            .vhs(size: 30, weight: .black, design: .rounded)
                        )
                        .foregroundStyle(.white)

                    Spacer()

                    BackButton(action: back)
                }

                if let event {

                    HStack(spacing: 6) {
                        Image(systemName: event.currencySymbol ?? "drop.fill")
                            .font(.vhs(size: 18, weight: .black))
                            .foregroundStyle(event.themeColor)
                            .frame(width: 20, height: 20)

                        Text("\(balance) \(event.currencyTitle)")
                            .font(
                                .vhs(
                                    size: 12,
                                    weight: .black,
                                    design: .monospaced
                                )
                            )
                            .foregroundStyle(.white.opacity(0.72))
                    }

                    VStack(spacing: 10) {
                        ForEach(event.shopItems) { item in
                            Button {
                                buyItem(item)
                            } label: {
                                HStack(spacing: 12) {
                                    Circle()
                                        .fill(item.color)
                                        .frame(width: 18, height: 18)
                                        .shadow(
                                            color: item.color.opacity(0.8),
                                            radius: 8
                                        )

                                    VStack(alignment: .leading, spacing: 5) {
                                        Text(item.title)
                                            .font(
                                                .vhs(
                                                    size: 15,
                                                    weight: .black,
                                                    design: .rounded
                                                )
                                            )
                                            .foregroundStyle(item.color)

                                        Text(item.description)
                                            .font(
                                                .vhs(
                                                    size: 10,
                                                    weight: .bold,
                                                    design: .monospaced
                                                )
                                            )
                                            .foregroundStyle(
                                                .white.opacity(0.66)
                                            )
                                    }

                                    Spacer()

                                    Text(
                                        purchasedItemIds.contains(item.id)
                                            ? "OWNED" : "\(item.cost)"
                                    )
                                    .font(
                                        .vhs(
                                            size: 11,
                                            weight: .black,
                                            design: .monospaced
                                        )
                                    )
                                    .foregroundStyle(
                                        purchasedItemIds.contains(item.id)
                                            ? .white : event.themeColor
                                    )
                                }
                                .padding(13)
                                .background(
                                    ThemeManager.shared.currentTheme.panelColor
                                        .opacity(0.5)
                                )
                                .overlay {
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(
                                            item.color.opacity(0.65),
                                            lineWidth: 1
                                        )
                                }
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                            }
                            .buttonStyle(.plain)
                            .disabled(
                                purchasedItemIds.contains(item.id)
                                    || balance < item.cost
                            )
                            .opacity(
                                purchasedItemIds.contains(item.id)
                                    || balance >= item.cost ? 1 : 0.45
                            )
                        }
                    }
                } else {
                    Text("NO ACTIVE EVENT")
                        .font(
                            .vhs(
                                size: 14,
                                weight: .black,
                                design: .monospaced
                            )
                        )
                        .foregroundStyle(.white.opacity(0.6))
                }

                Spacer()
            }
            .padding(24)
        }
    }
}

struct StoryModeView: View {
    let chapters: [StoryChapter]
    let completedChapterCount: Int
    let startChapter: (StoryChapter) -> Void
    let back: () -> Void

    var body: some View {
        let theme = ThemeManager.shared.currentTheme

        ZStack {
            ThemeBackgroundView()
                .ignoresSafeArea()

            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text("STORY MODE")
                        .font(
                            .vhs(size: 24, weight: .black, design: .rounded)
                        )
                        .foregroundStyle(.white)

                    Spacer()

                    BackButton(action: back)
                }

                ScrollView(showsIndicators: false) {
                    LazyVStack(spacing: 8) {
                        ForEach(chapters) { chapter in
                            let isUnlocked =
                                chapter.requiredChapter <= completedChapterCount
                            Button {
                                startChapter(chapter)
                            } label: {
                                VStack(alignment: .leading, spacing: 5) {
                                    HStack(spacing: 8) {
                                        Text(chapter.title)
                                            .font(
                                                .vhs(
                                                    size: 15,
                                                    weight: .black,
                                                    design: .rounded
                                                )
                                            )
                                            .foregroundStyle(
                                                isUnlocked
                                                    ? chapter.color : .gray
                                            )
                                            .lineLimit(1)
                                            .minimumScaleFactor(0.7)

                                        Spacer()

                                        Text(isUnlocked ? "READY" : "LOCKED")
                                            .font(
                                                .vhs(
                                                    size: 9,
                                                    weight: .black,
                                                    design: .monospaced
                                                )
                                            )
                                            .foregroundStyle(
                                                isUnlocked ? .white : .gray
                                            )
                                    }

                                    Text(chapter.subtitle)
                                        .font(
                                            .vhs(
                                                size: 10,
                                                weight: .bold,
                                                design: .monospaced
                                            )
                                        )
                                        .foregroundStyle(
                                            .white.opacity(
                                                isUnlocked ? 0.68 : 0.35
                                            )
                                        )
                                        .lineLimit(2)

                                    HStack {
                                        Text("\(chapter.targetFights) FIGHTS")
                                            .font(
                                                .vhs(
                                                    size: 9,
                                                    weight: .black,
                                                    design: .monospaced
                                                )
                                            )
                                            .foregroundStyle(
                                                chapter.color.opacity(
                                                    isUnlocked ? 0.8 : 0.35
                                                )
                                            )

                                        Spacer()

                                        Text("CH \(chapter.id.uppercased())")
                                            .font(
                                                .vhs(
                                                    size: 8,
                                                    weight: .black,
                                                    design: .monospaced
                                                )
                                            )
                                            .foregroundStyle(
                                                theme.textColor.opacity(0.35)
                                            )
                                            .lineLimit(1)
                                    }
                                }
                                .padding(.horizontal, 12)
                                .padding(.vertical, 10)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(theme.panelColor.opacity(0.5))
                                .overlay {
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(
                                            chapter.color.opacity(
                                                isUnlocked ? 0.7 : 0.22
                                            ),
                                            lineWidth: 1
                                        )
                                }
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                            }
                            .buttonStyle(.plain)
                            .disabled(!isUnlocked)
                        }
                    }
                }

                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.top, 18)
            .padding(.bottom, 14)
        }
    }
}

struct EventModeView: View {
    let events: [EventDefinition]
    let selectedEventId: String?
    let balanceForEvent: (EventDefinition) -> Int
    let selectEvent: (EventDefinition) -> Void
    let startEventRun: (EventDefinition) -> Void
    let openShop: (EventDefinition) -> Void
    let back: () -> Void

    var body: some View {
        ZStack {
            ThemeBackgroundView()
                .ignoresSafeArea()

            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Text("EVENT MODE")
                        .font(
                            .vhs(size: 30, weight: .black, design: .rounded)
                        )
                        .foregroundStyle(.white)

                    Spacer()

                    BackButton(action: back)
                }

                if events.isEmpty {
                    Text("NO ACTIVE EVENT")
                        .font(
                            .vhs(
                                size: 14,
                                weight: .black,
                                design: .monospaced
                            )
                        )
                        .foregroundStyle(.white.opacity(0.6))
                } else {
                    ScrollView {
                        VStack(spacing: 12) {
                            ForEach(events) { event in
                                EventSelectionCard(
                                    event: event,
                                    balance: balanceForEvent(event),
                                    isSelected: selectedEventId == event.id,
                                    selectEvent: { selectEvent(event) },
                                    startEventRun: { startEventRun(event) },
                                    openShop: { openShop(event) }
                                )
                            }
                        }
                    }
                }

                Spacer()
            }
            .padding(24)
        }
    }
}

private struct EventSelectionCard: View {
    let event: EventDefinition
    let balance: Int
    let isSelected: Bool
    let selectEvent: () -> Void
    let startEventRun: () -> Void
    let openShop: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Button(action: selectEvent) {
                HStack(spacing: 10) {
                    Image(systemName: event.currencySymbol ?? "sparkles")
                        .font(.vhs(size: 21, weight: .black))
                        .foregroundStyle(event.themeColor)
                        .frame(width: 28)

                    VStack(alignment: .leading, spacing: 3) {
                        HStack(spacing: 8) {
                            Text(event.title)
                                .font(
                                    .vhs(
                                        size: 18,
                                        weight: .black,
                                        design: .rounded
                                    )
                                )
                                .foregroundStyle(.white)

                            Text(statusText)
                                .font(
                                    .vhs(
                                        size: 9,
                                        weight: .black,
                                        design: .monospaced
                                    )
                                )
                                .foregroundStyle(event.themeColor)
                        }

                        Text("\(balance) \(event.currencyTitle)")
                            .font(
                                .vhs(
                                    size: 10,
                                    weight: .black,
                                    design: .monospaced
                                )
                            )
                            .foregroundStyle(.white.opacity(0.6))
                    }

                    Spacer()

                    if isSelected {
                        Text("SELECTED")
                            .font(
                                .vhs(
                                    size: 9,
                                    weight: .black,
                                    design: .monospaced
                                )
                            )
                            .foregroundStyle(event.themeColor)
                    }
                }
            }
            .buttonStyle(.plain)

            EventCountdownView(event: event)

            HStack(spacing: 10) {
                Button(action: startEventRun) {
                    Text(event.isActive ? "START RUN" : "COMING SOON")
                        .font(
                            .vhs(
                                size: 11,
                                weight: .black,
                                design: .monospaced
                            )
                        )
                        .frame(maxWidth: .infinity)
                        .frame(height: 38)
                }
                .buttonStyle(.borderedProminent)
                .tint(event.themeColor)
                .disabled(!event.isActive)

                Button(action: openShop) {
                    Text("SHOP")
                        .font(
                            .vhs(
                                size: 11,
                                weight: .black,
                                design: .monospaced
                            )
                        )
                        .frame(maxWidth: .infinity)
                        .frame(height: 38)
                }
                .buttonStyle(.bordered)
                .tint(.white)
            }
        }
        .padding(12)
        .background(ThemeManager.shared.currentTheme.panelColor.opacity(0.58))
        .overlay {
            RoundedRectangle(cornerRadius: 8)
                .stroke(
                    isSelected ? event.themeColor : .white.opacity(0.15),
                    lineWidth: 1
                )
        }
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }

    private var statusText: String {
        if event.isActive {
            return "ACTIVE"
        }

        if event.isUpcoming {
            return "UPCOMING"
        }

        return "ENDED"
    }
}

private struct EventCountdownView: View {
    let event: EventDefinition

    var body: some View {
        HStack {
            Image(systemName: "timer")

            Text(labelText)

            Spacer()

            Text(countdownText)
        }
        .font(.vhs(size: 12, weight: .black, design: .monospaced))
        .foregroundStyle(.white)
        .padding(12)
        .background(ThemeManager.shared.currentTheme.panelColor.opacity(0.55))
        .overlay {
            RoundedRectangle(cornerRadius: 8)
                .stroke(event.themeColor.opacity(0.7), lineWidth: 1)
        }
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }

    private var countdownText: String {
        let targetDate =
            event.isUpcoming ? event.startsAtDate : event.endsAtDate
        guard let targetDate else { return event.endsAt }

        let remaining = max(0, Int(targetDate.timeIntervalSince(Date())))
        let days = remaining / 86_400
        let hours = (remaining % 86_400) / 3_600
        let minutes = (remaining % 3_600) / 60

        if days > 0 {
            return "\(days)D \(hours)H"
        }

        return "\(hours)H \(minutes)M"
    }

    private var labelText: String {
        event.isUpcoming ? "STARTS IN" : "ENDS IN"
    }
}

struct EndlessModeView: View {
    let highScore: Int
    let bestFights: Int
    let startEndless: () -> Void
    let back: () -> Void

    var body: some View {
        ZStack {
            ThemeBackgroundView()
                .ignoresSafeArea()

            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Text("ENDLESS MODE")
                        .font(
                            .vhs(size: 30, weight: .black, design: .rounded)
                        )
                        .foregroundStyle(.white)

                    Spacer()

                    BackButton(action: back)
                }

                GallerySection(title: "BEST ENDLESS") {
                    VStack(alignment: .leading, spacing: 8) {
                        GalleryLine(
                            label: "HIGH SCORE",
                            value: "\(highScore)",
                            color: .orange
                        )
                        GalleryLine(
                            label: "FIGHTS",
                            value: "\(bestFights)",
                            color: .red
                        )
                    }
                }

                MenuActionButton(
                    title: "START ENDLESS",
                    color: .orange,
                    action: startEndless
                )

                Spacer()
            }
            .padding(24)
        }
    }
}

struct StyleLabView: View {
    let back: () -> Void

    var body: some View {
        ZStack {
            ThemeBackgroundView()
                .ignoresSafeArea()

            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Text("STYLE LAB")
                        .font(
                            .vhs(size: 30, weight: .black, design: .rounded)
                        )
                        .foregroundStyle(.white)

                    Spacer()

                    BackButton(action: back)
                }

                VStack(spacing: 10) {
                    ForEach(CombatStyle.allCases, id: \.self) { style in
                        VStack(alignment: .leading, spacing: 5) {
                            Text(style.title)
                                .font(
                                    .vhs(
                                        size: 16,
                                        weight: .black,
                                        design: .rounded
                                    )
                                )
                                .foregroundStyle(style.tint)

                            Text(style.labDescription)
                                .font(
                                    .vhs(
                                        size: 11,
                                        weight: .bold,
                                        design: .monospaced
                                    )
                                )
                                .foregroundStyle(.white.opacity(0.72))
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(13)
                        .background(
                            ThemeManager.shared.currentTheme.panelColor.opacity(
                                0.5
                            )
                        )
                        .overlay {
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(style.tint.opacity(0.65), lineWidth: 1)
                        }
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                }

                Spacer()
            }
            .padding(24)
        }
    }
}

struct CharacterSelectView: View {
    let characters: [PlayerCharacter]
    let selectedCharacter: PlayerCharacter
    let selectCharacter: (PlayerCharacter) -> Void
    let back: () -> Void

    var body: some View {
        ZStack {
            ThemeBackgroundView()
                .ignoresSafeArea()

            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Text("CHARACTER SELECT")
                        .font(
                            .vhs(size: 26, weight: .black, design: .rounded)
                        )
                        .foregroundStyle(.white)

                    Spacer()

                    BackButton(action: back)
                }

                VStack(spacing: 10) {
                    ForEach(characters) { character in
                        Button {
                            selectCharacter(character)
                        } label: {
                            HStack(spacing: 12) {
                                FighterSprite(
                                    assetName: character.idleAsset,
                                    fallbackTitle: character.title,
                                    tint: character.tint,
                                    isEnemy: false
                                )
                                .frame(width: 64, height: 64)
                                .shadow(
                                    color: character.tint.opacity(0.75),
                                    radius: 8
                                )

                                VStack(alignment: .leading, spacing: 5) {
                                    Text(character.title)
                                        .font(
                                            .vhs(
                                                size: 16,
                                                weight: .black,
                                                design: .rounded
                                            )
                                        )
                                        .foregroundStyle(character.tint)

                                    Text(characterSummary(character))
                                        .font(
                                            .vhs(
                                                size: 10,
                                                weight: .bold,
                                                design: .monospaced
                                            )
                                        )
                                        .foregroundStyle(.white.opacity(0.68))
                                }

                                Spacer()

                                if character.id == selectedCharacter.id {
                                    Text("SELECTED")
                                        .font(
                                            .vhs(
                                                size: 10,
                                                weight: .black,
                                                design: .monospaced
                                            )
                                        )
                                        .foregroundStyle(.white)
                                }
                            }
                            .padding(13)
                            .background(
                                ThemeManager.shared.currentTheme.panelColor
                                    .opacity(0.5)
                            )
                            .overlay {
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(
                                        character.id == selectedCharacter.id
                                            ? character.tint
                                            : .white.opacity(0.14),
                                        lineWidth: 1
                                    )
                            }
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                        .buttonStyle(.plain)
                    }
                }

                Spacer()
            }
            .padding(24)
        }
    }

    private func characterSummary(_ character: PlayerCharacter) -> String {
        "HP \(character.maxHP) / DMG \(signed(character.damageBonus)) / STYLE \(signed(character.styleGainBonus)) / BLOOD \(signed(-character.bloodCostModifier))"
    }

    private func signed(_ value: Int) -> String {
        value >= 0 ? "+\(value)" : "\(value)"
    }
}

struct FightIntroView: View {
    let fightLevel: Int
    let level: LevelDefinition
    let enemy: EnemyType
    let character: PlayerCharacter
    let start: () -> Void

    var body: some View {
        ZStack {
            ThemeBackgroundView()
                .ignoresSafeArea()

            VStack(alignment: .leading, spacing: 16) {
                Spacer()

                Text(enemy.isBoss ? "BOSS FIGHT" : "FIGHT \(fightLevel)")
                    .font(
                        .vhs(
                            size: enemy.isBoss ? 42 : 34,
                            weight: .black,
                            design: .rounded
                        )
                    )
                    .foregroundStyle(enemy.isBoss ? enemy.brokenColor : .white)
                    .tracking(1.4)

                VStack(alignment: .leading, spacing: 6) {
                    Text(level.title)
                        .font(
                            .vhs(size: 18, weight: .black, design: .rounded)
                        )
                        .foregroundStyle(level.accentColor)

                    Text(level.moodText)
                        .font(
                            .vhs(
                                size: 11,
                                weight: .black,
                                design: .monospaced
                            )
                        )
                        .foregroundStyle(.white.opacity(0.62))
                }

                HStack(spacing: 12) {
                    introStat(
                        title: "CHARACTER",
                        value: character.title,
                        color: character.tint
                    )
                    introStat(
                        title: "ENEMY",
                        value: enemy.title,
                        color: enemy.tint
                    )
                }

                Spacer()

                Text("TAP TO ENTER")
                    .font(
                        .vhs(size: 12, weight: .black, design: .monospaced)
                    )
                    .foregroundStyle(.white.opacity(0.66))
                    .tracking(1.3)
                    .padding(.bottom, 16)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(28)

            if enemy.isBoss {
                Rectangle()
                    .stroke(enemy.brokenColor.opacity(0.85), lineWidth: 3)
                    .padding(12)
                    .allowsHitTesting(false)
            }
        }
        .contentShape(Rectangle())
        .onTapGesture {
            start()
        }
    }

    private func introStat(title: String, value: String, color: Color)
        -> some View
    {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.vhs(size: 9, weight: .black, design: .monospaced))
                .foregroundStyle(.white.opacity(0.5))

            Text(value)
                .font(.vhs(size: 12, weight: .black, design: .rounded))
                .foregroundStyle(color)
                .lineLimit(1)
                .minimumScaleFactor(0.7)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(12)
        .background(ThemeManager.shared.currentTheme.panelColor.opacity(0.5))
        .overlay {
            RoundedRectangle(cornerRadius: 8)
                .stroke(color.opacity(0.65), lineWidth: 1)
        }
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

struct GalleryView: View {
    let bestStyleRank: StyleRank
    let bestFightsCleared: Int
    let bestMaxCombo: Int
    let unlockedRewards: [String]
    let bossVerdicts: [String]
    let back: () -> Void

    var body: some View {
        ZStack {
            ThemeBackgroundView()
                .ignoresSafeArea()

            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Text("GALLERY")
                        .font(
                            .vhs(size: 30, weight: .black, design: .rounded)
                        )
                        .foregroundStyle(.white)

                    Spacer()

                    BackButton(action: back)
                }

                GallerySection(title: "BEST RUN") {
                    VStack(alignment: .leading, spacing: 8) {
                        GalleryLine(
                            label: "BEST STYLE",
                            value: bestStyleRank.title,
                            color: bestStyleRank.color
                        )
                        GalleryLine(
                            label: "MOST FIGHTS",
                            value: "\(bestFightsCleared)",
                            color: .red
                        )
                        GalleryLine(
                            label: "MAX COMBO",
                            value: "\(bestMaxCombo)",
                            color: .cyan
                        )
                    }
                }

                GallerySection(title: "UNLOCKED REWARDS") {
                    GalleryList(
                        items: unlockedRewards,
                        emptyText: "NO REWARDS YET"
                    )
                }

                GallerySection(title: "BOSS VERDICTS") {
                    GalleryList(
                        items: bossVerdicts,
                        emptyText: "NO VERDICTS YET"
                    )
                }

                Spacer()
            }
            .padding(24)
        }
    }
}

struct SettingsView: View {
    @Binding var isScreenShakeEnabled: Bool
    @Binding var isFlashFXEnabled: Bool
    @Binding var isMusicEnabled: Bool
    @Binding var musicVolume: Double

    let openThemeSelection: () -> Void
    let openMusicSelection: () -> Void
    let openPaintSelection: () -> Void
    let resetGalleryData: () -> Void
    let back: () -> Void

    var body: some View {
        ZStack {
            ThemeBackgroundView()
                .ignoresSafeArea()

            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Spacer()
                    BackButton(action: back)
                }

                VStack(spacing: 9) {
                    SettingsToggle(
                        title: "SCREEN SHAKE",
                        isOn: $isScreenShakeEnabled
                    )
                    SettingsToggle(title: "FLASH FX", isOn: $isFlashFXEnabled)
                    SettingsToggle(title: "MUSIC", isOn: $isMusicEnabled)

                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("MUSIC VOLUME")
                                .font(
                                    .vhs(
                                        size: 13,
                                        weight: .black,
                                        design: .monospaced
                                    )
                                )
                                .foregroundStyle(.white.opacity(0.82))

                            Spacer()

                            Text("\(Int(musicVolume * 100))%")
                                .font(
                                    .vhs(
                                        size: 12,
                                        weight: .black,
                                        design: .monospaced
                                    )
                                )
                                .foregroundStyle(
                                    ThemeManager.shared.currentTheme.accentColor
                                )
                        }

                        Slider(value: $musicVolume, in: 0...1)
                            .tint(ThemeManager.shared.currentTheme.primaryColor)
                            .disabled(!isMusicEnabled)
                            .opacity(isMusicEnabled ? 1 : 0.4)
                    }
                }
                .padding(12)
                .background(
                    ThemeManager.shared.currentTheme.panelColor.opacity(0.48)
                )
                .overlay {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(.white.opacity(0.16), lineWidth: 1)
                }
                .clipShape(RoundedRectangle(cornerRadius: 8))

                Button(action: openThemeSelection) {
                    SettingsNavigationRow(
                        title: "THEME SELECT",
                        symbol: "paintpalette.fill"
                    )
                }
                .buttonStyle(.plain)

                Button(action: openMusicSelection) {
                    SettingsNavigationRow(
                        title: "MUSIC SELECT",
                        symbol: "music.note.list"
                    )
                }
                .buttonStyle(.plain)

                Button(action: openPaintSelection) {
                    SettingsNavigationRow(
                        title: "PAINT FX SELECT",
                        symbol: "paintbrush.pointed.fill"
                    )
                }
                .buttonStyle(.plain)

                VStack(alignment: .leading, spacing: 6) {
                    Text("GAME INFO")
                        .font(
                            .vhs(
                                size: 11,
                                weight: .black,
                                design: .monospaced
                            )
                        )
                        .foregroundStyle(.white.opacity(0.58))

                    SettingsInfoLine(
                        title: "EVENTS",
                        value: "NEW RUNS AND REWARDS"
                    )
                    SettingsInfoLine(
                        title: "DAILY LOGIN",
                        value: "FREE REWARDS RETURN DAILY"
                    )
                    SettingsInfoLine(
                        title: "STORE",
                        value: "OPTIONAL STYLE ITEMS"
                    )
                }
                .padding(10)
                .background(
                    ThemeManager.shared.currentTheme.panelColor.opacity(0.48)
                )
                .overlay {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(.white.opacity(0.16), lineWidth: 1)
                }
                .clipShape(RoundedRectangle(cornerRadius: 8))

                Button(action: resetGalleryData) {
                    Text("RESET GALLERY DATA")
                        .font(
                            .vhs(size: 12, weight: .black, design: .rounded)
                        )
                        .frame(maxWidth: .infinity)
                        .frame(height: 40)
                }
                .buttonStyle(.borderedProminent)
                .tint(.red)

                Spacer()
            }
            .padding(.horizontal, 24)
            .padding(.top, 12)
            .padding(.bottom, 20)
        }
    }
}

private struct MenuActionButton: View {
    let title: String
    let color: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Text(title)
                    .font(.vhs(size: 17, weight: .black, design: .rounded))
                    .lineLimit(1)
                    .minimumScaleFactor(0.72)

                Spacer()
            }
            .foregroundStyle(.white)
            .padding(.horizontal, 14)
            .frame(height: 42)
            .background(
                ThemeManager.shared.currentTheme.panelColor.opacity(0.55)
            )
            .overlay {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(color.opacity(0.75), lineWidth: 1)
            }
            .clipShape(RoundedRectangle(cornerRadius: 8))
        }
        .buttonStyle(.plain)
    }
}

struct BackButton: View {
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text("BACK")
                .font(.vhs(size: 10, weight: .black, design: .monospaced))
                .padding(.horizontal, 8)
                .frame(height: 30)
        }
        .buttonStyle(.bordered)
        .tint(.white)
    }
}

struct SettingsNavigationRow: View {
    let title: String
    let symbol: String

    var body: some View {
        HStack {
            Image(systemName: symbol)
                .frame(width: 24)

            Text(title)
                .font(
                    .vhs(size: 13, weight: .black, design: .monospaced)
                )

            Spacer()

            Image(systemName: "chevron.right")
        }
        .foregroundStyle(.white)
        .padding(12)
        .background(ThemeManager.shared.currentTheme.panelColor.opacity(0.56))
        .overlay {
            RoundedRectangle(cornerRadius: 8)
                .stroke(
                    ThemeManager.shared.currentTheme.primaryColor.opacity(0.5),
                    lineWidth: 1
                )
        }
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

private struct SettingsToggle: View {
    let title: String
    @Binding var isOn: Bool

    var body: some View {
        Toggle(isOn: $isOn) {
            Text(title)
                .font(.vhs(size: 13, weight: .black, design: .monospaced))
                .foregroundStyle(.white.opacity(0.82))
        }
        .tint(.red)
    }
}

private struct SettingsInfoLine: View {
    let title: String
    let value: String

    var body: some View {
        HStack(alignment: .firstTextBaseline) {
            Text(title)
                .font(.vhs(size: 11, weight: .black, design: .monospaced))
                .foregroundStyle(.white.opacity(0.56))

            Spacer(minLength: 12)

            Text(value)
                .font(.vhs(size: 11, weight: .black, design: .monospaced))
                .foregroundStyle(ThemeManager.shared.currentTheme.accentColor)
                .multilineTextAlignment(.trailing)
                .lineLimit(2)
                .minimumScaleFactor(0.7)
        }
    }
}

private struct GallerySection<Content: View>: View {
    let title: String
    @ViewBuilder let content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.vhs(size: 12, weight: .black, design: .monospaced))
                .foregroundStyle(.white.opacity(0.58))

            content
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(14)
        .background(ThemeManager.shared.currentTheme.panelColor.opacity(0.48))
        .overlay {
            RoundedRectangle(cornerRadius: 8)
                .stroke(.white.opacity(0.16), lineWidth: 1)
        }
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

private struct GalleryLine: View {
    let label: String
    let value: String
    let color: Color

    var body: some View {
        HStack {
            Text(label)
                .font(.vhs(size: 11, weight: .black, design: .monospaced))
                .foregroundStyle(.white.opacity(0.62))

            Spacer()

            Text(value)
                .font(.vhs(size: 13, weight: .black, design: .rounded))
                .foregroundStyle(color)
        }
    }
}

private struct GalleryList: View {
    let items: [String]
    let emptyText: String

    var body: some View {
        VStack(alignment: .leading, spacing: 7) {
            if items.isEmpty {
                Text(emptyText)
                    .font(
                        .vhs(size: 11, weight: .black, design: .monospaced)
                    )
                    .foregroundStyle(.white.opacity(0.48))
            } else {
                ForEach(items, id: \.self) { item in
                    Text(item)
                        .font(
                            .vhs(
                                size: 12,
                                weight: .black,
                                design: .monospaced
                            )
                        )
                        .foregroundStyle(.white.opacity(0.78))
                }
            }
        }
    }
}
