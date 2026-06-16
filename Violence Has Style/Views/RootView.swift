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
    let currencyInfoRows: [HeaderCurrencyDisplay]
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
                    currencies: currencies,
                    currencyInfoRows: currencyInfoRows
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
    let currencyInfoRows: [HeaderCurrencyDisplay]

    @State private var isShowingCurrencyInfo = false

    var body: some View {
        HStack(spacing: 10) {
            VStack(alignment: .leading, spacing: 2) {
                Text(styleRank.title)
                    .font(.system(size: 15, weight: .black, design: .rounded))
                    .foregroundStyle(styleRank.color)
                    .lineLimit(1)
                    .minimumScaleFactor(0.55)

                Text("STYLE RANK")
                    .font(.system(size: 8, weight: .black, design: .monospaced))
                    .foregroundStyle(.white.opacity(0.45))
                    .lineLimit(1)
            }
            .frame(minWidth: 86, maxWidth: 116, alignment: .leading)

            Spacer(minLength: 8)

            HeaderCurrencyGridView(currencies: currencies)

            Button {
                isShowingCurrencyInfo = true
            } label: {
                Image(systemName: "info.circle.fill")
                    .font(.system(size: 18, weight: .black))
                    .foregroundStyle(theme.accentColor)
                    .frame(width: 30, height: 30)
                    .contentShape(Circle())
            }
            .buttonStyle(.plain)
        }
        .frame(height: 62)
        .padding(.horizontal, 14)
        .background(theme.panelColor.opacity(0.94))
        .overlay(alignment: .bottom) {
            Rectangle()
                .fill(.white.opacity(0.12))
                .frame(height: 1)
        }
        .sheet(isPresented: $isShowingCurrencyInfo) {
            CurrencyInfoSheetView(
                theme: theme,
                styleRank: styleRank,
                currencies: currencyInfoRows
            )
            .presentationDetents([.medium, .large])
            .presentationDragIndicator(.visible)
        }
    }
}

private struct HeaderCurrencyGridView: View {
    let currencies: [HeaderCurrencyDisplay]

    var body: some View {
        VStack(spacing: 4) {
            ForEach(0..<2, id: \.self) { row in
                HStack(spacing: 8) {
                    ForEach(0..<2, id: \.self) { column in
                        let index = row * 2 + column

                        if index < currencies.count {
                            HeaderCurrencyView(
                                title: currencies[index].title,
                                value: currencies[index].value,
                                color: currencies[index].color,
                                symbol: currencies[index].symbol
                            )
                        } else {
                            Color.clear
                                .frame(width: 76, height: 24)
                        }
                    }
                }
            }
        }
        .frame(width: 160, alignment: .trailing)
    }
}

private struct CurrencyInfoSheetView: View {
    let theme: ThemeDefinition
    let styleRank: StyleRank
    let currencies: [HeaderCurrencyDisplay]

    var body: some View {
        ZStack {
            ThemeBackgroundView()

            ScrollView {
                VStack(alignment: .leading, spacing: 14) {
                    Text("CURRENCIES")
                        .font(
                            .system(size: 24, weight: .black, design: .rounded)
                        )
                        .foregroundStyle(.white)

                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("STYLE RANK")
                                .font(
                                    .system(
                                        size: 10,
                                        weight: .black,
                                        design: .monospaced
                                    )
                                )
                                .foregroundStyle(.white.opacity(0.5))

                            Text(styleRank.title)
                                .font(
                                    .system(
                                        size: 22,
                                        weight: .black,
                                        design: .rounded
                                    )
                                )
                                .foregroundStyle(styleRank.color)
                        }

                        Spacer()
                    }
                    .padding(14)
                    .background(theme.panelColor.opacity(0.66))
                    .overlay {
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(styleRank.color.opacity(0.55), lineWidth: 1)
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 8))

                    ForEach(currencies) { currency in
                        CurrencyInfoRowView(theme: theme, currency: currency)
                    }

                }
                .padding(24)
            }
        }
    }
}

private struct CurrencyInfoRowView: View {
    let theme: ThemeDefinition
    let currency: HeaderCurrencyDisplay

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: currency.symbol)
                .font(.system(size: 20, weight: .black))
                .foregroundStyle(currency.color)
                .frame(width: 30)

            VStack(alignment: .leading, spacing: 3) {
                Text(currency.title)
                    .font(.system(size: 14, weight: .black, design: .rounded))
                    .foregroundStyle(.white)

                Text(currency.id.uppercased())
                    .font(
                        .system(size: 9, weight: .black, design: .monospaced)
                    )
                    .foregroundStyle(.white.opacity(0.44))
            }

            Spacer()

            Text("\(currency.value)")
                .font(.system(size: 18, weight: .black, design: .rounded))
                .foregroundStyle(currency.color)
        }
        .padding(13)
        .background(theme.panelColor.opacity(0.58))
        .overlay {
            RoundedRectangle(cornerRadius: 8)
                .stroke(currency.color.opacity(0.42), lineWidth: 1)
        }
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

private struct HeaderCurrencyView: View {
    let title: String
    let value: Int
    let color: Color
    let symbol: String

    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: symbol)
                .font(.system(size: 12, weight: .black))
                .foregroundStyle(color)
                .frame(width: 14, height: 14)

            VStack(alignment: .leading, spacing: 0) {
                Text("\(value)")
                    .font(.system(size: 12, weight: .black, design: .rounded))
                    .foregroundStyle(color)
                    .lineLimit(1)
                    .minimumScaleFactor(0.55)

                Text(title)
                    .font(.system(size: 6, weight: .black, design: .monospaced))
                    .foregroundStyle(.white.opacity(0.48))
                    .lineLimit(1)
                    .minimumScaleFactor(0.45)
            }
        }
        .frame(width: 76, height: 24, alignment: .leading)
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
