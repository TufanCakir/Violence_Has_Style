//
//  TradeCreateViews.swift
//  Violence Has Style
//
//  Created by Tufan Cakir on 20.06.26.
//

import SwiftUI

struct TradeView: View {
    let trades: [TradeDefinition]
    let balance: (String) -> Int
    let trade: (TradeDefinition) -> Void
    let back: () -> Void

    var body: some View {
        let theme = ThemeManager.shared.currentTheme

        ZStack {
            ThemeBackgroundView()
                .ignoresSafeArea()

            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text("TRADE")
                        .font(.vhs(size: 26, weight: .black, design: .rounded))
                        .foregroundStyle(.white)

                    Spacer()

                    BackButton(action: back)
                }

                ScrollView(showsIndicators: false) {
                    LazyVStack(spacing: 10) {
                        ForEach(trades) { item in
                            TradeCardView(
                                item: item,
                                fromBalance: balance(item.fromCurrencyId),
                                canTrade: balance(item.fromCurrencyId)
                                    >= item.fromAmount,
                                trade: { trade(item) }
                            )
                        }
                    }
                    .padding(.bottom, 18)
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 18)
            .padding(.bottom, 14)
        }
        .background(theme.backgroundColor)
    }
}

private struct TradeCardView: View {
    let item: TradeDefinition
    let fromBalance: Int
    let canTrade: Bool
    let trade: () -> Void

