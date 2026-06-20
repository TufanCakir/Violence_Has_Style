//
//  GameModels.swift
//  Violence Has Style
//
//  Created by Tufan Cakir on 30.05.26.
//

import Foundation
import SwiftUI

enum GameScreen {
    case title
    case menu
    case run
    case storyMode
    case eventMode
    case endlessMode
    case characterSelect
    case styleLab
    case gallery
    case eventShop
    case stylePasses
    case premiumStore
    case giftBox
    case trade
    case createCharacter
    case themeSelection
    case musicSelection
    case paintSelection
    case settings
}

extension GameScreen {
    init?(remoteId: String) {
        switch remoteId {
        case "title":
            self = .title
        case "menu":
            self = .menu
        case "run":
            self = .run
        case "storyMode":
            self = .storyMode
        case "eventMode":
            self = .eventMode
        case "endlessMode":
            self = .endlessMode
        case "characterSelect":
            self = .characterSelect
        case "styleLab":
            self = .styleLab
        case "gallery":
            self = .gallery
        case "eventShop":
            self = .eventShop
        case "stylePasses":
            self = .stylePasses
        case "premiumStore":
            self = .premiumStore
        case "giftBox":
            self = .giftBox
        case "trade":
            self = .trade
        case "createCharacter":
            self = .createCharacter
        case "themeSelection":
            self = .themeSelection
        case "musicSelection":
            self = .musicSelection
        case "paintSelection":
            self = .paintSelection
        case "settings":
            self = .settings
        default:
            return nil
        }
    }
}

struct UIConfig: Codable, Equatable {

    let titleLogoAssetId: String?
    let appLogoAssetId: String?
    let typography: TypographyDefinition
    let footerTabs: [FooterTabDefinition]
    let headerCurrencies: [HeaderCurrencyDefinition]

    init(
        titleLogoAssetId: String?,
        appLogoAssetId: String?,
        typography: TypographyDefinition,
        footerTabs: [FooterTabDefinition],
        headerCurrencies: [HeaderCurrencyDefinition]
    ) {
        self.titleLogoAssetId = titleLogoAssetId
        self.appLogoAssetId = appLogoAssetId
        self.typography = typography
        self.footerTabs = footerTabs
        self.headerCurrencies = headerCurrencies
    }

    enum CodingKeys: String, CodingKey {
        case titleLogoAssetId
        case appLogoAssetId
        case typography
        case footerTabs
        case headerCurrencies
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        titleLogoAssetId = try container.decodeIfPresent(
            String.self,
            forKey: .titleLogoAssetId
        )
        appLogoAssetId = try container.decodeIfPresent(
            String.self,
            forKey: .appLogoAssetId
        )
        typography =
            try container.decodeIfPresent(
                TypographyDefinition.self,
                forKey: .typography
            ) ?? .fallback
        footerTabs = try container.decode(
            [FooterTabDefinition].self,
            forKey: .footerTabs
        )
        headerCurrencies = try container.decode(
            [HeaderCurrencyDefinition].self,
            forKey: .headerCurrencies
        )
    }

    static let fallback = UIConfig(
        titleLogoAssetId: "logo_vhs_purple",
        appLogoAssetId: "logo_vhs_purple",
        typography: .fallback,
        footerTabs: [
            FooterTabDefinition(
                id: "story",
                title: "STORY",
                symbol: "book.closed.fill",
                screen: "storyMode",
                colorHex: "#FF1744"
            ),
            FooterTabDefinition(
                id: "create",
                title: "CREATE",
                symbol: "person.crop.circle.badge.plus",
                screen: "createCharacter",
                colorHex: "#C9B6FF"
            ),
            FooterTabDefinition(
                id: "style",
                title: "STYLE",
                symbol: "paintbrush.fill",
                screen: "styleLab",
                colorHex: "#20D9FF"
            ),
            FooterTabDefinition(
                id: "store",
                title: "STORE",
                symbol: "bag.fill",
                screen: "premiumStore",
                colorHex: "#FFCC33"
            ),
            FooterTabDefinition(
                id: "trade",
                title: "TRADE",
                symbol: "arrow.left.arrow.right",
                screen: "trade",
                colorHex: "#9B5CFF"
            ),
        ],
        headerCurrencies: [
            HeaderCurrencyDefinition(
                id: "coins",
                title: "COINS",
                symbol: "circle.hexagongrid.fill",
                colorHex: "#FFCC33"
            ),
            HeaderCurrencyDefinition(
                id: "crystals",
                title: "CRYSTAL",
                symbol: "diamond.fill",
                colorHex: "#20D9FF"
            ),
            HeaderCurrencyDefinition(
                id: "event",
                title: "EVENT",
                symbol: "drop.fill",
                colorHex: "#FF1744"
            ),
        ]
    )
}

struct TypographyDefinition: Codable, Equatable {
    let fontName: String?
    let primaryTextHex: String
    let secondaryTextHex: String
    let mutedTextHex: String

    var primaryTextColor: Color {
        Color(hex: primaryTextHex)
    }

    var secondaryTextColor: Color {
        Color(hex: secondaryTextHex)
    }

    var mutedTextColor: Color {
        Color(hex: mutedTextHex)
    }

    static let fallback = TypographyDefinition(
        fontName: FontManager.fallbackFontName,
        primaryTextHex: "#FFFFFF",
        secondaryTextHex: "#C9B6FF",
        mutedTextHex: "#A79EB8"
    )
}

struct FooterTabDefinition: Codable, Equatable, Identifiable {
    let id: String
    let title: String
    let symbol: String
    let screen: String
    let colorHex: String

    var gameScreen: GameScreen? {
        GameScreen(remoteId: screen)
    }

    var color: Color {
        Color(hex: colorHex)
    }
}

struct HeaderCurrencyDefinition: Codable, Equatable, Identifiable {
    let id: String
    let title: String
    let symbol: String
    let colorHex: String

    var color: Color {
        Color(hex: colorHex)
    }
}

struct HeaderCurrencyDisplay: Identifiable {
    let id: String
    let title: String
    let symbol: String
    let value: Int
    let color: Color
}

struct TradeDefinition: Codable, Equatable, Identifiable {
    let id: String
    let title: String
    let fromCurrencyId: String
    let fromTitle: String
    let fromSymbol: String
    let fromColorHex: String
    let fromAmount: Int
    let toCurrencyId: String
    let toTitle: String
    let toSymbol: String
    let toColorHex: String
    let toAmount: Int
    let isEnabled: Bool

    var fromColor: Color { Color(hex: fromColorHex) }
    var toColor: Color { Color(hex: toColorHex) }
}

struct TradeCatalog {
    static let shared = TradeCatalog()

    var trades: [TradeDefinition] {
        let remoteTrades = RemoteContentStore.shared.tradeDefinitions
        return remoteTrades.isEmpty
            ? Self.loadBundledTrades() : remoteTrades.filter(\.isEnabled)
    }

