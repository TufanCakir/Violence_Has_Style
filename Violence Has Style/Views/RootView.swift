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
        let typography = RemoteContentStore.shared.uiConfig.typography

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
        .font(.vhs(size: 14, weight: .regular))
        .foregroundStyle(typography.primaryTextColor)
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
                    .font(.vhs(size: 15, weight: .black, design: .rounded))
                    .foregroundStyle(styleRank.color)
                    .lineLimit(1)
                    .minimumScaleFactor(0.55)

                Text("STYLE RANK")
                    .font(.vhs(size: 8, weight: .black, design: .monospaced))
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
                    .font(.vhs(size: 18, weight: .black))
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
                            .vhs(size: 24, weight: .black, design: .rounded)
                        )
                        .foregroundStyle(.white)

                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("STYLE RANK")
                                .font(
                                    .vhs(
                                        size: 10,
                                        weight: .black,
                                        design: .monospaced
                                    )
                                )
                                .foregroundStyle(.white.opacity(0.5))

                            Text(styleRank.title)
                                .font(
                                    .vhs(
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
            CurrencySymbolView(symbol: currency.symbol, color: currency.color)
                .frame(width: 30, height: 30)

            VStack(alignment: .leading, spacing: 3) {
                Text(currency.title)
                    .font(.vhs(size: 14, weight: .black, design: .rounded))
                    .foregroundStyle(.white)

                Text(currency.id.uppercased())
                    .font(
                        .vhs(size: 9, weight: .black, design: .monospaced)
                    )
                    .foregroundStyle(.white.opacity(0.44))
            }

            Spacer()

            Text("\(currency.value)")
                .font(.vhs(size: 18, weight: .black, design: .rounded))
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
            CurrencySymbolView(symbol: symbol, color: color)
                .frame(width: 14, height: 14)

            VStack(alignment: .leading, spacing: 0) {
                Text("\(value)")
                    .font(.vhs(size: 12, weight: .black, design: .rounded))
                    .foregroundStyle(color)
                    .lineLimit(1)
                    .minimumScaleFactor(0.55)

                Text(title)
                    .font(.vhs(size: 6, weight: .black, design: .monospaced))
                    .foregroundStyle(.white.opacity(0.48))
                    .lineLimit(1)
                    .minimumScaleFactor(0.45)
            }
        }
        .frame(width: 76, height: 24, alignment: .leading)
    }
}

struct CurrencySymbolView: View {
    let symbol: String
    let color: Color

    var body: some View {
        if symbol == "vhs.devilHand" {
            DevilHandSymbol()
                .fill(
                    LinearGradient(
                        colors: [
                            color.opacity(0.95),
                            color.opacity(0.55),
                            .white.opacity(0.85),
                        ],
                        startPoint: .bottomLeading,
                        endPoint: .topTrailing
                    )
                )
                .overlay {
                    DevilHandSymbol()
                        .stroke(.white.opacity(0.42), lineWidth: 1.4)
                }
                .shadow(color: color.opacity(0.7), radius: 4)
                .aspectRatio(1, contentMode: .fit)
        } else {
            Image(systemName: symbol)
                .font(.vhs(size: 16, weight: .black))
                .foregroundStyle(color)
        }
    }
}

struct DevilHandSymbol: Shape {
    func path(in rect: CGRect) -> Path {
        let width = rect.width
        let height = rect.height

        func point(_ x: CGFloat, _ y: CGFloat) -> CGPoint {
            CGPoint(
                x: rect.minX + x * width,
                y: rect.minY + y * height
            )
        }

        var path = Path()
        path.move(to: point(0.50, 0.93))
        path.addCurve(
            to: point(0.22, 0.78),
            control1: point(0.40, 0.92),
            control2: point(0.27, 0.88)
        )
        path.addCurve(
            to: point(0.18, 0.46),
            control1: point(0.16, 0.66),
            control2: point(0.16, 0.55)
        )
        path.addCurve(
            to: point(0.06, 0.18),
            control1: point(0.15, 0.35),
            control2: point(0.09, 0.26)
        )
        path.addCurve(
            to: point(0.16, 0.06),
            control1: point(0.03, 0.11),
            control2: point(0.09, 0.04)
        )
        path.addCurve(
            to: point(0.32, 0.34),
            control1: point(0.25, 0.09),
            control2: point(0.27, 0.24)
        )
        path.addCurve(
            to: point(0.37, 0.09),
            control1: point(0.33, 0.24),
            control2: point(0.33, 0.14)
        )
        path.addCurve(
            to: point(0.50, 0.08),
            control1: point(0.40, 0.04),
            control2: point(0.47, 0.03)
        )
        path.addCurve(
            to: point(0.54, 0.37),
            control1: point(0.55, 0.15),
            control2: point(0.52, 0.27)
        )
        path.addCurve(
            to: point(0.67, 0.12),
            control1: point(0.58, 0.26),
            control2: point(0.60, 0.16)
        )
        path.addCurve(
            to: point(0.79, 0.17),
            control1: point(0.72, 0.08),
            control2: point(0.78, 0.11)
        )
        path.addCurve(
            to: point(0.72, 0.46),
            control1: point(0.81, 0.26),
            control2: point(0.75, 0.37)
        )
        path.addCurve(
            to: point(0.89, 0.32),
            control1: point(0.78, 0.38),
            control2: point(0.84, 0.32)
        )
        path.addCurve(
            to: point(0.96, 0.44),
            control1: point(0.95, 0.31),
            control2: point(0.99, 0.37)
        )
        path.addCurve(
            to: point(0.77, 0.72),
            control1: point(0.92, 0.58),
            control2: point(0.83, 0.66)
        )
        path.addCurve(
            to: point(0.66, 0.91),
            control1: point(0.72, 0.77),
            control2: point(0.69, 0.84)
        )
        path.addCurve(
            to: point(0.50, 0.93),
            control1: point(0.61, 0.95),
            control2: point(0.55, 0.95)
        )
        path.closeSubpath()

        path.move(to: point(0.33, 0.55))
        path.addCurve(
            to: point(0.68, 0.59),
            control1: point(0.43, 0.48),
            control2: point(0.56, 0.50)
        )
        path.addCurve(
            to: point(0.51, 0.72),
            control1: point(0.59, 0.64),
            control2: point(0.55, 0.68)
        )
        path.addCurve(
            to: point(0.33, 0.55),
            control1: point(0.43, 0.68),
            control2: point(0.37, 0.62)
        )
        path.closeSubpath()

        return path
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
                                .font(.vhs(size: 19, weight: .black))
                                .frame(width: 24, height: 24)

                            Text(tab.title)
                                .font(
                                    .vhs(
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
