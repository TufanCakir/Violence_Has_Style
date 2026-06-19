//
//  ThemeSelectionView.swift
//  Violence Has Style
//
//  Created by Tufan Cakir on 31.05.26.
//

import SwiftUI

struct ThemeSelectionView: View {

    let themes: [ThemeDefinition]
    let selectedTheme: ThemeDefinition
    let ownedThemeIds: [String]
    let selectTheme: (ThemeDefinition) -> Void
    let back: () -> Void

    var body: some View {
        ZStack {
            ThemeBackgroundView()

            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text("THEME SELECT")
                        .font(
                            .vhs(size: 24, weight: .black, design: .rounded)
                        )
                        .foregroundStyle(.white)

                    Spacer()

                    BackButton(action: back)
                }

                ScrollView {
                    VStack(spacing: 10) {
                        ForEach(themes) { theme in
                            let isOwned =
                                !theme.isStylePassExclusive
                                || ownedThemeIds.contains(theme.id)

                            Button {
                                selectTheme(theme)
                            } label: {
                                HStack(spacing: 12) {
                                    Image(systemName: theme.symbol)
                                        .font(.vhs(size: 22, weight: .black))
                                        .foregroundStyle(theme.primaryColor)
                                        .frame(width: 30)

                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(theme.title)
                                            .font(
                                                .vhs(
                                                    size: 16,
                                                    weight: .black,
                                                    design: .rounded
                                                )
                                            )
                                            .foregroundStyle(theme.textColor)

                                        Text(
                                            theme.isStylePassExclusive
                                                ? "PREMIUM / STYLE PASS"
                                                : "REMOTE THEME"
                                        )
                                        .font(
                                            .vhs(
                                                size: 9,
                                                weight: .black,
                                                design: .monospaced
                                            )
                                        )
                                        .foregroundStyle(.white.opacity(0.48))
                                    }

                                    Spacer()

                                    Text(
                                        themeState(
                                            theme: theme,
                                            isOwned: isOwned
                                        )
                                    )
                                    .font(
                                        .vhs(
                                            size: 10,
                                            weight: .black,
                                            design: .monospaced
                                        )
                                    )
                                    .foregroundStyle(
                                        theme.id == selectedTheme.id
                                            ? theme.secondaryColor : .gray
                                    )
                                }
                                .padding(13)
                                .background(theme.panelColor.opacity(0.78))
                                .overlay {
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(
                                            theme.id == selectedTheme.id
                                                ? theme.primaryColor
                                                : .white.opacity(0.14),
                                            lineWidth: 1
                                        )
                                }
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                            }
                            .buttonStyle(.plain)
                            .disabled(!isOwned)
                            .opacity(isOwned ? 1 : 0.45)
                        }
                    }
                }
            }
            .padding(24)
        }
    }

    private func themeState(theme: ThemeDefinition, isOwned: Bool) -> String {
        if theme.id == selectedTheme.id {
            return "ACTIVE"
        }

        return isOwned ? "OWNED" : "LOCKED"
    }
}