    private static func loadBundledTrades() -> [TradeDefinition] {
        guard
            let url = Bundle.main.url(
                forResource: "TradeDefinitions",
                withExtension: "json"
            ),
            let data = try? Data(contentsOf: url),
            let decoded = try? JSONDecoder().decode(
                [TradeDefinition].self,
                from: data
            )
        else {
            return []
        }

        return decoded.filter(\.isEnabled)
    }
}

struct StyleAwakeningDefinition: Codable, Equatable, Identifiable {
    let id: String
    let styleId: String
    let title: String
    let verdict: String
    let awakeningAsset: String?
    let paintColorHex: String?
    let secondaryPaintColorHex: String?
    let styleGain: Int
    let burstCountBonus: Int
    let shake: Double

    var style: CombatStyle? {
        CombatStyle(remoteId: styleId)
    }

    var paintColor: Color? {
        guard let paintColorHex else { return nil }
        return Color(hex: paintColorHex)
    }

    var secondaryPaintColor: Color? {
        guard let secondaryPaintColorHex else { return nil }
        return Color(hex: secondaryPaintColorHex)
    }

    static let fallback: [StyleAwakeningDefinition] = [
        StyleAwakeningDefinition(
            id: "killer_awake",
            styleId: "killer",
            title: "KILLER AWAKENING",
            verdict: "SHOW SPEED",
            awakeningAsset: "character_vhs_attack1",
            paintColorHex: "#FF1744",
            secondaryPaintColorHex: "#20D9FF",
            styleGain: 8,
            burstCountBonus: 1,
            shake: 8
        ),
        StyleAwakeningDefinition(
            id: "reaper_awake",
            styleId: "reaper",
            title: "REAPER AWAKENING",
            verdict: "MAKE IT HEAVY",
            awakeningAsset: "character_vhs_attack2",
            paintColorHex: "#9B5CFF",
            secondaryPaintColorHex: "#FF1744",
            styleGain: 6,
            burstCountBonus: 0,
            shake: 14
        ),
        StyleAwakeningDefinition(
            id: "phantom_awake",
            styleId: "phantom",
            title: "PHANTOM AWAKENING",
            verdict: "VANISH",
            awakeningAsset: "character_vhs_attack3",
            paintColorHex: "#7CFFCE",
            secondaryPaintColorHex: "#9B5CFF",
            styleGain: 10,
            burstCountBonus: 1,
            shake: 6
        ),
        StyleAwakeningDefinition(
            id: "blood_awake",
            styleId: "blood",
            title: "BLOOD AWAKENING",
            verdict: "BLEED BEAUTIFUL",
            awakeningAsset: "character_vhs_attack3",
            paintColorHex: "#FF1744",
            secondaryPaintColorHex: "#FFFFFF",
            styleGain: 12,
            burstCountBonus: 2,
            shake: 12
        ),
        StyleAwakeningDefinition(
            id: "void_awake",
            styleId: "void",
            title: "VOID AWAKENING",
            verdict: "EMPTY THE ROOM",
            awakeningAsset: "character_vhs_attack9",
            paintColorHex: "#4B4DFF",
            secondaryPaintColorHex: "#7CFFCE",
            styleGain: 11,
            burstCountBonus: 1,
            shake: 7
        ),
        StyleAwakeningDefinition(
            id: "chaos_awake",
            styleId: "chaos",
            title: "CHAOS AWAKENING",
            verdict: "MAKE IT LOUD",
            awakeningAsset: "character_vhs_attack1",
            paintColorHex: "#FFCC33",
            secondaryPaintColorHex: "#FF1744",
            styleGain: 5,
            burstCountBonus: 3,
            shake: 18
        ),
    ]
}

enum StyleAwakeningCatalog {
    static var awakenings: [StyleAwakeningDefinition] {
        let loaded = RemoteContentStore.shared.styleAwakeningDefinitions
        return loaded.isEmpty ? StyleAwakeningDefinition.fallback : loaded
    }

    static func awakening(for style: CombatStyle) -> StyleAwakeningDefinition? {
        awakenings.first { $0.style == style }
    }
}

enum RunMode: String {
    case story
    case event
    case endless
    case style
}

struct StyleRank: Equatable {
    private let definition: StyleRankDefinition

    init(style: Int) {
        definition = Self.definition(forStyle: style)
    }

    init(score: Int) {
        definition = Self.definition(forScore: score)
    }

    private init(definition: StyleRankDefinition) {
        self.definition = definition
    }

    var title: String {
        definition.title
    }

    var verdict: String {
        definition.verdict
    }

    var color: Color {
        definition.color
    }

    var playerTint: Color {
        definition.playerTint
    }

    var damage: Int {
        definition.damage
    }

    var canFinish: Bool {
        definition.canFinish
    }

    var score: Int {
        definition.score
    }

    static var pathetic: StyleRank {
        StyleRank(definition: definition(id: "d"))
    }

    static var savage: StyleRank {
        StyleRank(definition: definition(id: "s"))
    }

    static var brutal: StyleRank {
        StyleRank(definition: definition(id: "ss"))
    }

    static var styleGod: StyleRank {
        StyleRank(definition: definition(id: "style_god"))
    }

    private static var definitions: [StyleRankDefinition] {
        let ranks = RemoteContentStore.shared.gameConfig.styleRanks
        return ranks.isEmpty ? StyleRankDefinition.fallback : ranks
    }

    private static func definition(forStyle style: Int) -> StyleRankDefinition {
        definitions
            .sorted { $0.minStyle < $1.minStyle }
            .last { style >= $0.minStyle } ?? StyleRankDefinition.fallback[0]
    }

    private static func definition(forScore score: Int) -> StyleRankDefinition {
        definitions
            .sorted { $0.score < $1.score }
            .last { score >= $0.score } ?? StyleRankDefinition.fallback[0]
    }

    private static func definition(id: String) -> StyleRankDefinition {
        definitions.first { $0.id == id }
            ?? StyleRankDefinition.fallback.first { $0.id == id }
            ?? StyleRankDefinition.fallback[0]
    }
}

struct StyleRankDefinition: Codable, Equatable, Identifiable {
    let id: String
    let title: String
    let verdict: String
    let minStyle: Int
    let score: Int
    let colorHex: String
    let playerTintHex: String
    let damage: Int
    let canFinish: Bool

    var color: Color {
        Color(hex: colorHex)
    }

    var playerTint: Color {
        Color(hex: playerTintHex)
    }

