//
//  GameState.swift
//  Violence Has Style
//
//  Created by Tufan Cakir on 30.05.26.
//

import Foundation
import Observation
import SwiftUI

enum EnemyIntent: String, Codable, Equatable, CaseIterable {

    case open
    case block
    case counter
    case rage

    var title: String {
        switch self {
        case .open:
            return "OPEN"
        case .block:
            return "BLOCK"
        case .counter:
            return "COUNTER"
        case .rage:
            return "RAGE"
        }
    }

    var symbol: String {
        switch self {
        case .open:
            return "scope"
        case .block:
            return "shield.fill"
        case .counter:
            return "arrow.triangle.2.circlepath"
        case .rage:
            return "flame.fill"
        }
    }

    var color: Color {
        switch self {
        case .open:
            return .green
        case .block:
            return .cyan
        case .counter:
            return .purple
        case .rage:
            return .red
        }
    }

    var hint: String {
        switch self {
        case .open:
            return "TAP"
        case .block:
            return "SWITCH REAPER"
        case .counter:
            return "SWITCH PHANTOM"
        case .rage:
            return "BLOOD TAP"
        }
    }
}

private enum BattleInputKind {
    case attack
    case styleSwitch
}

@Observable
final class GameState {
    var maxStyle: Int {
        RemoteContentStore.shared.gameConfig.combat.maxStyle
    }

    var currentCharacter: PlayerCharacter = CharacterCatalog.shared
        .defaultCharacter
    var playerFrame = CharacterCatalog.shared.defaultCharacter.idleAsset
    var enemyFrame = EnemyType.grunt.idleAsset
    var enemyHealth = RemoteContentStore.shared.gameConfig.combat
        .baseEnemyHealth
    var enemyMaxHealth = RemoteContentStore.shared.gameConfig.combat
        .baseEnemyHealth
    var playerHealth = 100
    var style = 0
    var styleStartBonus = 0
    var killerStyleBonus = 0
    var reaperDamageBonus = 0
    var phantomStyleBonus = 0
    var bloodCostReduction = 0
    var fightLevel = 1
    var fightsCleared = 0
    var bestStyleRank: StyleRank = .pathetic
    var maxCombo = 0
    var chosenRewards: [RunReward] = []
    var combo = 0
    var enemyActionCountdown = RemoteContentStore.shared.gameConfig.combat
        .enemyCounterStart
    var attackFrameIndex = 0
    var flashHit = false
    var lastAttackFrame = ""
    var bossVerdict = "PATHETIC"
    var activeStyle: CombatStyle = .killer
    var activeAwakening: StyleAwakeningDefinition? =
        StyleAwakeningCatalog.awakening(for: .killer)
    var selectedPaintFxId = ""
    var currentEnemy: EnemyType = .grunt
    var enemyIntent: EnemyIntent = .open
    var intentTurnsRemaining = 2
    var perfectChain = 0
    var styleRushTurns = 0
    var styleFreezeMeter = 0
    var styleFreezeTurns = 0
    var lastTimingVerdict = "READY"
    var currentLevel: LevelDefinition = LevelCatalog.shared.level(for: 1)
    var runMode: RunMode = .style
    var storyChapterId: String?
    var eventId: String?
    var isEnemyBroken = false
    var isChoosingReward = false
    var isGameOver = false
    var rewardChoices: [RunReward] = []
    var paintStrokes: [PaintStroke] = []

    var styleRank: StyleRank {
        StyleRank(style: style)
    }

    var isStyleRushActive: Bool {
        styleRushTurns > 0
    }

    var isStyleFreezeActive: Bool {
        styleFreezeTurns > 0
    }

    var canActivateStyleFreeze: Bool {
        styleFreezeMeter >= 100 && !isStyleFreezeActive && !isEnemyBroken
    }

    var playerIdleFrame: String {
        currentCharacter.idleAsset
    }

    var playerAttackFrames: [String] {
        currentCharacter.attackFrames.isEmpty
            ? ["attack1", "attack2", "attack3"] : currentCharacter.attackFrames
    }

    var playerOffset: CGFloat {
        if activeStyle == .phantom && attackFrameIndex != 0 {
            return 58
        }

        return attackFrameIndex == 0 ? 0 : 22
    }

