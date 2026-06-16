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
        ZStack {
            titleBackground

            ThemeBackgroundView()
                .ignoresSafeArea()

            VStack(spacing: 22) {
                Spacer()

                logo
                    .frame(maxWidth: 300)
                    .frame(height: 180)
                    .shadow(color: .red.opacity(0.8), radius: 18)

                VStack(spacing: 2) {
                    Text("VIOLENCE")
                        .font(
                            .system(size: 42, weight: .black, design: .rounded)
                        )
                        .foregroundStyle(.white)

                    Text("HAS STYLE")
                        .font(
                            .system(size: 42, weight: .black, design: .rounded)
                        )
                        .foregroundStyle(.red)
                }
                .tracking(1.2)

                Spacer()

                Text("TAP TO START")
                    .font(
                        .system(size: 13, weight: .black, design: .monospaced)
                    )
                    .foregroundStyle(.white.opacity(0.74))
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
        AsyncImage(url: RemoteContentStore.shared.assetURL(named: "logo_vhs")) {
            phase in
            if let image = phase.image {
                image
                    .resizable()
                    .scaledToFit()
            } else {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(.red.opacity(0.8), lineWidth: 2)
                        .background(
                            ThemeManager.shared.currentTheme.panelColor.opacity(
                                0.42
                            )
                        )

                    Text("VHS")
                        .font(
                            .system(size: 54, weight: .black, design: .rounded)
                        )
                        .foregroundStyle(.white)
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
                    .font(.system(size: 40, weight: .black, design: .rounded))
                    .foregroundStyle(.white)

                Text("HAS STYLE")
                    .font(.system(size: 40, weight: .black, design: .rounded))
                    .foregroundStyle(.red)

                VStack(spacing: 10) {
                    Text(isLoading ? "LOADING REMOTE GAME" : "ONLINE REQUIRED")
                        .font(
                            .system(
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
                        .system(
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
                            .system(
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
                                .system(
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
                            .system(
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

                VStack(spacing: 0) {
                    Text("REMOTE")
                        .font(
                            .system(size: 40, weight: .black, design: .rounded)
                        )
                        .foregroundStyle(.white)

                    Text("STYLE LOAD")
                        .font(
                            .system(size: 38, weight: .black, design: .rounded)
                        )
                        .foregroundStyle(
                            ThemeManager.shared.currentTheme.primaryColor
                        )
                }

                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Text(
                            isLoading
                                ? "DOWNLOADING GAME DATA" : "ONLINE REQUIRED"
                        )
                        .font(
                            .system(
                                size: 13,
                                weight: .black,
                                design: .monospaced
                            )
                        )
                        .foregroundStyle(.white.opacity(0.78))

                        Spacer()

                        Text("\(Int(progress * 100))%")
                            .font(
                                .system(
                                    size: 13,
                                    weight: .black,
                                    design: .monospaced
                                )
                            )
                            .foregroundStyle(
                                ThemeManager.shared.currentTheme.accentColor
                            )
                    }

                    ProgressView(value: progress)
                        .tint(ThemeManager.shared.currentTheme.primaryColor)

                    HStack {
                        Text("\(loadedItems)/\(max(1, totalItems)) FILES")
                        Spacer()
                        Text(
                            "\(megabytes(downloadedBytes)) / \(megabytes(estimatedTotalBytes)) MB"
                        )
                    }
                    .font(
                        .system(size: 10, weight: .black, design: .monospaced)
                    )
                    .foregroundStyle(.white.opacity(0.56))

                    Text(status)
                        .font(
                            .system(
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

                    Text(
                        "Events, themes, music, characters and shop data are loaded from the remote server before gameplay starts."
                    )
                    .font(.system(size: 12, weight: .bold, design: .rounded))
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
                        Text("RETRY DOWNLOAD")
                            .font(
                                .system(
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
}

struct OfflineView: View {
    var body: some View {
        ZStack {
            ThemeManager.shared.currentTheme.backgroundColor
                .ignoresSafeArea()

            VStack(spacing: 16) {
                Text("OFFLINE")
                    .font(.system(size: 42, weight: .black, design: .rounded))
                    .foregroundStyle(.red)

                Text("INTERNET REQUIRED")
                    .font(
                        .system(size: 14, weight: .black, design: .monospaced)
                    )
                    .foregroundStyle(.white.opacity(0.78))

                Text("WLAN OR MOBILE DATA")
                    .font(
                        .system(size: 10, weight: .black, design: .monospaced)
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
    let openSettings: () -> Void

    var body: some View {
        ZStack {
            ThemeBackgroundView()
                .ignoresSafeArea()

            FighterSprite(
                assetName: presentedCharacter.idleAsset,
                fallbackTitle: presentedCharacter.title,
                tint: presentedCharacter.tint,
                isEnemy: false
            )
            .frame(width: 260, height: 360)
            .opacity(0.28)
            .offset(x: 104, y: -12)
            .allowsHitTesting(false)

            VStack(alignment: .leading, spacing: 14) {
                VStack(spacing: 8) {
                    MenuActionButton(
                        title: "STORY MODE",
                        color: .red,
                        action: openStoryMode
                    )
                    MenuActionButton(
                        title: "ENDLESS MODE",
                        color: .orange,
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
                        color: .cyan,
                        action: openStyleMode
                    )
                    MenuActionButton(
                        title: "CHARACTER SELECT",
                        color: .white,
                        action: openCharacterSelect
                    )
                    MenuActionButton(
                        title: "GALLERY",
                        color: .purple,
                        action: openGallery
                    )
                    MenuActionButton(
                        title: "STYLE PASS",
                        color: .yellow,
                        action: openStylePasses
                    )
                    MenuActionButton(
                        title: "GIFT BOX",
                        color: .mint,
                        action: openGiftBox
                    )
                    MenuActionButton(
                        title: "SETTINGS",
                        color: .orange,
                        action: openSettings
                    )
                }

                Spacer()

                Text("TAP ATTACK. SWIPE STYLE. KILL WITH STYLE.")
                    .font(
                        .system(size: 10, weight: .black, design: .monospaced)
                    )
                    .foregroundStyle(.white.opacity(0.55))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 28)
            .padding(.top, 30)
            .padding(.bottom, 24)
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
                            .system(size: 30, weight: .black, design: .rounded)
                        )
                        .foregroundStyle(.white)

                    Spacer()

                    BackButton(action: back)
                }

                if let event {

                    HStack(spacing: 6) {
                        Image(systemName: event.currencySymbol ?? "drop.fill")
                            .font(.system(size: 18, weight: .black))
                            .foregroundStyle(event.themeColor)
                            .frame(width: 20, height: 20)

                        Text("\(balance) \(event.currencyTitle)")
                            .font(
                                .system(
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
                                                .system(
                                                    size: 15,
                                                    weight: .black,
                                                    design: .rounded
                                                )
                                            )
                                            .foregroundStyle(item.color)

                                        Text(item.description)
                                            .font(
                                                .system(
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
                                        .system(
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
                            .system(
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
        ZStack {
            ThemeBackgroundView()
                .ignoresSafeArea()

            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Text("STORY MODE")
                        .font(
                            .system(size: 30, weight: .black, design: .rounded)
                        )
                        .foregroundStyle(.white)

                    Spacer()

                    BackButton(action: back)
                }

                VStack(spacing: 10) {
                    ForEach(chapters) { chapter in
                        let isUnlocked =
                            chapter.requiredChapter <= completedChapterCount
                        Button {
                            startChapter(chapter)
                        } label: {
                            VStack(alignment: .leading, spacing: 6) {
                                HStack {
                                    Text(chapter.title)
                                        .font(
                                            .system(
                                                size: 17,
                                                weight: .black,
                                                design: .rounded
                                            )
                                        )
                                        .foregroundStyle(
                                            isUnlocked ? chapter.color : .gray
                                        )

                                    Spacer()

                                    Text(isUnlocked ? "READY" : "LOCKED")
                                        .font(
                                            .system(
                                                size: 10,
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
                                        .system(
                                            size: 11,
                                            weight: .bold,
                                            design: .monospaced
                                        )
                                    )
                                    .foregroundStyle(
                                        .white.opacity(isUnlocked ? 0.68 : 0.35)
                                    )

                                Text("\(chapter.targetFights) FIGHTS")
                                    .font(
                                        .system(
                                            size: 10,
                                            weight: .black,
                                            design: .monospaced
                                        )
                                    )
                                    .foregroundStyle(
                                        chapter.color.opacity(
                                            isUnlocked ? 0.8 : 0.35
                                        )
                                    )
                            }
                            .padding(14)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(
                                ThemeManager.shared.currentTheme.panelColor
                                    .opacity(0.5)
                            )
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

                Spacer()
            }
            .padding(24)
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
                            .system(size: 30, weight: .black, design: .rounded)
                        )
                        .foregroundStyle(.white)

                    Spacer()

                    BackButton(action: back)
                }

                if events.isEmpty {
                    Text("NO ACTIVE EVENT")
                        .font(
                            .system(
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
                        .font(.system(size: 21, weight: .black))
                        .foregroundStyle(event.themeColor)
                        .frame(width: 28)

                    VStack(alignment: .leading, spacing: 3) {
                        HStack(spacing: 8) {
                            Text(event.title)
                                .font(
                                    .system(
                                        size: 18,
                                        weight: .black,
                                        design: .rounded
                                    )
                                )
                                .foregroundStyle(.white)

                            Text(statusText)
                                .font(
                                    .system(
                                        size: 9,
                                        weight: .black,
                                        design: .monospaced
                                    )
                                )
                                .foregroundStyle(event.themeColor)
                        }

                        Text("\(balance) \(event.currencyTitle)")
                            .font(
                                .system(
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
                                .system(
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
                            .system(
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
                            .system(
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
        .font(.system(size: 12, weight: .black, design: .monospaced))
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
                            .system(size: 30, weight: .black, design: .rounded)
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
                            .system(size: 30, weight: .black, design: .rounded)
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
                                    .system(
                                        size: 16,
                                        weight: .black,
                                        design: .rounded
                                    )
                                )
                                .foregroundStyle(style.tint)

                            Text(style.labDescription)
                                .font(
                                    .system(
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
                            .system(size: 26, weight: .black, design: .rounded)
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
                                            .system(
                                                size: 16,
                                                weight: .black,
                                                design: .rounded
                                            )
                                        )
                                        .foregroundStyle(character.tint)

                                    Text(characterSummary(character))
                                        .font(
                                            .system(
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
                                            .system(
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
                        .system(
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
                            .system(size: 18, weight: .black, design: .rounded)
                        )
                        .foregroundStyle(level.accentColor)

                    Text(level.moodText)
                        .font(
                            .system(
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
                        .system(size: 12, weight: .black, design: .monospaced)
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
                .font(.system(size: 9, weight: .black, design: .monospaced))
                .foregroundStyle(.white.opacity(0.5))

            Text(value)
                .font(.system(size: 12, weight: .black, design: .rounded))
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
                            .system(size: 30, weight: .black, design: .rounded)
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
                                    .system(
                                        size: 13,
                                        weight: .black,
                                        design: .monospaced
                                    )
                                )
                                .foregroundStyle(.white.opacity(0.82))

                            Spacer()

                            Text("\(Int(musicVolume * 100))%")
                                .font(
                                    .system(
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
                    Text("APP STORE BUILD")
                        .font(
                            .system(
                                size: 12,
                                weight: .black,
                                design: .monospaced
                            )
                        )
                        .foregroundStyle(.white.opacity(0.58))

                    SettingsInfoLine(
                        title: "ONLINE GAME",
                        value: "REMOTE CONTENT REQUIRED"
                    )
                    SettingsInfoLine(
                        title: "CONTENT",
                        value: "JSON, THEMES, MUSIC, CHARACTERS"
                    )
                    SettingsInfoLine(
                        title: "PURCHASES",
                        value: "COSMETICS ONLY"
                    )
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

                Button(action: resetGalleryData) {
                    Text("RESET GALLERY DATA")
                        .font(
                            .system(size: 12, weight: .black, design: .rounded)
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
                    .font(.system(size: 17, weight: .black, design: .rounded))

                Spacer()
            }
            .foregroundStyle(.white)
            .padding(.horizontal, 16)
            .frame(height: 54)
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
                .font(.system(size: 10, weight: .black, design: .monospaced))
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
                    .system(size: 13, weight: .black, design: .monospaced)
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
                .font(.system(size: 13, weight: .black, design: .monospaced))
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
                .font(.system(size: 11, weight: .black, design: .monospaced))
                .foregroundStyle(.white.opacity(0.56))

            Spacer(minLength: 12)

            Text(value)
                .font(.system(size: 11, weight: .black, design: .monospaced))
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
                .font(.system(size: 12, weight: .black, design: .monospaced))
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
                .font(.system(size: 11, weight: .black, design: .monospaced))
                .foregroundStyle(.white.opacity(0.62))

            Spacer()

            Text(value)
                .font(.system(size: 13, weight: .black, design: .rounded))
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
                        .system(size: 11, weight: .black, design: .monospaced)
                    )
                    .foregroundStyle(.white.opacity(0.48))
            } else {
                ForEach(items, id: \.self) { item in
                    Text(item)
                        .font(
                            .system(
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