    static let fallback: [StyleRankDefinition] = [
        StyleRankDefinition(
            id: "d",
            title: "D",
            verdict: "PATHETIC",
            minStyle: 0,
            score: 0,
            colorHex: "#8A8A8A",
            playerTintHex: "#20D9FF",
            damage: 10,
            canFinish: false
        ),
        StyleRankDefinition(
            id: "c",
            title: "C",
            verdict: "WARMING UP",
            minStyle: 20,
            score: 1,
            colorHex: "#FFFFFF",
            playerTintHex: "#FFFFFF",
            damage: 12,
            canFinish: false
        ),
        StyleRankDefinition(
            id: "b",
            title: "B",
            verdict: "CLEAN",
            minStyle: 35,
            score: 2,
            colorHex: "#7CFFCE",
            playerTintHex: "#7CFFCE",
            damage: 14,
            canFinish: false
        ),
        StyleRankDefinition(
            id: "a",
            title: "A",
            verdict: "SHARP",
            minStyle: 50,
            score: 3,
            colorHex: "#20D9FF",
            playerTintHex: "#20D9FF",
            damage: 17,
            canFinish: true
        ),
        StyleRankDefinition(
            id: "s",
            title: "S",
            verdict: "SAVAGE",
            minStyle: 65,
            score: 4,
            colorHex: "#FF1744",
            playerTintHex: "#FF1744",
            damage: 20,
            canFinish: true
        ),
        StyleRankDefinition(
            id: "ss",
            title: "SS",
            verdict: "BRUTAL",
            minStyle: 78,
            score: 5,
            colorHex: "#FF9F1A",
            playerTintHex: "#FF9F1A",
            damage: 24,
            canFinish: true
        ),
        StyleRankDefinition(
            id: "sss",
            title: "SSS",
            verdict: "VIOLENCE HAS STYLE",
            minStyle: 88,
            score: 6,
            colorHex: "#9B5CFF",
            playerTintHex: "#FFFFFF",
            damage: 30,
            canFinish: true
        ),
        StyleRankDefinition(
            id: "style_god",
            title: "STYLE GOD",
            verdict: "STYLE GOD",
            minStyle: 96,
            score: 7,
            colorHex: "#20D9FF",
            playerTintHex: "#FFFFFF",
            damage: 38,
            canFinish: true
        ),
    ]
}

enum CombatStyle: CaseIterable, Equatable {
    case killer
    case reaper
    case phantom
    case blood
    case void
    case chaos

    init?(remoteId: String) {
        switch remoteId {
        case "killer":
            self = .killer
        case "reaper":
            self = .reaper
        case "phantom":
            self = .phantom
        case "blood":
            self = .blood
        case "void":
            self = .void
        case "chaos":
            self = .chaos
        default:
            return nil
        }
    }

    var remoteId: String {
        switch self {
        case .killer:
            return "killer"
        case .reaper:
            return "reaper"
        case .phantom:
            return "phantom"
        case .blood:
            return "blood"
        case .void:
            return "void"
        case .chaos:
            return "chaos"
        }
    }

    var title: String {
        switch self {
        case .killer:
            return "KILLER STYLE"
        case .reaper:
            return "REAPER STYLE"
        case .phantom:
            return "PHANTOM STYLE"
        case .blood:
            return "BLOOD STYLE"
        case .void:
            return "VOID STYLE"
        case .chaos:
            return "CHAOS STYLE"
        }
    }

    var shortRule: String {
        switch self {
        case .killer:
            return "FAST STYLE"
        case .reaper:
            return "HEAVY DAMAGE"
        case .phantom:
            return "DASH"
        case .blood:
            return "HP FOR POWER"
        case .void:
            return "STYLE DRAIN"
        case .chaos:
            return "RISK BURST"
        }
    }

    var labDescription: String {
        switch self {
        case .killer:
            return
                "Fast attacks build Style quickly. Best for reaching higher ranks."
        case .reaper:
            return
                "Heavy cuts deal more damage. Slower Style gain, stronger finish setup."
        case .phantom:
            return
                "Dash movement and clean dodges. Enough Style lets you avoid counterattacks."
        case .blood:
            return "Spend HP for extra Style and power. Dangerous, but violent."
        case .void:
            return
                "A darker Phantom variant. Lower damage, more control and clean movement."
        case .chaos:
            return "Unstable burst style. Big damage, volatile Style flow."
        }
    }

    var verdict: String {
        switch self {
        case .killer:
            return "SHOW SPEED"
        case .reaper:
            return "MAKE IT HEAVY"
        case .phantom:
            return "VANISH"
        case .blood:
            return "BLEED BEAUTIFUL"
        case .void:
            return "EMPTY THE ROOM"
        case .chaos:
            return "MAKE IT LOUD"
        }
    }

    var tint: Color {
        switch self {
        case .killer:
            return .cyan
        case .reaper:
            return .purple
        case .phantom:
            return .mint
        case .blood:
            return .red
        case .void:
            return .indigo
        case .chaos:
            return .yellow
        }
    }

    var paintColor: Color {
        switch self {
        case .killer:
            return .red
        case .reaper:
            return .purple
        case .phantom:
            return .mint
        case .blood:
            return .red
        case .void:
            return .indigo
        case .chaos:
            return .yellow
        }
    }

    var styleGain: Int {
        switch self {
        case .killer:
            return 12
        case .reaper:
            return 7
        case .phantom:
            return 10
        case .blood:
            return 9
        case .void:
            return 13
        case .chaos:
            return 6
        }
    }

    var strokeWidth: Int {
        switch self {
        case .killer:
            return 10
        case .reaper:
            return 18
        case .phantom:
            return 8
        case .blood:
            return 14
        case .void:
            return 11
        case .chaos:
            return 22
        }
    }

    var startX: CGFloat {
        switch self {
        case .killer:
            return 0.28
        case .reaper:
            return 0.2
        case .phantom:
            return 0.34
        case .blood:
            return 0.24
        case .void:
            return 0.12
        case .chaos:
            return 0.18
        }
    }

    var controlY: CGFloat {
        switch self {
        case .killer:
            return 0.18
        case .reaper:
            return 0.28
        case .phantom:
            return 0.08
        case .blood:
            return 0.22
        case .void:
            return 0.04
        case .chaos:
            return 0.3
        }
    }

    var curvePower: CGFloat {
        switch self {
        case .killer:
            return 0.06
        case .reaper:
            return 0.1
        case .phantom:
            return 0.02
        case .blood:
            return 0.08
        case .void:
            return 0.03
        case .chaos:
            return 0.14
        }
    }

    var paintBurstCount: Int {
        switch self {
        case .killer:
            return 3
        case .reaper:
            return 1
        case .phantom:
            return 2
        case .blood:
            return 4
        case .void:
            return 3
        case .chaos:
            return 5
        }
    }

    var impactShake: CGFloat {
        switch self {
        case .killer:
            return 6
        case .reaper:
            return 14
        case .phantom:
            return 5
        case .blood:
            return 11
        case .void:
            return 7
        case .chaos:
            return 18
        }
    }

    var verb: String {
        switch self {
        case .killer:
            return "CUT"
        case .reaper:
            return "HARVEST"
        case .phantom:
            return "VANISH"
        case .blood:
            return "BLEED"
        case .void:
            return "VOID"
        case .chaos:
            return "BURST"
        }
    }

    var next: CombatStyle {
        switch self {
        case .killer:
            return .reaper
        case .reaper:
            return .phantom
        case .phantom:
            return .blood
        case .blood:
            return .void
        case .void:
            return .chaos
        case .chaos:
            return .killer
        }
    }