    var rewardHistoryText: String {
        guard !chosenRewards.isEmpty else { return "NONE" }

        return chosenRewards.map(\.title).joined(separator: " / ")
    }

    func startAttack() -> [GameEvent] {
        if isEnemyBroken {
            return attemptFinisher()
        }

        var events: [GameEvent] = []
        let nextFrame = playerAttackFrames[attackFrameIndex]
        events.append(.sound("slash_\(attackFrameIndex + 1)"))

        playerFrame = nextFrame
        enemyFrame =
            currentEnemy.hitFrames[
                min(attackFrameIndex, currentEnemy.hitFrames.count - 1)
            ]
        flashHit.toggle()
        combo += 1
        maxCombo = max(maxCombo, combo)
        addStyle(for: nextFrame)
        addPaintStroke(for: attackFrameIndex)
        applyStyleCost()
        bossVerdict = attackTitle(for: attackFrameIndex)
        events.append(contentsOf: resolveBattleInput(.attack))

        if attackFrameIndex == playerAttackFrames.count - 1 {
            enemyHealth = max(
                0,
                enemyHealth - activeStyle.damage(for: styleRank)
                    - styleDamageBonus - currentCharacter.damageBonus
                    - styleRushDamageBonus
            )
            events.append(.sound("hit"))
            events.append(.screenShake(activeStyle.impactShake))
        }

        if enemyHealth == 0 {
            isEnemyBroken = true
            bossVerdict = "BROKEN"
            enemyFrame = currentEnemy.idleAsset
            events.append(.sound("broken"))
            events.append(.screenShake(11))
        }

        attackFrameIndex = (attackFrameIndex + 1) % playerAttackFrames.count
        events.append(contentsOf: tickEnemyAction())
        events.append(.awardStylePassPoints(3 + styleRank.score * 2))
        return events
    }

    func handleSwipe(width: CGFloat) -> [GameEvent] {
        guard abs(width) > 28 else { return [] }

        activeStyle = width > 0 ? activeStyle.previous : activeStyle.next
        activeAwakening = StyleAwakeningCatalog.awakening(for: activeStyle)
        bossVerdict = activeAwakening?.verdict ?? activeStyle.verdict
        if let awakeningAsset = activeAwakening?.awakeningAsset,
            !awakeningAsset.isEmpty
        {
            playerFrame = awakeningAsset
        }
        style = min(
            maxStyle,
            style + (activeAwakening?.styleGain ?? activeStyle.styleGain)
        )
        updateBestStyleRank()
        addStyleShiftStroke()

        let shake =
            activeAwakening.map { CGFloat($0.shake) }
            ?? activeStyle.impactShake
        var events: [GameEvent] = [.screenShake(shake)]
        events.append(contentsOf: resolveBattleInput(.styleSwitch))
        events.append(contentsOf: tickEnemyAction())
        return events
    }

    func chooseReward(_ reward: RunReward) -> [GameEvent] {
        chosenRewards.append(reward)

        styleStartBonus += reward.styleStartBonus
        killerStyleBonus += reward.killerStyleBonus
        reaperDamageBonus += reward.reaperDamageBonus
        phantomStyleBonus += reward.phantomStyleBonus
        bloodCostReduction = min(
            RemoteContentStore.shared.gameConfig.run.maxBloodCostReduction,
            bloodCostReduction + reward.bloodCostReduction
        )

        fightLevel += 1
        currentEnemy = EnemyType.forFight(fightLevel)
        currentLevel = LevelCatalog.shared.level(for: fightLevel)
        enemyMaxHealth = nextEnemyHealth
        enemyHealth = enemyMaxHealth
        enemyFrame = currentEnemy.idleAsset
        enemyActionCountdown = counterDelay
        enemyIntent = startingIntent
        intentTurnsRemaining = 2
        perfectChain = 0
        styleRushTurns = 0
        lastTimingVerdict = "READY"
        styleFreezeMeter = 0
        styleFreezeTurns = 0
        style = min(maxStyle, styleStartBonus)
        updateBestStyleRank()
        bossVerdict = "\(currentLevel.title): \(currentLevel.moodText)"
        isChoosingReward = false

        return [.sound("reward"), .unlockReward(reward.title)]
    }

