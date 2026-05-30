//
//  RootView.swift
//  Violence Has Style
//
//  Created by Tufan Cakir on 30.05.26.
//

import SwiftUI

struct RootView<Content: View>: View {
    let styleRank: StyleRank
    let coins: Int
    let crystals: Int
    let eventTitle: String?
    let eventBalance: Int
    let selectedScreen: GameScreen
    let selectScreen: (GameScreen) -> Void
    @ViewBuilder let content: Content

    var body: some View {
        VStack(spacing: 0) {
            GlobalHeaderView(
                styleRank: styleRank,
                coins: coins,
                crystals: crystals,
                eventTitle: eventTitle,
                eventBalance: eventBalance
            )

            content
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .clipped()

            GlobalFooterView(
                selectedScreen: selectedScreen,
                selectScreen: selectScreen
            )
        }
        .background(Color.black.ignoresSafeArea())
    }
}

private struct GlobalHeaderView: View {
    let styleRank: StyleRank
    let coins: Int
    let crystals: Int
    let eventTitle: String?
    let eventBalance: Int

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

            HeaderCurrencyView(
                title: "COINS",
                value: coins,
                color: .yellow,
                iconAsset: "currency_coin",
                fallbackSymbol: "circle.hexagongrid.fill"
            )
            HeaderCurrencyView(
                title: "CRYSTAL",
                value: crystals,
                color: .cyan,
                iconAsset: "currency_crystal",
                fallbackSymbol: "circle.hexagongrid.fill"
            )

            if let eventTitle {
                HeaderCurrencyView(
                    title: eventTitle,
                    value: eventBalance,
                    color: .red,
                    iconAsset: "currency_blood_coin",
                    fallbackSymbol: "drop.fill"
                )
            }
        }
        .frame(height: 56)
        .padding(.horizontal, 14)
        .background(.black.opacity(0.92))
        .overlay(alignment: .bottom) {
            Rectangle()
                .fill(.white.opacity(0.12))
                .frame(height: 1)
        }
    }
}

struct RemoteIcon: View {

    let assetName: String
    let fallbackSymbol: String

    var body: some View {

        AsyncImage(
            url: RemoteContentStore.shared.assetURL(
                named: assetName
            )
        ) { phase in

            if let image = phase.image {

                image
                    .resizable()
                    .scaledToFit()

            } else {

                Image(systemName: fallbackSymbol)
            }
        }
    }
}

private struct HeaderCurrencyView: View {
    let title: String
    let value: Int
    let color: Color
    let iconAsset: String
    let fallbackSymbol: String

    var body: some View {
        VStack(alignment: .trailing, spacing: 2) {
            HStack(spacing: 4) {
                RemoteIcon(
                    assetName: iconAsset,
                    fallbackSymbol: fallbackSymbol
                )
                .frame(width: 16, height: 16)

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
    let selectedScreen: GameScreen
    let selectScreen: (GameScreen) -> Void

    private let tabs: [FooterTab] = [
        .init(
            title: "STORY",
            iconName: "tab_story",
            fallbackSymbol: "book.closed.fill",
            screen: .storyMode
        ),
        .init(
            title: "EVENT",
            iconName: "tab_event",
            fallbackSymbol: "sparkles",
            screen: .eventMode
        ),
        .init(
            title: "ENDLESS",
            iconName: "tab_endless",
            fallbackSymbol: "infinity",
            screen: .endlessMode
        ),
        .init(
            title: "STYLE",
            iconName: "tab_style",
            fallbackSymbol: "paintbrush.fill",
            screen: .styleLab
        ),
        .init(
            title: "RANK",
            iconName: "tab_leaderboard",
            fallbackSymbol: "trophy.fill",
            screen: .leaderboard
        )
    ]

    var body: some View {
        HStack(spacing: 0) {
            ForEach(tabs) { tab in
                Button {
                    selectScreen(tab.screen)
                } label: {
                    VStack(spacing: 4) {
                        AsyncImage(url: RemoteContentStore.shared.assetURL(named: tab.iconName)) { phase in
                            if let image = phase.image {
                                image
                                    .resizable()
                                    .scaledToFit()
                            } else {
                                Image(systemName: tab.fallbackSymbol)
                                    .font(.system(size: 18, weight: .bold))
                            }
                        }
                        .frame(width: 22, height: 22)

                        Text(tab.title)
                            .font(.system(size: 8, weight: .black, design: .monospaced))
                            .lineLimit(1)
                            .minimumScaleFactor(0.6)
                    }
                    .foregroundStyle(isSelected(tab) ? tabColor(tab) : .white.opacity(0.45))
                    .frame(maxWidth: .infinity)
                    .frame(height: 62)
                    .background(isSelected(tab) ? tabColor(tab).opacity(0.12) : .clear)
                }
                .buttonStyle(.plain)
            }
        }
        .background(.black.opacity(0.94))
        .overlay(alignment: .top) {
            Rectangle()
                .fill(.white.opacity(0.12))
                .frame(height: 1)
        }
    }

    private func isSelected(_ tab: FooterTab) -> Bool {
        selectedScreen == tab.screen
    }

    private func tabColor(_ tab: FooterTab) -> Color {
        switch tab.screen {
        case .storyMode:
            return .red
        case .eventMode:
            return .purple
        case .endlessMode:
            return .orange
        case .styleLab:
            return .cyan
        case .leaderboard:
            return .yellow
        default:
            return .white
        }
    }
}

struct FooterTab: Identifiable {
    let title: String
    let iconName: String
    let fallbackSymbol: String
    let screen: GameScreen

    var id: String { title }
}