    var previous: CombatStyle {
        switch self {
        case .killer:
            return .chaos
        case .reaper:
            return .killer
        case .phantom:
            return .reaper
        case .blood:
            return .phantom
        case .void:
            return .blood
        case .chaos:
            return .void
        }
    }

    func damage(for rank: StyleRank) -> Int {
        let base: Int
        switch self {
        case .killer:
            base = rank.damage
        case .reaper:
            base = rank.damage + 8
        case .phantom:
            base = max(8, rank.damage - 2)
        case .blood:
            base = rank.damage + 14
        case .void:
            base = max(7, rank.damage - 3)
        case .chaos:
            base = rank.damage + 18
        }

        return base
    }
}

struct PaintStroke: Identifiable {
    let id = UUID()
    let startX: CGFloat
    let startY: CGFloat
    let controlX: CGFloat
    let controlY: CGFloat
    let control2X: CGFloat
    let control2Y: CGFloat
    let endX: CGFloat
    let endY: CGFloat
    let lineWidth: CGFloat
    let opacity: Double
    let color: Color
}

struct PaintColor: Codable, Equatable {
    let hex: String

    var color: Color {
        Color(hex: hex)
    }

    init(_ hex: String) {
        self.hex = hex
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        hex = try container.decode(String.self)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(hex)
    }
}

struct RunReward: Codable, Equatable, Identifiable {
    let id: String
    let title: String
    let description: String
    let verdict: String
    let colorHex: String
    let styleStartBonus: Int
    let killerStyleBonus: Int
    let reaperDamageBonus: Int
    let phantomStyleBonus: Int
    let bloodCostReduction: Int

    var color: Color {
        Color(hex: colorHex)
    }

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case description
        case verdict
        case colorHex
        case styleStartBonus
        case killerStyleBonus
        case reaperDamageBonus
        case phantomStyleBonus
        case bloodCostReduction
    }

    init(
        id: String,
        title: String,
        description: String,
        verdict: String,
        colorHex: String,
        styleStartBonus: Int = 0,
        killerStyleBonus: Int = 0,
        reaperDamageBonus: Int = 0,
        phantomStyleBonus: Int = 0,
        bloodCostReduction: Int = 0
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.verdict = verdict
        self.colorHex = colorHex
        self.styleStartBonus = styleStartBonus
        self.killerStyleBonus = killerStyleBonus
        self.reaperDamageBonus = reaperDamageBonus
        self.phantomStyleBonus = phantomStyleBonus
        self.bloodCostReduction = bloodCostReduction
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        description = try container.decode(String.self, forKey: .description)
        verdict = try container.decode(String.self, forKey: .verdict)
        colorHex = try container.decode(String.self, forKey: .colorHex)
        styleStartBonus =
            try container.decodeIfPresent(Int.self, forKey: .styleStartBonus)
            ?? 0
        killerStyleBonus =
            try container.decodeIfPresent(Int.self, forKey: .killerStyleBonus)
            ?? 0
        reaperDamageBonus =
            try container.decodeIfPresent(Int.self, forKey: .reaperDamageBonus)
            ?? 0
        phantomStyleBonus =
            try container.decodeIfPresent(Int.self, forKey: .phantomStyleBonus)
            ?? 0
        bloodCostReduction =
            try container.decodeIfPresent(Int.self, forKey: .bloodCostReduction)
            ?? 0
    }

    static func nextChoices(for fightLevel: Int) -> [RunReward] {
        RewardCatalog.shared.nextChoices(for: fightLevel)
    }
}

struct RewardCatalog {
    static let shared = RewardCatalog()

    private let localRewards: [RunReward]

    private init() {
        localRewards = Self.fallbackRewards
    }

    var rewards: [RunReward] {
        RemoteContentStore.shared.rewardDefinitions.isEmpty
            ? localRewards : RemoteContentStore.shared.rewardDefinitions
    }

    func nextChoices(for fightLevel: Int) -> [RunReward] {
        let activeRewards = rewards
        guard !activeRewards.isEmpty else { return [] }

        return (0..<RemoteContentStore.shared.gameConfig.run.rewardChoices).map
        { index in
            activeRewards[(fightLevel + index) % activeRewards.count]
        }
    }

    private static let fallbackRewards: [RunReward] = [
        RunReward(
            id: "blood_rose",
            title: "BLOOD ROSE",
            description: "+15 Style Startwert pro Fight",
            verdict: "THE ROSE REMEMBERS",
            colorHex: "#FF2A2A",
            styleStartBonus: 15
        ),
        RunReward(
            id: "sharp_ego",
            title: "SHARP EGO",
            description: "Killer Style gibt mehr Style",
            verdict: "EGO SHARPENED",
            colorHex: "#20D9FF",
            killerStyleBonus: 4
        ),
        RunReward(
            id: "red_reaper",
            title: "RED REAPER",
            description: "Reaper Style macht mehr Schaden",
            verdict: "HEAVIER CUTS",
            colorHex: "#9B5CFF",
            reaperDamageBonus: 6
        ),
        RunReward(
            id: "phantom_step",
            title: "PHANTOM STEP",
            description: "Phantom Dash gibt extra Style",
            verdict: "FASTER THAN FEAR",
            colorHex: "#7CFFCE",
            phantomStyleBonus: 5
        ),
        RunReward(
            id: "last_drop",
            title: "LAST DROP",
            description: "Blood Style kostet weniger HP",
            verdict: "BLEED LESS, HURT MORE",
            colorHex: "#FF9F1A",
            bloodCostReduction: 1
        ),
    ]
}

struct EventDefinition: Codable, Equatable, Identifiable {
    let id: String
    let title: String
    let startsAt: String
    let endsAt: String
    let currencyId: String
    let currencyTitle: String
    let currencySymbol: String?
    let themeColorHex: String
    let currencyPerFinisher: Int
    let styleGodBonus: Int
    let shopItems: [EventShopItem]

    var themeColor: Color {
        Color(hex: themeColorHex)
    }

    var isActive: Bool {
        guard let start = EventDateParser.date(from: startsAt),
            let end = EventDateParser.date(from: endsAt)
        else {
            return false
        }

        let now = Date()
        return start <= now && now <= end
    }

    var startsAtDate: Date? {
        EventDateParser.date(from: startsAt)
    }

    var endsAtDate: Date? {
        EventDateParser.date(from: endsAt)
    }

    var isUpcoming: Bool {
        guard let start = startsAtDate else { return false }
        return Date() < start
    }

    func currencyReward(for rank: StyleRank) -> Int {
        currencyPerFinisher + (rank == .styleGod ? styleGodBonus : 0)
    }
}

enum EventDateParser {
    private static let germanDateTimeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "de_DE")
        formatter.timeZone = TimeZone(identifier: "Europe/Berlin")
        formatter.dateFormat = "dd.MM.yyyy HH:mm"
        return formatter
    }()

    static func date(from value: String) -> Date? {
        germanDateTimeFormatter.date(from: value)
            ?? ISO8601DateFormatter().date(from: value)
    }
}