    func restartRun() {
        playerFrame = playerIdleFrame
        currentEnemy = .grunt
        enemyFrame = currentEnemy.idleAsset
        enemyHealth =
            RemoteContentStore.shared.gameConfig.combat.baseEnemyHealth
        enemyMaxHealth =
            RemoteContentStore.shared.gameConfig.combat.baseEnemyHealth
        playerHealth = currentCharacter.maxHP
        style = 0
        styleStartBonus = 0
        killerStyleBonus = 0
        reaperDamageBonus = 0
        phantomStyleBonus = 0
        bloodCostReduction = 0
        fightLevel = 1
        fightsCleared = 0
        bestStyleRank = .pathetic
        maxCombo = 0
        combo = 0
        enemyActionCountdown =
            RemoteContentStore.shared.gameConfig.combat.enemyCounterStart
        enemyIntent = .open
        intentTurnsRemaining = 2
        perfectChain = 0
        styleRushTurns = 0
        lastTimingVerdict = "READY"
        styleFreezeMeter = 0
        styleFreezeTurns = 0
        attackFrameIndex = 0
        flashHit = false
        lastAttackFrame = ""
        bossVerdict = "PATHETIC"
        activeStyle = .killer
        activeAwakening = StyleAwakeningCatalog.awakening(for: activeStyle)
        currentEnemy = .grunt
        currentLevel = LevelCatalog.shared.level(for: 1)
        isEnemyBroken = false
        isChoosingReward = false
        isGameOver = false
        rewardChoices.removeAll()
        chosenRewards.removeAll()
        paintStrokes.removeAll()
    }

    func startRun(
        mode: RunMode,
        storyChapter: StoryChapter? = nil,
        event: EventDefinition? = nil
    ) {
        runMode = mode
        storyChapterId = storyChapter?.id
        eventId = event?.id
        restartRun()
        eventId = event?.id

        if let storyChapter {
            fightLevel = max(1, storyChapter.startFight)
            currentLevel = LevelCatalog.shared.level(for: fightLevel)
            currentEnemy = EnemyType.forFight(fightLevel)
            enemyMaxHealth = nextEnemyHealth
            enemyHealth = enemyMaxHealth
            enemyFrame = currentEnemy.idleAsset
            enemyIntent = startingIntent
            bossVerdict = storyChapter.introText
        }
    }

    func refreshDataDefinitions() {
        currentCharacter = CharacterCatalog.shared.character(
            id: currentCharacter.id
        )
        currentEnemy = EnemyType.forFight(fightLevel)
        currentLevel = LevelCatalog.shared.level(for: fightLevel)
        playerFrame = playerIdleFrame
        enemyFrame = currentEnemy.idleAsset
        playerHealth = min(playerHealth, currentCharacter.maxHP)
        enemyMaxHealth = max(enemyHealth, nextEnemyHealth)
    }

    private func attemptFinisher() -> [GameEvent] {
        guard styleRank.canFinish else {
            bossVerdict = "NOT ENOUGH STYLE"
            style = max(
                0,
                style
                    - RemoteContentStore.shared.gameConfig.combat
                    .lowStyleFinisherPenalty
            )
            return []
        }

        bossVerdict = styleRank.verdict
        fightsCleared += 1
        combo = 0
        style = max(
            0,
            style
                - RemoteContentStore.shared.gameConfig.combat.finisherStyleCost
        )
        playerHealth = min(
            currentCharacter.maxHP,
            playerHealth
                + RemoteContentStore.shared.gameConfig.combat.finisherHeal
        )
        playerFrame = playerIdleFrame
        enemyFrame = currentEnemy.idleAsset
        attackFrameIndex = 0
        isEnemyBroken = false
        paintStrokes.removeAll()
        rewardChoices = RunReward.nextChoices(for: fightLevel)
        isChoosingReward = true

        var events: [GameEvent] = [
            .persistRunProgress(bossVerdict),
            .sound("finisher"),
            .finisherImpact,
        ]

        if runMode == .event,
            let activeEvent = EventCatalog.shared.event(id: eventId)
                ?? EventCatalog.shared.activeEvent
        {
            events.append(
                .awardEventCurrency(
                    activeEvent.currencyReward(for: styleRank),
                    activeEvent.currencyId
                )
            )
        }

        return events
    }

