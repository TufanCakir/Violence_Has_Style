//
//  LoginGiftModels.swift
//  Violence Has Style
//
//  Created by Tufan Cakir on 11.06.26.
//

import SwiftUI

struct RewardGrant: Codable, Equatable, Identifiable {

    let id: String
    let title: String
    let description: String
    let rewardType: String
    let rewardValue: String
    let amount: Int
    let colorHex: String
    let symbol: String

    var color: Color { Color(hex: colorHex) }
}

struct LoginRewardDefinition: Codable, Equatable, Identifiable {
    let day: Int
    let reward: RewardGrant

    var id: String {
        "day_\(day)_\(reward.id)"
    }
}

struct LoginCampaignDefinition: Codable, Equatable, Identifiable {
    let id: String
    let title: String
    let subtitle: String
    let kind: String
    let startsAt: String?
    let endsAt: String?
    let themeColorHex: String
    let rewards: [LoginRewardDefinition]

    var themeColor: Color { Color(hex: themeColorHex) }
    var isDailyLoop: Bool { kind == "dailyLoop" }

    var isActive: Bool {
        guard !isDailyLoop else { return true }

        let now = Date()
        if let startsAt, let start = EventDateParser.date(from: startsAt),
            now < start
        {
            return false
        }

        if let endsAt, let end = EventDateParser.date(from: endsAt),
            now > end
        {
            return false
        }

        return true
    }

    var sortedRewards: [LoginRewardDefinition] {
        rewards.sorted { $0.day < $1.day }
    }

    func reward(for streak: Int) -> LoginRewardDefinition? {
        let rewards = sortedRewards
        guard !rewards.isEmpty else { return nil }
        let index = max(0, streak) % rewards.count
        return rewards[index]
    }

    func eventRewardForToday() -> LoginRewardDefinition? {
        guard !isDailyLoop, let startsAt,
            let start = EventDateParser.date(from: startsAt)
        else {
            return sortedRewards.first
        }

        let calendar = Calendar.current
        let startDay = calendar.startOfDay(for: start)
        let today = calendar.startOfDay(for: Date())
        let dayOffset =
            calendar.dateComponents([.day], from: startDay, to: today).day ?? 0
        return sortedRewards.first { $0.day == dayOffset + 1 }
    }

    static let fallback: [LoginCampaignDefinition] = [
        LoginCampaignDefinition(
            id: "daily_style_loop",
            title: "DAILY STYLE",
            subtitle: "Log in every day. The loop never ends.",
            kind: "dailyLoop",
            startsAt: nil,
            endsAt: nil,
            themeColorHex: "#20D9FF",
            rewards: [
                LoginRewardDefinition(
                    day: 1,
                    reward: RewardGrant(
                        id: "daily_coins_01",
                        title: "COIN HIT",
                        description: "Daily coins",
                        rewardType: "coins",
                        rewardValue: "coins",
                        amount: 150,
                        colorHex: "#FFCC33",
                        symbol: "circle.hexagongrid.fill"
                    )
                ),
                LoginRewardDefinition(
                    day: 2,
                    reward: RewardGrant(
                        id: "daily_style_points_01",
                        title: "STYLE POINTS",
                        description: "Daily Style Pass points",
                        rewardType: "stylePassPoints",
                        rewardValue: "stylePassPoints",
                        amount: 60,
                        colorHex: "#FF1744",
                        symbol: "bolt.fill"
                    )
                ),
                LoginRewardDefinition(
                    day: 3,
                    reward: RewardGrant(
                        id: "daily_crystals_01",
                        title: "CRYSTAL CHIP",
                        description: "Daily crystals",
                        rewardType: "crystals",
                        rewardValue: "crystals",
                        amount: 5,
                        colorHex: "#7CFFCE",
                        symbol: "diamond.fill"
                    )
                ),
            ]
        )
    ]
}

struct GiftDefinition: Codable, Equatable, Identifiable {
    let id: String
    let title: String
    let message: String
    let startsAt: String?
    let endsAt: String?
    let themeColorHex: String
    let rewards: [RewardGrant]

    var themeColor: Color { Color(hex: themeColorHex) }

    var isActive: Bool {
        let now = Date()
        if let startsAt, let start = EventDateParser.date(from: startsAt),
            now < start
        {
            return false
        }

        if let endsAt, let end = EventDateParser.date(from: endsAt), now > end {
            return false
        }

        return true
    }

    static let fallback: [GiftDefinition] = [
        GiftDefinition(
            id: "welcome_style_gift",
            title: "WELCOME GIFT",
            message: "A starter gift for new stylists.",
            startsAt: nil,
            endsAt: nil,
            themeColorHex: "#FF1744",
            rewards: [
                RewardGrant(
                    id: "welcome_coins",
                    title: "COINS",
                    description: "Starter coins",
                    rewardType: "coins",
                    rewardValue: "coins",
                    amount: 500,
                    colorHex: "#FFCC33",
                    symbol: "circle.hexagongrid.fill"
                )
            ]
        )
    ]
}

struct LoginCampaignCatalog {
    static let shared = LoginCampaignCatalog()

    private init() {}

    var campaigns: [LoginCampaignDefinition] {
        let remote = RemoteContentStore.shared.loginCampaignDefinitions
        return remote.isEmpty ? LoginCampaignDefinition.fallback : remote
    }

    var activeCampaigns: [LoginCampaignDefinition] {
        campaigns.filter(\.isActive)
    }
}

struct GiftCatalog {
    static let shared = GiftCatalog()

    private init() {}

    var gifts: [GiftDefinition] {
        let remote = RemoteContentStore.shared.giftDefinitions
        return remote.isEmpty ? GiftDefinition.fallback : remote
    }

    var activeGifts: [GiftDefinition] {
        gifts.filter(\.isActive)
    }
}