struct EventShopItem: Codable, Equatable, Identifiable {
    let id: String
    let title: String
    let description: String
    let cost: Int
    let kind: String
    let value: String
    let colorHex: String

    var color: Color {
        Color(hex: colorHex)
    }
}

struct EventCatalog {
    static let shared = EventCatalog()

    private init() {}

    var events: [EventDefinition] {
        RemoteContentStore.shared.eventDefinitions
    }

    var activeEvent: EventDefinition? {
        events.first { $0.isActive }
    }

    var visibleEvents: [EventDefinition] {
        events.sorted {
            ($0.startsAtDate ?? .distantFuture)
                < ($1.startsAtDate ?? .distantFuture)
        }
    }

    func event(id: String?) -> EventDefinition? {
        guard let id else { return nil }
        return events.first { $0.id == id }
    }
}

struct StoryChapter: Codable, Equatable, Identifiable {
    let id: String
    let title: String
    let subtitle: String
    let requiredChapter: Int
    let startFight: Int
    let targetFights: Int
    let levelId: String?
    let introText: String
    let rewardText: String
    let colorHex: String

    var color: Color {
        Color(hex: colorHex)
    }
}

struct StoryCatalog {
    static let shared = StoryCatalog()

    private init() {}

    var chapters: [StoryChapter] {
        let remote = RemoteContentStore.shared.storyChapters
        return remote.isEmpty ? Self.fallbackChapters : remote
    }

    func chapter(id: String?) -> StoryChapter? {
        guard let id else { return nil }
        return chapters.first { $0.id == id }
    }

    private static let fallbackChapters: [StoryChapter] = [
        StoryChapter(
            id: "chapter_01",
            title: "CHAPTER 01",
            subtitle: "THE ALLEY LEARNS YOUR NAME",
            requiredChapter: 0,
            startFight: 1,
            targetFights: 2,
            levelId: "vhs_alley",
            introText: "Paint the first wall red.",
            rewardText: "Alley cleared.",
            colorHex: "#FF2A2A"
        )
    ]
}

struct MusicTrack: Codable, Equatable, Identifiable {
    let id: String
    let title: String
    let url: String
    let mode: String?
    let requiredUnlock: String?
}

struct MusicCatalog {
    static let shared = MusicCatalog()

    private init() {}

    var tracks: [MusicTrack] {
        RemoteContentStore.shared.musicTracks
    }

    func playlist(
        for mode: RunMode? = nil,
        ownedUnlockIds: [String] = []
    ) -> [MusicTrack] {
        let activeTracks = tracks.filter { track in
            guard let requiredUnlock = track.requiredUnlock,
                !requiredUnlock.isEmpty
            else {
                return true
            }

            return ownedUnlockIds.contains(requiredUnlock)
        }
        guard let mode else { return activeTracks }

        let filtered = activeTracks.filter {
            $0.mode == nil || $0.mode == mode.rawValue
        }
        return filtered.isEmpty ? activeTracks : filtered
    }
}

struct StylePassDefinition: Codable, Equatable, Identifiable {
    let id: String
    let title: String
    let startsAt: String
    let endsAt: String
    let themeColorHex: String
    let rewards: [StylePassReward]

    var themeColor: Color { Color(hex: themeColorHex) }

    var isActive: Bool {
        let parser = ISO8601DateFormatter()
        guard let start = parser.date(from: startsAt),
            let end = parser.date(from: endsAt)
        else {
            return false
        }
        let now = Date()
        return start <= now && now <= end
    }
}

struct StylePassReward: Codable, Equatable, Identifiable {
    let id: String
    let title: String
    let description: String
    let requiredPoints: Int
    let rewardType: String
    let rewardValue: String
    let colorHex: String
    let isPremium: Bool?

    var color: Color { Color(hex: colorHex) }
}

struct StylePassCatalog {
    static let shared = StylePassCatalog()

    private init() {}

    var passes: [StylePassDefinition] {
        RemoteContentStore.shared.stylePassDefinitions
    }

    var activePasses: [StylePassDefinition] {
        passes.filter(\.isActive)
    }
}

struct PremiumStoreProduct: Codable, Equatable, Identifiable {
    let id: String
    let productId: String
    let title: String
    let description: String
    let category: String
    let priceText: String
    let badge: String
    let symbol: String
    let colorHex: String
    let isFeatured: Bool
    let unlockType: String
    let unlockValue: String
    let unlockAmount: Int

    var color: Color {
        Color(hex: colorHex)
    }

    enum CodingKeys: String, CodingKey {
        case id
        case productId
        case title
        case description
        case category
        case priceText
        case badge
        case symbol
        case colorHex
        case isFeatured
        case unlockType
        case unlockValue
        case unlockAmount
    }

    init(
        id: String,
        productId: String,
        title: String,
        description: String,
        category: String,
        priceText: String,
        badge: String,
        symbol: String,
        colorHex: String,
        isFeatured: Bool,
        unlockType: String = "none",
        unlockValue: String = "",
        unlockAmount: Int = 0
    ) {
        self.id = id
        self.productId = productId
        self.title = title
        self.description = description
        self.category = category
        self.priceText = priceText
        self.badge = badge
        self.symbol = symbol
        self.colorHex = colorHex
        self.isFeatured = isFeatured
        self.unlockType = unlockType
        self.unlockValue = unlockValue
        self.unlockAmount = unlockAmount
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        productId = try container.decode(String.self, forKey: .productId)
        title = try container.decode(String.self, forKey: .title)
        description = try container.decode(String.self, forKey: .description)
        category = try container.decode(String.self, forKey: .category)
        priceText = try container.decode(String.self, forKey: .priceText)
        badge = try container.decode(String.self, forKey: .badge)
        symbol = try container.decode(String.self, forKey: .symbol)
        colorHex = try container.decode(String.self, forKey: .colorHex)
        isFeatured =
            try container.decodeIfPresent(Bool.self, forKey: .isFeatured)
            ?? false
        unlockType =
            try container.decodeIfPresent(String.self, forKey: .unlockType)
            ?? "none"
        unlockValue =
            try container.decodeIfPresent(String.self, forKey: .unlockValue)
            ?? ""
        unlockAmount =
            try container.decodeIfPresent(Int.self, forKey: .unlockAmount) ?? 0
    }
}

struct PremiumStoreCatalog {
    static let shared = PremiumStoreCatalog()

    private init() {}

    var products: [PremiumStoreProduct] {
        RemoteContentStore.shared.premiumStoreProducts
    }

    var featuredProducts: [PremiumStoreProduct] {
        products.filter(\.isFeatured)
    }
}

struct GameConfig: Codable, Equatable {
    let combat: CombatConfig
    let run: RunConfig
    let styleRanks: [StyleRankDefinition]