    private func addStyle(for frame: String) {
        let baseGain =
            activeStyle.styleGain + styleGainBonus + attackFrameIndex * 4
        let variationBonus = frame == lastAttackFrame ? -5 : 7
        let comboBonus = min(combo / 3, 8)
        let rushBonus = isStyleRushActive ? 12 : 0
        let rawGain =
            baseGain + variationBonus + comboBonus + currentEnemy.styleBonus
            + rushBonus
        let scaledGain = Int(
            (Double(rawGain) * currentLevel.styleMultiplier).rounded()
        )
        style = min(maxStyle, max(0, style + scaledGain))
        styleFreezeMeter = min(100, styleFreezeMeter + max(2, scaledGain / 4))
        updateBestStyleRank()
        lastAttackFrame = frame
    }

    func activateStyleFreeze() -> [GameEvent] {
        guard canActivateStyleFreeze else { return [] }

        styleFreezeMeter = 0
        styleFreezeTurns = 3
        lastTimingVerdict = "STYLE FREEZE"
        bossVerdict = "STYLE FREEZE"
        addStyleGodCrossStroke(color: .white.opacity(0.9))
        return [.sound("freeze"), .screenShake(16)]
    }

    private func attackTitle(for index: Int) -> String {
        "\(activeStyle.verb) \(index + 1)"
    }

    private func applyStyleCost() {
        guard activeStyle == .blood else { return }

        playerHealth = max(
            1,
            playerHealth
                - max(
                    1,
                    RemoteContentStore.shared.gameConfig.combat.bloodBaseCost
                        - bloodCostReduction
                        + currentCharacter.bloodCostModifier
                )
        )
        style = min(
            maxStyle,
            style + RemoteContentStore.shared.gameConfig.combat.bloodStyleGain
        )
        updateBestStyleRank()
        checkGameOver()
    }

    private func addPaintStroke(for index: Int) {
        switch activeStyle {
        case .killer:
            addKillerPaint(for: index)
        case .reaper:
            addReaperPaint(for: index)
        case .phantom:
            addPhantomPaint(for: index)
        case .blood:
            addBloodPaint(for: index)
        case .void:
            addPhantomPaint(for: index)
            addStyleGodCrossStroke(
                color: activeSecondaryPaintColor.opacity(0.8)
            )
        case .chaos:
            addBloodPaint(for: index)
            addReaperPaint(for: index)
        }

        if styleRank == .styleGod {
            addStyleGodCrossStroke(color: activeSecondaryPaintColor)
        }

        trimPaintStrokes()
    }

    private func addKillerPaint(for index: Int) {

        for _ in 0..<activePaintBurstCount {

            let fromLeft = Bool.random()

            let startX: CGFloat = fromLeft ? -0.1 : 1.1
            let endX: CGFloat = fromLeft ? 1.1 : -0.1

            let startY = CGFloat.random(in: 0.1...0.9)
            let endY = CGFloat.random(in: 0.1...0.9)

            let stroke = basePaintStroke(
                index: index,
                startX: startX,
                startY: startY,
                controlX: 0.5,
                controlY: CGFloat.random(in: 0...1),
                control2X: 0.5,
                control2Y: CGFloat.random(in: 0...1),
                endX: endX,
                endY: endY,
                lineWidth: CGFloat(8 + styleRank.score * 4),
                opacity: 0.62 + Double(styleRank.score) * 0.08,
                color: activePaintColor
            )

            paintStrokes.append(stroke)
        }
    }

    private func addReaperPaint(for index: Int) {
        let spread = CGFloat(styleRank.score) * 0.12
        let stroke = basePaintStroke(
            index: index,
            startX: -0.05 - spread,
            startY: 0.78 - CGFloat(index) * 0.1,
            controlX: 0.24,
            controlY: 0.12,
            control2X: 0.78,
            control2Y: 0.18 + CGFloat(index) * 0.12,
            endX: 1.08 + spread,
            endY: 0.22 + CGFloat(index) * 0.16,
            lineWidth: CGFloat(
                30
                    + styleRank.score * 12
                    + fightLevel * 4
            ),
            opacity: 0.78 + Double(styleRank.score) * 0.05,
            color: activePaintColor
        )
        paintStrokes.append(stroke)
    }

