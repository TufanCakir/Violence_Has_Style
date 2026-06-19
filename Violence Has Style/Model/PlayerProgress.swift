//
//  PlayerProgress.swift
//  Violence Has Style
//
//  Created by Tufan Cakir on 30.05.26.
//

import SwiftData

@Model
final class PlayerProgress {
    
    var coins = 0
    var crystals = 0
    var bestFightsCleared = 0
    var bestMaxCombo = 0
    var bestStyleScore = 0
    var unlockedRewards: [String] = []
    var bossVerdicts: [String] = []
    var storyCompletedChapterCount = 0
    var endlessHighScore = 0
    var endlessBestFights = 0
    var stylePassPoints = 0
    var unlockedStylePassRewardIds: [String] = []
    var ownedThemeIds: [String] = ["vhs_default", "blood_moon"]
    var purchasedPremiumProductIds: [String] = []
    var ownedMusicPackIds: [String] = []
    var ownedPaintFxIds: [String] = []
    var ownedTitleIds: [String] = []
    var ownedPremiumPassIds: [String] = []
    var claimedGiftIds: [String] = []
    var claimedLoginRewardKeys: [String] = []
    var dailyLoginStreaks: [String] = []

    init() {}
}

@Model
final class EventWallet {
    @Attribute(.unique) var currencyId: String
    var balance: Int
    var purchasedItemIds: [String]

    init(currencyId: String, balance: Int = 0, purchasedItemIds: [String] = [])
    {
        self.currencyId = currencyId
        self.balance = balance
        self.purchasedItemIds = purchasedItemIds
    }
}