    static let fallback = GameConfig(
        combat: CombatConfig(
            maxStyle: 100,
            baseEnemyHealth: 100,
            enemyHealthPerFight: 16,
            enemyCounterStart: 3,
            finisherStyleCost: 45,
            finisherHeal: 12,
            lowStyleFinisherPenalty: 10,
            phantomDodgeMinStyle: 20,
            phantomDodgeStyleGain: 8,
            enemyStylePenalty: 12,
            bloodBaseCost: 4,
            bloodStyleGain: 6
        ),
        run: RunConfig(
            bossEveryXFights: 5,
            rewardChoices: 3,
            maxBloodCostReduction: 3
        ),
        styleRanks: StyleRankDefinition.fallback
    )

    enum CodingKeys: String, CodingKey {
        case combat
        case run
        case styleRanks
    }

    init(
        combat: CombatConfig,
        run: RunConfig,
        styleRanks: [StyleRankDefinition]
    ) {
        self.combat = combat
        self.run = run
        self.styleRanks = styleRanks
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        combat = try container.decode(CombatConfig.self, forKey: .combat)
        run = try container.decode(RunConfig.self, forKey: .run)
        styleRanks =
            try container.decodeIfPresent(
                [StyleRankDefinition].self,
                forKey: .styleRanks
            ) ?? StyleRankDefinition.fallback
    }
}

struct CombatConfig: Codable, Equatable {
    let maxStyle: Int
    let baseEnemyHealth: Int
    let enemyHealthPerFight: Int
    let enemyCounterStart: Int
    let finisherStyleCost: Int
    let finisherHeal: Int
    let lowStyleFinisherPenalty: Int
    let phantomDodgeMinStyle: Int
    let phantomDodgeStyleGain: Int
    let enemyStylePenalty: Int
    let bloodBaseCost: Int
    let bloodStyleGain: Int
}

struct RunConfig: Codable, Equatable {
    let bossEveryXFights: Int
    let rewardChoices: Int
    let maxBloodCostReduction: Int
}

struct EnemyDefinition: Codable, Equatable {
    let id: String
    let title: String
    let shape: String
    let symbol: String
    let impactSymbols: [String]
    let healthBonus: Int
    let counterDelay: Int
    let damageBonus: Int
    let styleBonus: Int
    let tintHex: String
    let brokenHex: String
    let scale: CGFloat
    let glowRadius: CGFloat
    let isBoss: Bool
    let introVerdict: String

    var tint: Color {
        Color(hex: tintHex)
    }

    var brokenColor: Color {
        Color(hex: brokenHex)
    }

    var idleState: String {
        "\(id)_shape_idle"
    }

    var hitStates: [String] {
        impactSymbols.isEmpty
            ? ["\(id)_shape_hit1", "\(id)_shape_hit2", "\(id)_shape_hit3"]
            : impactSymbols
    }

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case idleAsset
        case hitFrames
        case shape
        case symbol
        case impactSymbols
        case healthBonus
        case counterDelay
        case damageBonus
        case styleBonus
        case tintHex
        case brokenHex
        case scale
        case glowRadius
        case isBoss
        case introVerdict
    }

    init(
        id: String,
        title: String,
        shape: String,
        symbol: String,
        impactSymbols: [String],
        healthBonus: Int,
        counterDelay: Int,
        damageBonus: Int,
        styleBonus: Int,
        tintHex: String,
        brokenHex: String,
        scale: CGFloat,
        glowRadius: CGFloat,
        isBoss: Bool,
        introVerdict: String
    ) {
        self.id = id
        self.title = title
        self.shape = shape
        self.symbol = symbol
        self.impactSymbols = impactSymbols
        self.healthBonus = healthBonus
        self.counterDelay = counterDelay
        self.damageBonus = damageBonus
        self.styleBonus = styleBonus
        self.tintHex = tintHex
        self.brokenHex = brokenHex
        self.scale = scale
        self.glowRadius = glowRadius
        self.isBoss = isBoss
        self.introVerdict = introVerdict
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        shape =
            try container.decodeIfPresent(String.self, forKey: .shape)
            ?? "diamond"
        symbol =
            try container.decodeIfPresent(String.self, forKey: .symbol)
            ?? "sparkle"
        impactSymbols =
            try container.decodeIfPresent([String].self, forKey: .impactSymbols)
            ?? container.decodeIfPresent([String].self, forKey: .hitFrames)
            ?? []
        healthBonus =
            try container.decodeIfPresent(Int.self, forKey: .healthBonus) ?? 0
        counterDelay =
            try container.decodeIfPresent(Int.self, forKey: .counterDelay) ?? 4
        damageBonus =
            try container.decodeIfPresent(Int.self, forKey: .damageBonus) ?? 0
        styleBonus =
            try container.decodeIfPresent(Int.self, forKey: .styleBonus) ?? 0
        tintHex =
            try container.decodeIfPresent(String.self, forKey: .tintHex)
            ?? "#FF1744"
        brokenHex =
            try container.decodeIfPresent(String.self, forKey: .brokenHex)
            ?? tintHex
        scale =
            try container.decodeIfPresent(CGFloat.self, forKey: .scale) ?? 1
        glowRadius =
            try container.decodeIfPresent(CGFloat.self, forKey: .glowRadius)
            ?? 12
        isBoss =
            try container.decodeIfPresent(Bool.self, forKey: .isBoss) ?? false
        introVerdict =
            try container.decodeIfPresent(String.self, forKey: .introVerdict)
            ?? "PROVE IT"
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encode(shape, forKey: .shape)
        try container.encode(symbol, forKey: .symbol)
        try container.encode(impactSymbols, forKey: .impactSymbols)
        try container.encode(healthBonus, forKey: .healthBonus)
        try container.encode(counterDelay, forKey: .counterDelay)
        try container.encode(damageBonus, forKey: .damageBonus)
        try container.encode(styleBonus, forKey: .styleBonus)
        try container.encode(tintHex, forKey: .tintHex)
        try container.encode(brokenHex, forKey: .brokenHex)
        try container.encode(scale, forKey: .scale)
        try container.encode(glowRadius, forKey: .glowRadius)
        try container.encode(isBoss, forKey: .isBoss)
        try container.encode(introVerdict, forKey: .introVerdict)
    }
}

struct EnemyCatalog {
    static let shared = EnemyCatalog()

    private let definitions: [String: EnemyDefinition]

    private init() {
        definitions = Self.loadDefinitions()
    }

    func definition(for enemy: EnemyType) -> EnemyDefinition {
        if let remoteDefinition = RemoteContentStore.shared.enemyDefinitions[
            enemy.rawValue
        ] {
            return remoteDefinition
        }

        return definitions[enemy.rawValue] ?? Self.fallbackDefinitions[
            enemy.rawValue
        ] ?? Self.defaultDefinition
    }

    private static func loadDefinitions() -> [String: EnemyDefinition] {
        guard
            let url = Bundle.main.url(
                forResource: "EnemyDefinitions",
                withExtension: "json"
            ),
            let data = try? Data(contentsOf: url),
            let decoded = try? JSONDecoder().decode(
                [EnemyDefinition].self,
                from: data
            )
        else {
            return fallbackDefinitions
        }

        return Dictionary(uniqueKeysWithValues: decoded.map { ($0.id, $0) })
    }

