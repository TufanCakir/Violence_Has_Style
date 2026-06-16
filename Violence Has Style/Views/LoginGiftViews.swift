//
//  LoginGiftViews.swift
//  Violence Has Style
//
//  Created by Tufan Cakir on 16.06.26.
//

import SwiftUI

struct GiftBoxView: View {
    let gifts: [GiftDefinition]
    let claimedGiftIds: [String]
    let claimGift: (GiftDefinition) -> Void
    let back: () -> Void

    var body: some View {
        ZStack {
            ThemeBackgroundView()

            VStack(alignment: .leading, spacing: 14) {
                HStack {
                    Text("GIFT BOX")
                        .font(
                            .system(size: 26, weight: .black, design: .rounded)
                        )
                        .foregroundStyle(.white)

                    Spacer()

                    BackButton(action: back)
                }

                ScrollView {
                    VStack(spacing: 10) {
                        ForEach(gifts) { gift in
                            GiftCardView(
                                gift: gift,
                                isClaimed: claimedGiftIds.contains(gift.id),
                                claim: { claimGift(gift) }
                            )
                        }
                    }
                }
            }
            .padding(24)
        }
    }
}

struct DailyLoginPopupView: View {
    let campaign: LoginCampaignDefinition
    let todayReward: LoginRewardDefinition
    let claimedRewardKeys: [String]
    let claim: () -> Void
    let close: () -> Void

    var body: some View {
        ZStack {
            Color.black.opacity(0.72)
                .ignoresSafeArea()

            VStack(alignment: .leading, spacing: 14) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(campaign.title)
                            .font(
                                .system(
                                    size: 24,
                                    weight: .black,
                                    design: .rounded
                                )
                            )
                            .foregroundStyle(.white)

                        Text(campaign.subtitle)
                            .font(
                                .system(
                                    size: 10,
                                    weight: .black,
                                    design: .monospaced
                                )
                            )
                            .foregroundStyle(.white.opacity(0.58))
                    }

                    Spacer()

                    Button("LATER", action: close)
                        .font(
                            .system(size: 11, weight: .black, design: .rounded)
                        )
                        .foregroundStyle(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(.white.opacity(0.16))
                        .clipShape(Capsule())
                }

                RewardGrantRowView(reward: todayReward.reward, isCompact: false)

                Text("NEXT REWARDS")
                    .font(
                        .system(size: 10, weight: .black, design: .monospaced)
                    )
                    .foregroundStyle(.white.opacity(0.55))

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(campaign.sortedRewards.prefix(7)) { reward in
                            VStack(spacing: 7) {
                                Text("DAY \(reward.day)")
                                    .font(
                                        .system(
                                            size: 8,
                                            weight: .black,
                                            design: .monospaced
                                        )
                                    )
                                    .foregroundStyle(.white.opacity(0.48))

                                Image(systemName: reward.reward.symbol)
                                    .font(.system(size: 18, weight: .black))
                                    .foregroundStyle(reward.reward.color)

                                Text(reward.reward.title)
                                    .font(
                                        .system(
                                            size: 8,
                                            weight: .black,
                                            design: .rounded
                                        )
                                    )
                                    .foregroundStyle(.white)
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.55)
                            }
                            .frame(width: 78, height: 82)
                            .background(.black.opacity(0.34))
                            .overlay {
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(
                                        reward.reward.id
                                            == todayReward.reward.id
                                            ? campaign.themeColor
                                            : .white.opacity(0.12),
                                        lineWidth: 1
                                    )
                            }
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                    }
                }

                Button(action: claim) {
                    Text("CLAIM DAILY")
                        .font(
                            .system(size: 16, weight: .black, design: .rounded)
                        )
                        .foregroundStyle(.black)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(campaign.themeColor)
                        .clipShape(Capsule())
                }
                .buttonStyle(.plain)
            }
            .padding(18)
            .background(
                ThemeManager.shared.currentTheme.panelColor.opacity(0.96)
            )
            .overlay {
                RoundedRectangle(cornerRadius: 12)
                    .stroke(campaign.themeColor.opacity(0.72), lineWidth: 1)
            }
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .padding(18)
        }
    }
}

private struct GiftCardView: View {
    let gift: GiftDefinition
    let isClaimed: Bool
    let claim: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(gift.title)
                        .font(
                            .system(size: 17, weight: .black, design: .rounded)
                        )
                        .foregroundStyle(.white)

                    Text(gift.message)
                        .font(
                            .system(
                                size: 9,
                                weight: .black,
                                design: .monospaced
                            )
                        )
                        .foregroundStyle(.white.opacity(0.55))
                }

                Spacer()

                Text(isClaimed ? "CLAIMED" : gift.isActive ? "CLAIM" : "LOCKED")
                    .font(
                        .system(size: 10, weight: .black, design: .monospaced)
                    )
                    .foregroundStyle(isClaimed ? .gray : gift.themeColor)
            }

            ForEach(gift.rewards) { reward in
                RewardGrantRowView(reward: reward, isCompact: true)
            }

            Button(action: claim) {
                Text(isClaimed ? "ALREADY CLAIMED" : "CLAIM GIFT")
                    .font(.system(size: 12, weight: .black, design: .rounded))
                    .foregroundStyle(isClaimed ? .white.opacity(0.42) : .black)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .background(
                        isClaimed ? .white.opacity(0.08) : gift.themeColor
                    )
                    .clipShape(Capsule())
            }
            .buttonStyle(.plain)
            .disabled(isClaimed || !gift.isActive)
        }
        .padding(14)
        .background(ThemeManager.shared.currentTheme.panelColor.opacity(0.76))
        .overlay {
            RoundedRectangle(cornerRadius: 8)
                .stroke(gift.themeColor.opacity(0.45), lineWidth: 1)
        }
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

private struct RewardGrantRowView: View {
    let reward: RewardGrant
    let isCompact: Bool

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: reward.symbol)
                .font(.system(size: isCompact ? 16 : 22, weight: .black))
                .foregroundStyle(reward.color)
                .frame(width: isCompact ? 24 : 34)

            VStack(alignment: .leading, spacing: 3) {
                Text(reward.title)
                    .font(
                        .system(
                            size: isCompact ? 12 : 16,
                            weight: .black,
                            design: .rounded
                        )
                    )
                    .foregroundStyle(.white)

                Text(reward.description)
                    .font(.system(size: 8, weight: .black, design: .monospaced))
                    .foregroundStyle(.white.opacity(0.48))
            }

            Spacer()

            if reward.amount > 1 {
                Text("+\(reward.amount)")
                    .font(
                        .system(
                            size: isCompact ? 12 : 16,
                            weight: .black,
                            design: .rounded
                        )
                    )
                    .foregroundStyle(reward.color)
            }
        }
        .padding(isCompact ? 9 : 13)
        .background(.black.opacity(0.28))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}