    private func addPhantomPaint(for index: Int) {

        for _ in 0..<activePaintBurstCount {

            let vertical = Bool.random()

            let stroke: PaintStroke

            if vertical {

                let x = CGFloat.random(in: 0.15...0.85)

                stroke = basePaintStroke(
                    index: index,
                    startX: x,
                    startY: -0.1,
                    controlX: x - 0.05,
                    controlY: 0.3,
                    control2X: x + 0.05,
                    control2Y: 0.7,
                    endX: x,
                    endY: 1.1,
                    lineWidth: CGFloat(7 + styleRank.score * 3),
                    opacity: 0.5,
                    color: activePaintColor
                )

            } else {

                let y = CGFloat.random(in: 0.15...0.85)

                stroke = basePaintStroke(
                    index: index,
                    startX: -0.1,
                    startY: y,
                    controlX: 0.3,
                    controlY: y - 0.1,
                    control2X: 0.7,
                    control2Y: y + 0.1,
                    endX: 1.1,
                    endY: y,
                    lineWidth: CGFloat(7 + styleRank.score * 3),
                    opacity: 0.5,
                    color: activePaintColor
                )
            }

            paintStrokes.append(stroke)
        }
    }

    private func addBloodPaint(for index: Int) {
        let centerX: CGFloat = 0.64
        let centerY: CGFloat = 0.42
        for burst in 0..<activePaintBurstCount {
            let angle =
                CGFloat(burst) / CGFloat(activePaintBurstCount) * .pi * 2
            let radius = CGFloat(
                0.18
                    + Double(styleRank.score) * 0.08
                    + Double(fightLevel) * 0.03
            )
            let stroke = basePaintStroke(
                index: index,
                startX: centerX,
                startY: centerY,
                controlX: centerX + cos(angle) * radius * 0.55,
                controlY: centerY + sin(angle) * radius * 0.55,
                control2X: centerX + cos(angle) * radius,
                control2Y: centerY + sin(angle) * radius,
                endX: centerX + cos(angle) * radius * 1.45,
                endY: centerY + sin(angle) * radius * 1.45,
                lineWidth: CGFloat(12 + styleRank.score * 6),
                opacity: 0.66 + Double(styleRank.score) * 0.08,
                color: activePaintColor
            )
            paintStrokes.append(stroke)
        }
    }

    private func basePaintStroke(
        index: Int,
        startX: CGFloat,
        startY: CGFloat,
        controlX: CGFloat,
        controlY: CGFloat,
        control2X: CGFloat,
        control2Y: CGFloat,
        endX: CGFloat,
        endY: CGFloat,
        lineWidth: CGFloat,
        opacity: Double,
        color: Color
    ) -> PaintStroke {
        PaintStroke(
            startX: startX,
            startY: startY,
            controlX: controlX,
            controlY: controlY,
            control2X: control2X,
            control2Y: control2Y,
            endX: endX,
            endY: endY,
            lineWidth: lineWidth,
            opacity: min(0.98, opacity),
            color: paintColor(for: index, preferred: color)
        )
    }

    private func trimPaintStrokes() {
        while paintStrokes.count > maxPaintStrokes {
            paintStrokes.removeFirst()
        }
    }

    private func addStyleShiftStroke() {
        let stroke = PaintStroke(
            startX: 0.18,
            startY: 0.48,
            controlX: 0.5,
            controlY: 0.08,
            control2X: 0.58,
            control2Y: 0.18,
            endX: 0.82,
            endY: 0.5,
            lineWidth: 18 + CGFloat(activeAwakening?.burstCountBonus ?? 0) * 4,
            opacity: 0.68,
            color: activeSecondaryPaintColor
        )

        paintStrokes.append(stroke)
        if paintStrokes.count > maxPaintStrokes {
            paintStrokes.removeFirst()
        }
    }

    private var styleGainBonus: Int {
        switch activeStyle {
        case .killer:
            return killerStyleBonus
        case .phantom, .void:
            return phantomStyleBonus
        default:
            return currentCharacter.styleGainBonus
        }
    }

    private var styleDamageBonus: Int {
        activeStyle == .reaper || activeStyle == .chaos ? reaperDamageBonus : 0
    }

