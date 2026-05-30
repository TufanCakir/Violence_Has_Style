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
    case leaderboard
    case settings
}

enum RunMode: String {
    case story
    case event
    case endless
    case style
}

enum StyleRank: Equatable {
    case pathetic
    case savage
    case brutal
    case styleGod

    init(style: Int) {
        switch style {
        case 90...:
            self = .styleGod
        case 65...:
            self = .brutal
        case 35...:
            self = .savage
        default:
            self = .pathetic
        }
    }

    init(score: Int) {
        switch score {
        case 3...:
            self = .styleGod
        case 2:
            self = .brutal
        case 1:
            self = .savage
        default:
            self = .pathetic
        }
    }

    var title: String {
        switch self {
        case .pathetic:
            return "D"
        case .savage:
            return "SAVAGE"
        case .brutal:
            return "BRUTAL"
        case .styleGod:
            return "STYLE GOD"
        }
    }

    var verdict: String {
        switch self {
        case .pathetic:
            return "PATHETIC"
        case .savage:
            return "IMPRESSIVE"
        case .brutal:
            return "BEAUTIFUL"
        case .styleGod:
            return "STYLE GOD"
        }
    }

    var color: Color {
        switch self {
        case .pathetic:
            return .gray
        case .savage:
            return .red
        case .brutal:
            return .orange
        case .styleGod:
            return .cyan
        }
    }

    var playerTint: Color {
        switch self {
        case .pathetic:
            return .cyan
        case .savage:
            return .red
        case .brutal:
            return .orange
        case .styleGod:
            return .white
        }
    }

    var damage: Int {
        switch self {
        case .pathetic:
            return 10
        case .savage:
            return 14
        case .brutal:
            return 18
        case .styleGod:
            return 26
        }
    }

    var canFinish: Bool {
        self == .brutal || self == .styleGod
    }

    var score: Int {
        switch self {
        case .pathetic:
            return 0
        case .savage:
            return 1
        case .brutal:
            return 2
        case .styleGod:
            return 3
        }
    }
}

enum CombatStyle: CaseIterable, Equatable {
    case killer
    case reaper
    case phantom
    case blood
    case void
    case chaos

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
            return "A darker Phantom variant. Lower damage, more control and clean movement."
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
    let currencyIconAsset: String
    let themeColorHex: String
    let currencyPerFinisher: Int
    let styleGodBonus: Int
    let shopItems: [EventShopItem]

    var themeColor: Color {
        Color(hex: themeColorHex)
    }

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

    func currencyReward(for rank: StyleRank) -> Int {
        currencyPerFinisher + (rank == .styleGod ? styleGodBonus : 0)
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
}

struct MusicCatalog {
    static let shared = MusicCatalog()

    private init() {}

    var tracks: [MusicTrack] {
        RemoteContentStore.shared.musicTracks
    }

    func playlist(for mode: RunMode? = nil) -> [MusicTrack] {
        let activeTracks = tracks
        guard let mode else { return activeTracks }

        let filtered = activeTracks.filter { $0.mode == nil || $0.mode == mode.rawValue }
        return filtered.isEmpty ? activeTracks : filtered
    }
}

struct GameConfig: Codable, Equatable {
    let combat: CombatConfig
    let run: RunConfig

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
        )
    )
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
    let idleAsset: String
    let hitFrames: [String]
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
        idleAsset: "enemy_grunt_idle",
        hitFrames: [
            "enemy_grunt_hit1", "enemy_grunt_hit2", "enemy_grunt_hit3",
        ],
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
            idleAsset: "enemy_duelist_idle",
            hitFrames: [
                "enemy_duelist_hit1", "enemy_duelist_hit2",
                "enemy_duelist_hit3",
            ],
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
            idleAsset: "enemy_brute_idle",
            hitFrames: [
                "enemy_brute_hit1", "enemy_brute_hit2", "enemy_brute_hit3",
            ],
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
            idleAsset: "enemy_judge_idle",
            hitFrames: [
                "enemy_judge_hit1", "enemy_judge_hit2", "enemy_judge_hit3",
            ],
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
    var idleAsset: String { definition.idleAsset }
    var hitFrames: [String] { definition.hitFrames }
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
        RemoteContentStore.shared.characterDefinitions.isEmpty
            ? localCharacters : RemoteContentStore.shared.characterDefinitions
    }

    var defaultCharacter: PlayerCharacter {
        characters.first ?? Self.fallbackCharacters[0]
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
    fileprivate init(hex: String) {
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