    var body: some View {
        let theme = ThemeManager.shared.currentTheme

        VStack(alignment: .leading, spacing: 10) {
            Text(item.title)
                .font(.vhs(size: 15, weight: .black, design: .rounded))
                .foregroundStyle(.white)
                .lineLimit(1)
                .minimumScaleFactor(0.65)

            HStack(spacing: 10) {
                TradeCurrencyPill(
                    title: item.fromTitle,
                    amount: item.fromAmount,
                    symbol: item.fromSymbol,
                    color: item.fromColor
                )

                Image(systemName: "arrow.right")
                    .font(.vhs(size: 14, weight: .black))
                    .foregroundStyle(theme.accentColor)

                TradeCurrencyPill(
                    title: item.toTitle,
                    amount: item.toAmount,
                    symbol: item.toSymbol,
                    color: item.toColor
                )
            }

            HStack {
                Text("YOU HAVE \(fromBalance)")
                    .font(.vhs(size: 10, weight: .black, design: .monospaced))
                    .foregroundStyle(.white.opacity(0.55))

                Spacer()

                Button(action: trade) {
                    Text(canTrade ? "TRADE" : "NEED MORE")
                        .font(.vhs(size: 11, weight: .black, design: .rounded))
                        .frame(width: 96, height: 32)
                }
                .buttonStyle(.borderedProminent)
                .tint(canTrade ? item.toColor : .gray)
                .disabled(!canTrade)
            }
        }
        .padding(12)
        .background(theme.panelColor.opacity(0.58))
        .overlay {
            RoundedRectangle(cornerRadius: 8)
                .stroke(item.toColor.opacity(0.55), lineWidth: 1)
        }
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

private struct TradeCurrencyPill: View {
    let title: String
    let amount: Int
    let symbol: String
    let color: Color

    var body: some View {
        HStack(spacing: 6) {
            CurrencySymbolView(symbol: symbol, color: color)
                .frame(width: 20, height: 20)

            VStack(alignment: .leading, spacing: 0) {
                Text("\(amount)")
                    .font(.vhs(size: 14, weight: .black, design: .rounded))
                    .foregroundStyle(color)

                Text(title)
                    .font(.vhs(size: 7, weight: .black, design: .monospaced))
                    .foregroundStyle(.white.opacity(0.52))
                    .lineLimit(1)
                    .minimumScaleFactor(0.55)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(9)
        .background(
            ThemeManager.shared.currentTheme.backgroundColor.opacity(0.38)
        )
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

struct CreateCharacterView: View {
    let characters: [PlayerCharacter]
    let selectedCharacter: PlayerCharacter
    @Binding var customName: String
    let selectCharacter: (PlayerCharacter) -> Void
    let back: () -> Void

    @State private var previewFrameIndex = 0

    private var previewCharacter: PlayerCharacter {
        selectedCharacter
    }

    private var previewFrames: [String] {
        previewCharacter.attackFrames.isEmpty
            ? [previewCharacter.idleAsset] : previewCharacter.attackFrames
    }

    private var previewAsset: String {
        previewFrames[min(previewFrameIndex, previewFrames.count - 1)]
    }

    var body: some View {
        let theme = ThemeManager.shared.currentTheme

        ZStack {
            ThemeBackgroundView()
                .ignoresSafeArea()

            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text("CREATE")
                        .font(.vhs(size: 26, weight: .black, design: .rounded))
                        .foregroundStyle(.white)

                    Spacer()

                    BackButton(action: back)
                }

                TextField("CHARACTER NAME", text: $customName)
                    .font(.vhs(size: 18, weight: .black, design: .rounded))
                    .textInputAutocapitalization(.characters)
                    .foregroundStyle(theme.textColor)
                    .padding(12)
                    .background(theme.panelColor.opacity(0.62))
                    .overlay {
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(
                                theme.secondaryColor.opacity(0.65),
                                lineWidth: 1
                            )
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 8))

                VStack(alignment: .leading, spacing: 8) {
                    Text("BASE STYLE")
                        .font(
                            .vhs(size: 10, weight: .black, design: .monospaced)
                        )
                        .foregroundStyle(.white.opacity(0.52))

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            ForEach(characters) { character in
                                CharacterBaseCard(
                                    character: character,
                                    isSelected: character.id
                                        == selectedCharacter.id,
                                    select: {
                                        previewFrameIndex = 0
                                        selectCharacter(character)
                                    }
                                )
                            }
                        }
                        .padding(.vertical, 2)
                    }
                }

                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("ATTACK PREVIEW")
                            .font(
                                .vhs(
                                    size: 10,
                                    weight: .black,
                                    design: .monospaced
                                )
                            )
                            .foregroundStyle(.white.opacity(0.52))

                        Spacer()

                        Text("\(previewFrameIndex + 1)/\(previewFrames.count)")
                            .font(
                                .vhs(
                                    size: 10,
                                    weight: .black,
                                    design: .monospaced
                                )
                            )
                            .foregroundStyle(theme.accentColor)
                    }

                    ZStack {
                        theme.panelColor.opacity(0.48)

                        FighterSprite(
                            assetName: previewAsset,
                            fallbackTitle: customName.isEmpty
                                ? previewCharacter.title : customName,
                            tint: previewCharacter.tint,
                            isEnemy: false
                        )
                        .padding(8)
                    }
                    .frame(height: 210)
                    .overlay {
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(
                                theme.secondaryColor.opacity(0.5),
                                lineWidth: 1
                            )
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 8))

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(
                                Array(previewFrames.enumerated()),
                                id: \.offset
                            ) {
                                index,
                                frame in
                                Button {
                                    previewFrameIndex = index
                                } label: {
                                    Text("ATK \(index + 1)")
                                        .font(
                                            .vhs(
                                                size: 10,
                                                weight: .black,
                                                design: .rounded
                                            )
                                        )
                                        .frame(width: 58, height: 30)
                                }
                                .buttonStyle(.borderedProminent)
                                .tint(
                                    index == previewFrameIndex
                                        ? theme.secondaryColor
                                        : theme.panelColor
                                )
                            }
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

private struct CharacterBaseCard: View {
    let character: PlayerCharacter
    let isSelected: Bool
    let select: () -> Void

    var body: some View {
        let theme = ThemeManager.shared.currentTheme

        Button(action: select) {
            VStack(alignment: .leading, spacing: 8) {
                ZStack {
                    theme.backgroundColor.opacity(0.45)

                    FighterSprite(
                        assetName: character.idleAsset,
                        fallbackTitle: character.title,
                        tint: character.tint,
                        isEnemy: false
                    )
                    .padding(8)
                }
                .frame(width: 132, height: 132)
                .clipShape(RoundedRectangle(cornerRadius: 8))

                Text(character.title)
                    .font(.vhs(size: 12, weight: .black, design: .rounded))
                    .foregroundStyle(.white)
                    .lineLimit(1)
                    .minimumScaleFactor(0.6)

                Text("\(character.attackFrames.count) ATTACKS")
                    .font(.vhs(size: 8, weight: .black, design: .monospaced))
                    .foregroundStyle(character.tint)
            }
            .padding(10)
            .frame(width: 154, alignment: .leading)
            .background(theme.panelColor.opacity(0.58))
            .overlay {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(
                        isSelected
                            ? theme.secondaryColor.opacity(0.95)
                            : .white.opacity(0.14),
                        lineWidth: isSelected ? 2 : 1
                    )
            }
            .clipShape(RoundedRectangle(cornerRadius: 8))
        }
        .buttonStyle(.plain)
    }
}