    private var styleRushDamageBonus: Int {
        isStyleRushActive ? 8 + perfectChain * 2 : 0
    }

    private var activePaintColor: Color {
        if let paintFxColor {
            return paintFxColor
        }

        return activeAwakening?.paintColor ?? activeStyle.paintColor
    }

    private var activeSecondaryPaintColor: Color {
        activeAwakening?.secondaryPaintColor ?? activeStyle.tint
    }

    private var activePaintBurstCount: Int {
        let paintFxBonus = selectedPaintFxId.isEmpty ? 0 : 1
        return max(
            1,
            activeStyle.paintBurstCount
                + (activeAwakening?.burstCountBonus ?? 0) + paintFxBonus
        )
    }

    private var paintFxColor: Color? {
        guard !selectedPaintFxId.isEmpty else { return nil }

        return PremiumStoreCatalog.shared.products.first {
            $0.unlockType == "paintFx" && $0.unlockValue == selectedPaintFxId
        }?.color
    }

    private var nextEnemyHealth: Int {
        RemoteContentStore.shared.gameConfig.combat.baseEnemyHealth + fightLevel
            * RemoteContentStore.shared.gameConfig.combat.enemyHealthPerFight
            + currentEnemy.healthBonus
    }

    private var counterDelay: Int {
        max(2, currentEnemy.counterDelay - min(fightLevel / 6, 1))
    }

    private var maxPaintStrokes: Int {
        60 + fightLevel * 10
    }

    private func paintColor(for index: Int, preferred: Color) -> Color {
        if styleRank == .styleGod && index == 2 {
            return .white
        }

        if index == 2 {
            return activeSecondaryPaintColor.opacity(0.82)
        }

        if index == 1 && styleRank.score >= 2 {
            return currentLevel.accentColor
        }

        return preferred
    }

    private func addStyleGodCrossStroke(color: Color) {
        let stroke = PaintStroke(
            startX: -0.12,
            startY: 0.18,
            controlX: 0.25,
            controlY: -0.08,
            control2X: 0.72,
            control2Y: 1.08,
            endX: 1.12,
            endY: 0.82,
            lineWidth: 34,
            opacity: 0.76,
            color: color
        )

        paintStrokes.append(stroke)
    }

    private func updateBestStyleRank() {
        let currentRank = StyleRank(style: style)
        if currentRank.score > bestStyleRank.score {
            bestStyleRank = currentRank
        }
    }

    private func tickEnemyAction() -> [GameEvent] {
        guard !isEnemyBroken, !isChoosingReward, !isGameOver else { return [] }

        enemyActionCountdown -= 1
        intentTurnsRemaining -= 1
        if styleFreezeTurns > 0 {
            styleFreezeTurns -= 1
            enemyActionCountdown += 1
            lastTimingVerdict = "TIME CUT"
            return []
        }
        if enemyActionCountdown <= 0 {
            let events = enemyCounterattack()
            enemyActionCountdown = counterDelay
            advanceEnemyIntent()
            return events
        }

        if intentTurnsRemaining <= 0 {
            advanceEnemyIntent()
        }

        return []
    }

    private func enemyCounterattack() -> [GameEvent] {
        let avoided =
            activeStyle == .phantom
            && style
                >= RemoteContentStore.shared.gameConfig.combat
                .phantomDodgeMinStyle
        if avoided {
            style = min(
                maxStyle,
                style
                    + RemoteContentStore.shared.gameConfig.combat
                    .phantomDodgeStyleGain + phantomStyleBonus
                    + currentCharacter.phantomDodgeBonus
            )
            updateBestStyleRank()
            bossVerdict = "CLEAN DODGE"
            lastTimingVerdict = "CLEAN DODGE"
            addStyleShiftStroke()
            return []
        }

        let baseDamage =
            10 + fightLevel * 2 + currentEnemy.damageBonus
            + (activeStyle == .blood ? 4 : 0)
        let damage = Int(
            (Double(baseDamage) * currentLevel.enemyDamageMultiplier).rounded()
        )
        playerHealth = max(0, playerHealth - damage)
        combo = 0
        style = max(
            0,
            style
                - RemoteContentStore.shared.gameConfig.combat.enemyStylePenalty
        )
        bossVerdict = "TOO SLOW"
        lastTimingVerdict = "TOO SLOW"
        perfectChain = 0
        flashHit.toggle()

        var events: [GameEvent] = [.sound("player_hit"), .playerHitImpact]
        if checkGameOver() {
            events.append(.persistRunProgress(bossVerdict))
            events.append(.playerHitImpact)
        }
        return events
    }

