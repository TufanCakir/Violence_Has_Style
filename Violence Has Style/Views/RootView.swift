//
//  RootView.swift
//  Violence Has Style
//
//  Created by Tufan Cakir on 30.05.26.
//

import SwiftUI

struct RootView<Content: View>: View {
    let theme: ThemeDefinition
    let styleRank: StyleRank
    let currencies: [HeaderCurrencyDisplay]
    let footerTabs: [FooterTabDefinition]
    let selectedScreen: GameScreen
    let selectScreen: (GameScreen) -> Void
    let showNavigation: Bool

    @ViewBuilder let content: Content

    var body: some View {
        VStack(spacing: 0) {

            if showNavigation {

                GlobalHeaderView(
                    theme: theme,
                    styleRank: styleRank,
                    currencies: currencies
                )
            }

            content
                .frame(maxWidth: .infinity, maxHeight: .infinity)

            if showNavigation {

                GlobalFooterView(
                    theme: theme,
                    tabs: footerTabs,
                    selectedScreen: selectedScreen,
                    selectScreen: selectScreen
                )
            }
        }
        .background(theme.backgroundColor.ignoresSafeArea())
    }
}

struct ThemeBackgroundView: View {
    var body: some View {
        let theme = ThemeManager.shared.currentTheme

        LinearGradient(
            colors: [
                theme.backgroundColor,
                theme.primaryColor.opacity(0.42),
                theme.secondaryColor.opacity(0.22),
                theme.backgroundColor,
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }
}

private struct GlobalHeaderView: View {
    let theme: ThemeDefinition
    let styleRank: StyleRank
    let currencies: [HeaderCurrencyDisplay]

    var body: some View {
        HStack(spacing: 10) {
            VStack(alignment: .leading, spacing: 2) {
                Text(styleRank.title)
                    .font(.system(size: 16, weight: .black, design: .rounded))
                    .foregroundStyle(styleRank.color)
                    .lineLimit(1)

                Text("STYLE RANK")
                    .font(.system(size: 8, weight: .black, design: .monospaced))
                    .foregroundStyle(.white.opacity(0.45))
            }

            Spacer(minLength: 8)

            ForEach(currencies) { currency in
                HeaderCurrencyView(
                    title: currency.title,
                    value: currency.value,
                    color: currency.color,
                    symbol: currency.symbol
                )
            }
        }
        .frame(height: 56)
        .padding(.horizontal, 14)
        .background(theme.panelColor.opacity(0.94))
        .overlay(alignment: .bottom) {
            Rectangle()
                .fill(.white.opacity(0.12))
                .frame(height: 1)
        }
    }
}

private struct HeaderCurrencyView: View {
    let title: String
    let value: Int
    let color: Color
    let symbol: String

    var body: some View {
        VStack(alignment: .trailing, spacing: 2) {
            HStack(spacing: 4) {
                Image(systemName: symbol)
                    .font(.system(size: 15, weight: .black))
                    .foregroundStyle(color)
                    .frame(width: 18, height: 18)

                Text("\(value)")
                    .font(.system(size: 14, weight: .black, design: .rounded))
                    .foregroundStyle(color)
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
            }

            Text(title)
                .font(.system(size: 8, weight: .black, design: .monospaced))
                .foregroundStyle(.white.opacity(0.48))
                .lineLimit(1)
                .minimumScaleFactor(0.6)
        }
        .frame(minWidth: 58, alignment: .trailing)
    }
}

private struct GlobalFooterView: View {
    let theme: ThemeDefinition
    let tabs: [FooterTabDefinition]
    let selectedScreen: GameScreen
    let selectScreen: (GameScreen) -> Void

    var body: some View {
        HStack(spacing: 0) {
            ForEach(tabs) { tab in
                if let screen = tab.gameScreen {
                    Button {
                        selectScreen(screen)
                    } label: {
                        VStack(spacing: 4) {
                            Image(systemName: tab.symbol)
                                .font(.system(size: 19, weight: .black))
                                .frame(width: 24, height: 24)

                            Text(tab.title)
                                .font(
                                    .system(
                                        size: 8,
                                        weight: .black,
                                        design: .monospaced
                                    )
                                )
                                .lineLimit(1)
                                .minimumScaleFactor(0.6)
                        }
                        .foregroundStyle(
                            isSelected(tab) ? tab.color : .white.opacity(0.45)
                        )
                        .frame(maxWidth: .infinity)
                        .frame(height: 62)
                        .background(
                            isSelected(tab)
                                ? tab.color.opacity(0.12) : .clear
                        )
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .background(theme.panelColor.opacity(0.94))
        .overlay(alignment: .top) {
            Rectangle()
                .fill(.white.opacity(0.12))
                .frame(height: 1)
        }
    }

    private func isSelected(_ tab: FooterTabDefinition) -> Bool {
        selectedScreen == tab.gameScreen
    }
}