    private static let defaultDefinition = EnemyDefinition(
        id: "grunt",
        title: "GRUNT",
        shape: "circle",
        symbol: "slash.circle.fill",
        impactSymbols: ["slash.circle", "sparkle", "burst.fill"],
        healthBonus: 0,
        counterDelay: 4,
        damageBonus: 0,
        styleBonus: 0,
        tintHex: "#FF4F8B",
        brokenHex: "#FF2A2A",
        scale: 1,
        glowRadius: 10,
        isBoss: false,
        introVerdict: "PROVE IT"
    )

    private static let fallbackDefinitions: [String: EnemyDefinition] = [
        "grunt": defaultDefinition,
        "duelist": EnemyDefinition(
            id: "duelist",
            title: "DUELIST",
            shape: "diamond",
            symbol: "bolt.fill",
            impactSymbols: ["bolt", "bolt.fill", "sparkles"],
            healthBonus: 12,
            counterDelay: 2,
            damageBonus: 3,
            styleBonus: 8,
            tintHex: "#20D9FF",
            brokenHex: "#20D9FF",
            scale: 0.96,
            glowRadius: 16,
            isBoss: false,
            introVerdict: "KEEP UP"
        ),
        "brute": EnemyDefinition(
            id: "brute",
            title: "BRUTE",
            shape: "hexagon",
            symbol: "flame.fill",
            impactSymbols: ["flame", "flame.fill", "burst.fill"],
            healthBonus: 45,
            counterDelay: 4,
            damageBonus: 8,
            styleBonus: 4,
            tintHex: "#9B5CFF",
            brokenHex: "#9B5CFF",
            scale: 1.16,
            glowRadius: 18,
            isBoss: false,
            introVerdict: "HIT HARDER"
        ),
        "judge": EnemyDefinition(
            id: "judge",
            title: "JUDGE",
            shape: "ring",
            symbol: "eye.fill",
            impactSymbols: ["eye", "eye.fill", "crown.fill"],
            healthBonus: 80,
            counterDelay: 3,
            damageBonus: 10,
            styleBonus: 12,
            tintHex: "#FFFFFF",
            brokenHex: "#FF9F1A",
            scale: 1.22,
            glowRadius: 30,
            isBoss: true,
            introVerdict: "BE BEAUTIFUL"
        ),
    ]
}

enum EnemyType: String, CaseIterable, Equatable, Codable {
    case grunt
    case brute
    case duelist
    case judge

    private var definition: EnemyDefinition {
        EnemyCatalog.shared.definition(for: self)
    }

    var title: String { definition.title }
    var idleAsset: String { definition.idleState }
    var hitFrames: [String] { definition.hitStates }
    var shape: String { definition.shape }
    var symbol: String { definition.symbol }
    var healthBonus: Int { definition.healthBonus }
    var counterDelay: Int { definition.counterDelay }
    var damageBonus: Int { definition.damageBonus }
    var styleBonus: Int { definition.styleBonus }
    var tint: Color { definition.tint }
    var brokenColor: Color { definition.brokenColor }
    var scale: CGFloat { definition.scale }
    var glowRadius: CGFloat { definition.glowRadius }
    var isBoss: Bool { definition.isBoss }
    var introVerdict: String { definition.introVerdict }

    static func forFight(_ fightLevel: Int) -> EnemyType {
        if fightLevel
            % RemoteContentStore.shared.gameConfig.run.bossEveryXFights == 0
        {
            return .judge
        }

        let rotation: [EnemyType] = [.grunt, .duelist, .brute]
        return rotation[(fightLevel - 1) % rotation.count]
    }
}

struct LevelDefinition: Codable, Equatable {
    let id: String
    let title: String
    let backgroundAsset: String?
    let requiredFight: Int
    let moodText: String
    let styleMultiplier: Double
    let enemyDamageMultiplier: Double
    let accentHex: String
    let paintPalette: [PaintColor]

    var accentColor: Color {
        Color(hex: accentHex)
    }

    var paintColors: [Color] {
        paintPalette.map(\.color)
    }

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case backgroundAsset
        case requiredFight
        case moodText
        case styleMultiplier
        case enemyDamageMultiplier
        case accentHex
        case paintPalette
    }

    init(
        id: String,
        title: String,
        backgroundAsset: String? = nil,
        requiredFight: Int,
        moodText: String,
        styleMultiplier: Double,
        enemyDamageMultiplier: Double,
        accentHex: String,
        paintPalette: [PaintColor]
    ) {
        self.id = id
        self.title = title
        self.backgroundAsset = backgroundAsset
        self.requiredFight = requiredFight
        self.moodText = moodText
        self.styleMultiplier = styleMultiplier
        self.enemyDamageMultiplier = enemyDamageMultiplier
        self.accentHex = accentHex
        self.paintPalette = paintPalette
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        backgroundAsset = try container.decodeIfPresent(
            String.self,
            forKey: .backgroundAsset
        )
        requiredFight = try container.decode(Int.self, forKey: .requiredFight)
        moodText = try container.decode(String.self, forKey: .moodText)
        styleMultiplier = try container.decode(
            Double.self,
            forKey: .styleMultiplier
        )
        enemyDamageMultiplier = try container.decode(
            Double.self,
            forKey: .enemyDamageMultiplier
        )
        accentHex = try container.decode(String.self, forKey: .accentHex)
        paintPalette =
            try container.decodeIfPresent(
                [PaintColor].self,
                forKey: .paintPalette
            ) ?? [PaintColor(accentHex), PaintColor("#FFFFFF")]
    }
}

struct LevelCatalog {
    static let shared = LevelCatalog()

    private let levels: [LevelDefinition]

    private init() {
        levels = Self.loadLevels()
    }

    func level(for fightLevel: Int) -> LevelDefinition {
        let activeLevels =
            RemoteContentStore.shared.levelDefinitions.isEmpty
            ? levels : RemoteContentStore.shared.levelDefinitions
        return
            activeLevels
            .filter { $0.requiredFight <= fightLevel }
            .max { $0.requiredFight < $1.requiredFight }
            ?? Self.defaultLevel
    }

    private static func loadLevels() -> [LevelDefinition] {
        guard
            let url = Bundle.main.url(
                forResource: "LevelDefinitions",
                withExtension: "json"
            ),
            let data = try? Data(contentsOf: url),
            let decoded = try? JSONDecoder().decode(
                [LevelDefinition].self,
                from: data
            ),
            !decoded.isEmpty
        else {
            return fallbackLevels
        }

        return decoded.sorted { $0.requiredFight < $1.requiredFight }
    }

    private static let defaultLevel = LevelDefinition(
        id: "vhs_alley",
        title: "VHS ALLEY",
        requiredFight: 1,
        moodText: "PROVE IT",
        styleMultiplier: 1,
        enemyDamageMultiplier: 1,
        accentHex: "#FF2A2A",
        paintPalette: [
            PaintColor("#FF2A2A"), PaintColor("#FFFFFF"), PaintColor("#FF4F8B"),
        ]
    )

