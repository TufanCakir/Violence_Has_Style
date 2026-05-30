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

    init() {}
}

@Model
final class EventWallet {
    @Attribute(.unique) var currencyId: String
    var balance: Int
    var purchasedItemIds: [String]

    init(currencyId: String, balance: Int = 0, purchasedItemIds: [String] = []) {
        self.currencyId = currencyId
        self.balance = balance
        self.purchasedItemIds = purchasedItemIds
    }
}