    @discardableResult
    private func checkGameOver() -> Bool {

        if playerHealth <= 0 {

            playerHealth = currentCharacter.maxHP

            bossVerdict = "STYLE NEVER DIES"

            return false
        }

        return false
    }

    private func resolveBattleInput(_ input: BattleInputKind) -> [GameEvent] {
        guard !isEnemyBroken, !isChoosingReward, !isGameOver else { return [] }

        var events: [GameEvent] = []

        if isPerfectInput(input) {
            perfectChain += 1
            let perfectBonus = 18 + min(perfectChain, 5) * 4
            combo += 1
            maxCombo = max(maxCombo, combo)
            style = min(maxStyle, style + perfectBonus)
            styleFreezeMeter = min(100, styleFreezeMeter + 18)
            updateBestStyleRank()
            lastTimingVerdict =
                perfectChain >= 3
                ? "STYLE RUSH" : "PERFECT \(enemyIntent.title)"
            bossVerdict = lastTimingVerdict
            addStyleGodCrossStroke(color: enemyIntent.color.opacity(0.88))
            events.append(.sound("perfect"))
            events.append(.screenShake(perfectChain >= 3 ? 14 : 7))

            if perfectChain >= 3 {
                styleRushTurns = 3
            }
        } else {
            applyIntentMistake(input)
        }

        if styleRushTurns > 0 {
            styleRushTurns -= 1
        }

        advanceEnemyIntent()
        return events
    }

    private func isPerfectInput(_ input: BattleInputKind) -> Bool {
        switch enemyIntent {
        case .open:
            return input == .attack
        case .block:
            return input == .styleSwitch
                && (activeStyle == .reaper || activeStyle == .chaos)
        case .counter:
            return input == .styleSwitch
                && (activeStyle == .phantom || activeStyle == .void)
        case .rage:
            return input == .attack
                && (activeStyle == .blood || activeStyle == .chaos)
        }
    }

    private func applyIntentMistake(_ input: BattleInputKind) {
        perfectChain = 0

        switch enemyIntent {
        case .open:
            lastTimingVerdict =
                input == .styleSwitch ? "MISSED OPENING" : "GOOD"
            bossVerdict = lastTimingVerdict
        case .block:
            lastTimingVerdict = "BLOCKED"
            bossVerdict = "BLOCKED"
            combo = 0
            style = max(0, style - 8)
        case .counter:
            lastTimingVerdict = "COUNTER PRIMED"
            bossVerdict = "COUNTER PRIMED"
            combo = 0
            enemyActionCountdown = min(enemyActionCountdown, 1)
        case .rage:
            lastTimingVerdict = "RAGE BUILDS"
            bossVerdict = "RAGE BUILDS"
            style = max(0, style - 4)
            enemyActionCountdown = min(enemyActionCountdown, 2)
        }
    }

    private func advanceEnemyIntent() {
        let rotation = enemyIntentRotation
        guard !rotation.isEmpty else { return }

        let seed =
            fightLevel + combo + attackFrameIndex + enemyActionCountdown
            + perfectChain
        enemyIntent = rotation[seed % rotation.count]
        intentTurnsRemaining = isStyleRushActive ? 1 : 2
    }

    private var startingIntent: EnemyIntent {
        currentEnemy == .duelist ? .counter : .open
    }

    private var enemyIntentRotation: [EnemyIntent] {
        switch currentEnemy {
        case .grunt:
            return [.open, .block, .open, .rage]
        case .duelist:
            return [.counter, .open, .counter, .block]
        case .brute:
            return [.block, .rage, .block, .open]
        case .judge:
            return [.counter, .block, .rage, .open]
        }
    }
}

enum GameEvent {
    case sound(String)
    case screenShake(CGFloat)
    case playerHitImpact
    case finisherImpact
    case persistRunProgress(String)
    case unlockReward(String)
    case awardEventCurrency(Int, String)
    case awardStylePassPoints(Int)
}