    private static let fallbackLevels: [LevelDefinition] = [
        defaultLevel,
        LevelDefinition(
            id: "blood_rooftop",
            title: "BLOOD ROOFTOP",
            requiredFight: 2,
            moodText: "NO SKY, ONLY STYLE",
            styleMultiplier: 1.08,
            enemyDamageMultiplier: 1.05,
            accentHex: "#FF4F8B",
            paintPalette: [
                PaintColor("#FF1744"), PaintColor("#FF8A80"),
                PaintColor("#FFFFFF"),
            ]
        ),
        LevelDefinition(
            id: "static_subway",
            title: "STATIC SUBWAY",
            requiredFight: 3,
            moodText: "MOVE FAST",
            styleMultiplier: 1.12,
            enemyDamageMultiplier: 1.08,
            accentHex: "#20D9FF",
            paintPalette: [
                PaintColor("#20D9FF"), PaintColor("#FFFFFF"),
                PaintColor("#FF2A2A"),
            ]
        ),
        LevelDefinition(
            id: "neon_church",
            title: "NEON CHURCH",
            requiredFight: 4,
            moodText: "CONFESS WITH VIOLENCE",
            styleMultiplier: 1.16,
            enemyDamageMultiplier: 1.12,
            accentHex: "#9B5CFF",
            paintPalette: [
                PaintColor("#9B5CFF"), PaintColor("#FF2A2A"),
                PaintColor("#FFFFFF"),
            ]
        ),
        LevelDefinition(
            id: "judge_arena",
            title: "JUDGE ARENA",
            requiredFight: 5,
            moodText: "BE BEAUTIFUL",
            styleMultiplier: 1.25,
            enemyDamageMultiplier: 1.2,
            accentHex: "#FF9F1A",
            paintPalette: [
                PaintColor("#FF9F1A"), PaintColor("#FFFFFF"),
                PaintColor("#FF2A2A"),
            ]
        ),
    ]
}

struct PlayerCharacter: Codable, Equatable, Identifiable {
    let id: String
    let title: String
    let idleAsset: String
    let attackFrames: [String]
    let maxHP: Int
    let styleGainBonus: Int
    let damageBonus: Int
    let bloodCostModifier: Int
    let phantomDodgeBonus: Int
    let tintHex: String

    var tint: Color {
        Color(hex: tintHex)
    }
}

struct CharacterCatalog {
    static let shared = CharacterCatalog()

    private let localCharacters: [PlayerCharacter]

    private init() {
        localCharacters = Self.loadCharacters()
    }

    var characters: [PlayerCharacter] {
        let remoteCharacters = RemoteContentStore.shared.characterDefinitions

        guard !remoteCharacters.isEmpty else {
            return localCharacters
        }

        guard
            remoteCharacters.contains(where: { $0.id == "vance" }) == false,
            let localVance = localCharacters.first(where: { $0.id == "vance" })
        else {
            return remoteCharacters
        }

        return [localVance] + remoteCharacters
    }

    var defaultCharacter: PlayerCharacter {
        characters.first { $0.id == "vance" }
            ?? characters.first
            ?? Self.fallbackCharacters[0]
    }

    func character(id: String) -> PlayerCharacter {
        characters.first { $0.id == id } ?? defaultCharacter
    }

    private static func loadCharacters() -> [PlayerCharacter] {
        guard
            let url = Bundle.main.url(
                forResource: "CharacterDefinitions",
                withExtension: "json"
            ),
            let data = try? Data(contentsOf: url),
            let decoded = try? JSONDecoder().decode(
                [PlayerCharacter].self,
                from: data
            ),
            !decoded.isEmpty
        else {
            return fallbackCharacters
        }

        return decoded
    }

    private static let fallbackCharacters: [PlayerCharacter] = [
        PlayerCharacter(
            id: "vance",
            title: "VANCE",
            idleAsset: "character_vance_idle",
            attackFrames: [
                "character_vhs_attack1",
                "character_vhs_attack2",
                "character_vhs_attack3",
                "character_vhs_attack4",
                "character_vhs_attack5",
                "character_vhs_attack6",
                "character_vhs_attack7",
                "character_vhs_attack8",
                "character_vhs_attack9",
            ],
            maxHP: 105,
            styleGainBonus: 3,
            damageBonus: 2,
            bloodCostModifier: 0,
            phantomDodgeBonus: 4,
            tintHex: "#8F5CFF"
        ),
        PlayerCharacter(
            id: "vhs_blade",
            title: "VHS BLADE",
            idleAsset: "idle",
            attackFrames: ["attack1", "attack2", "attack3"],
            maxHP: 100,
            styleGainBonus: 0,
            damageBonus: 0,
            bloodCostModifier: 0,
            phantomDodgeBonus: 0,
            tintHex: "#20D9FF"
        ),
        PlayerCharacter(
            id: "blood_saint",
            title: "BLOOD SAINT",
            idleAsset: "character_blood_saint_idle",
            attackFrames: [
                "character_blood_saint_attack1",
                "character_blood_saint_attack2",
                "character_blood_saint_attack3",
            ],
            maxHP: 90,
            styleGainBonus: 4,
            damageBonus: 4,
            bloodCostModifier: -2,
            phantomDodgeBonus: 0,
            tintHex: "#FF2A2A"
        ),
        PlayerCharacter(
            id: "phantom_kid",
            title: "PHANTOM KID",
            idleAsset: "character_phantom_kid_idle",
            attackFrames: [
                "character_phantom_kid_attack1",
                "character_phantom_kid_attack2",
                "character_phantom_kid_attack3",
            ],
            maxHP: 85,
            styleGainBonus: 2,
            damageBonus: -2,
            bloodCostModifier: 0,
            phantomDodgeBonus: 10,
            tintHex: "#7CFFCE"
        ),
        PlayerCharacter(
            id: "reaper_zero",
            title: "REAPER ZERO",
            idleAsset: "character_reaper_zero_idle",
            attackFrames: [
                "character_reaper_zero_attack1",
                "character_reaper_zero_attack2",
                "character_reaper_zero_attack3",
            ],
            maxHP: 110,
            styleGainBonus: -2,
            damageBonus: 8,
            bloodCostModifier: 1,
            phantomDodgeBonus: 0,
            tintHex: "#9B5CFF"
        ),
    ]
}

extension Color {
    init(hex: String) {
        let cleaned = hex.trimmingCharacters(
            in: CharacterSet.alphanumerics.inverted
        )
        var value: UInt64 = 0
        Scanner(string: cleaned).scanHexInt64(&value)

        let red: Double
        let green: Double
        let blue: Double

        switch cleaned.count {
        case 6:
            red = Double((value >> 16) & 0xFF) / 255
            green = Double((value >> 8) & 0xFF) / 255
            blue = Double(value & 0xFF) / 255
        default:
            red = 1
            green = 0
            blue = 0
        }

        self.init(red: red, green: green, blue: blue)
    }
}
