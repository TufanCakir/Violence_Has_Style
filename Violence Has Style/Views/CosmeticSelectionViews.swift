//
//  CosmeticSelectionViews.swift
//  Violence Has Style
//
//  Created by Tufan Cakir on 05.06.26.
//

import SwiftUI

struct MusicSelectionView: View {
    let tracks: [MusicTrack]
    let selectedTrackId: String
    let ownedMusicPackIds: [String]
    let selectTrack: (String) -> Void
    let back: () -> Void

    var body: some View {
        ZStack {
            ThemeBackgroundView()

            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text("MUSIC SELECT")
                        .font(
                            .system(size: 24, weight: .black, design: .rounded)
                        )
                        .foregroundStyle(.white)

                    Spacer()

                    BackButton(action: back)
                }

                ScrollView {
                    VStack(spacing: 10) {
                        musicRow(
                            title: "AUTO PLAYLIST",
                            subtitle: "USES MODE PLAYLIST",
                            symbol: "shuffle",
                            color: ThemeManager.shared.currentTheme.accentColor,
                            isSelected: selectedTrackId.isEmpty,
                            isOwned: true,
                            isPremium: false,
                            action: { selectTrack("") }
                        )

                        ForEach(tracks) { track in
                            let isPremium =
                                track.requiredUnlock?.isEmpty == false
                            let isOwned = isTrackOwned(track)

                            musicRow(
                                title: track.title,
                                subtitle: track.mode?.uppercased()
                                    ?? "ALL MODES",
                                symbol: isPremium
                                    ? "lock.open.fill" : "music.note",
                                color: isPremium
                                    ? ThemeManager.shared.currentTheme
                                        .primaryColor
                                    : ThemeManager.shared.currentTheme
                                        .secondaryColor,
                                isSelected: selectedTrackId == track.id,
                                isOwned: isOwned,
                                isPremium: isPremium,
                                action: { selectTrack(track.id) }
                            )
                            .disabled(!isOwned)
                            .opacity(isOwned ? 1 : 0.45)
                        }
                    }
                }
            }
            .padding(24)
        }
    }

    private func isTrackOwned(_ track: MusicTrack) -> Bool {
        guard let requiredUnlock = track.requiredUnlock,
            !requiredUnlock.isEmpty
        else {
            return true
        }

        return ownedMusicPackIds.contains(requiredUnlock)
    }

    private func musicRow(
        title: String,
        subtitle: String,
        symbol: String,
        color: Color,
        isSelected: Bool,
        isOwned: Bool,
        isPremium: Bool,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            CosmeticSelectionRow(
                title: title,
                subtitle: subtitle,
                symbol: symbol,
                color: color,
                stateText: stateText(
                    isSelected: isSelected,
                    isOwned: isOwned,
                    isPremium: isPremium
                ),
                isSelected: isSelected
            )
        }
        .buttonStyle(.plain)
    }

    private func stateText(
        isSelected: Bool,
        isOwned: Bool,
        isPremium: Bool
    ) -> String {
        if isSelected { return "ACTIVE" }
        if !isOwned { return "LOCKED" }
        return isPremium ? "PREMIUM" : "OWNED"
    }
}

struct PaintSelectionView: View {
    let products: [PremiumStoreProduct]
    let selectedPaintFxId: String
    let ownedPaintFxIds: [String]
    let selectPaintFx: (String) -> Void
    let back: () -> Void

    var body: some View {
        ZStack {
            ThemeBackgroundView()

            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text("PAINT FX")
                        .font(
                            .system(size: 24, weight: .black, design: .rounded)
                        )
                        .foregroundStyle(.white)

                    Spacer()

                    BackButton(action: back)
                }

                ScrollView {
                    VStack(spacing: 10) {
                        paintRow(
                            title: "DEFAULT PAINT",
                            subtitle: "STYLE COLORS",
                            symbol: "paintbrush.fill",
                            color: ThemeManager.shared.currentTheme.accentColor,
                            isSelected: selectedPaintFxId.isEmpty,
                            isOwned: true,
                            isPremium: false,
                            action: { selectPaintFx("") }
                        )

                        ForEach(products) { product in
                            let isOwned = ownedPaintFxIds.contains(
                                product.unlockValue
                            )

                            paintRow(
                                title: product.title,
                                subtitle: product.badge,
                                symbol: product.symbol,
                                color: product.color,
                                isSelected: selectedPaintFxId
                                    == product.unlockValue,
                                isOwned: isOwned,
                                isPremium: true,
                                action: { selectPaintFx(product.unlockValue) }
                            )
                            .disabled(!isOwned)
                            .opacity(isOwned ? 1 : 0.45)
                        }
                    }
                }
            }
            .padding(24)
        }
    }

    private func paintRow(
        title: String,
        subtitle: String,
        symbol: String,
        color: Color,
        isSelected: Bool,
        isOwned: Bool,
        isPremium: Bool,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            CosmeticSelectionRow(
                title: title,
                subtitle: subtitle,
                symbol: symbol,
                color: color,
                stateText: stateText(
                    isSelected: isSelected,
                    isOwned: isOwned,
                    isPremium: isPremium
                ),
                isSelected: isSelected
            )
        }
        .buttonStyle(.plain)
    }

    private func stateText(
        isSelected: Bool,
        isOwned: Bool,
        isPremium: Bool
    ) -> String {
        if isSelected { return "ACTIVE" }
        if !isOwned { return "LOCKED" }
        return isPremium ? "PREMIUM" : "OWNED"
    }
}

private struct CosmeticSelectionRow: View {
    let title: String
    let subtitle: String
    let symbol: String
    let color: Color
    let stateText: String
    let isSelected: Bool

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: symbol)
                .font(.system(size: 21, weight: .black))
                .foregroundStyle(color)
                .frame(width: 30)

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 15, weight: .black, design: .rounded))
                    .foregroundStyle(.white)

                Text(subtitle)
                    .font(
                        .system(size: 9, weight: .black, design: .monospaced)
                    )
                    .foregroundStyle(.white.opacity(0.48))
            }

            Spacer()

            Text(stateText)
                .font(.system(size: 10, weight: .black, design: .monospaced))
                .foregroundStyle(isSelected ? color : .white.opacity(0.58))
        }
        .padding(13)
        .background(ThemeManager.shared.currentTheme.panelColor.opacity(0.72))
        .overlay {
            RoundedRectangle(cornerRadius: 8)
                .stroke(
                    isSelected ? color : .white.opacity(0.14),
                    lineWidth: 1
                )
        }
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}
