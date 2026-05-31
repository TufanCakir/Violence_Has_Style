//
//  StylePassView.swift
//  Violence Has Style
//
//  Created by Tufan Cakir on 31.05.26.
//

import SwiftUI

struct StylePassView: View {
    let passes: [StylePassDefinition]
    let points: Int
    let unlockedRewardIds: [String]
    let ownedPremiumPassIds: [String]
    let claimReward: (StylePassReward) -> Void
    let back: () -> Void

    var body: some View {
        ZStack {
            ThemeBackgroundView()

            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    VStack(alignment: .leading, spacing: 3) {
                        Text("STYLE PASSES")
                            .font(
                                .system(
                                    size: 24,
                                    weight: .black,
                                    design: .rounded
                                )
                            )
                            .foregroundStyle(
                                ThemeManager.shared.currentTheme.textColor
                            )

                        Text("\(points) STYLE POINTS")
                            .font(
                                .system(
                                    size: 11,
                                    weight: .black,
                                    design: .monospaced
                                )
                            )
                            .foregroundStyle(
                                ThemeManager.shared.currentTheme.primaryColor
                            )
                    }

                    Spacer()

                    BackButton(action: back)
                }

                ScrollView {
                    VStack(spacing: 14) {
                        ForEach(passes) { pass in
                            VStack(alignment: .leading, spacing: 10) {
                                Text(pass.title)
                                    .font(
                                        .system(
                                            size: 20,
                                            weight: .black,
                                            design: .rounded
                                        )
                                    )
                                    .foregroundStyle(pass.themeColor)

                                ForEach(pass.rewards) { reward in
                                    Button {
                                        claimReward(reward)
                                    } label: {
                                        let isPremiumLocked =
                                            reward.isPremium == true
                                            && !ownedPremiumPassIds.contains(
                                                pass.id
                                            )

                                        HStack(spacing: 10) {
                                            Circle()
                                                .fill(reward.color)
                                                .frame(width: 16, height: 16)

                                            VStack(
                                                alignment: .leading,
                                                spacing: 4
                                            ) {
                                                Text(reward.title)
                                                    .font(
                                                        .system(
                                                            size: 14,
                                                            weight: .black,
                                                            design: .rounded
                                                        )
                                                    )
                                                    .foregroundStyle(
                                                        reward.color
                                                    )

                                                Text(reward.description)
                                                    .font(
                                                        .system(
                                                            size: 10,
                                                            weight: .bold,
                                                            design: .monospaced
                                                        )
                                                    )
                                                    .foregroundStyle(
                                                        .white.opacity(0.62)
                                                    )
                                            }

                                            Spacer()

                                            Text(
                                                unlockedRewardIds.contains(
                                                    reward.id
                                                )
                                                    ? "CLAIMED"
                                                    : isPremiumLocked
                                                        ? "PREMIUM"
                                                        : "\(reward.requiredPoints)"
                                            )
                                            .font(
                                                .system(
                                                    size: 10,
                                                    weight: .black,
                                                    design: .monospaced
                                                )
                                            )
                                            .foregroundStyle(
                                                unlockedRewardIds.contains(
                                                    reward.id
                                                ) ? .white : pass.themeColor
                                            )
                                        }
                                        .padding(12)
                                        .background(
                                            ThemeManager.shared.currentTheme
                                                .panelColor.opacity(0.52)
                                        )
                                        .overlay {
                                            RoundedRectangle(cornerRadius: 8)
                                                .stroke(
                                                    reward.color.opacity(0.6),
                                                    lineWidth: 1
                                                )
                                        }
                                        .clipShape(
                                            RoundedRectangle(cornerRadius: 8)
                                        )
                                    }
                                    .buttonStyle(.plain)
                                    .disabled(
                                        points < reward.requiredPoints
                                            || reward.isPremium == true
                                                && !ownedPremiumPassIds
                                                    .contains(pass.id)
                                            || unlockedRewardIds.contains(
                                                reward.id
                                            )
                                    )
                                    .opacity(
                                        points >= reward.requiredPoints
                                            && (reward.isPremium != true
                                                || ownedPremiumPassIds.contains(
                                                    pass.id
                                                ))
                                            || unlockedRewardIds.contains(
                                                reward.id
                                            ) ? 1 : 0.45
                                    )
                                }
                            }
                            .padding(14)
                            .background(
                                ThemeManager.shared.currentTheme.panelColor
                                    .opacity(0.72)
                            )
                            .overlay {
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(
                                        pass.themeColor.opacity(0.55),
                                        lineWidth: 1
                                    )
                            }
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                    }
                }
            }
            .padding(24)
        }
    }
}
