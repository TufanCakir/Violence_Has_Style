//
//  GameStateRuleChecks.swift
//  Violence Has Style
//
//  Created by Tufan Cakir on 30.05.26.
//

#if DEBUG
    import Foundation

    enum GameStateRuleChecks {
        static func runAll() -> [String] {
            var failures: [String] = []

            checkBasicAttackRules(&failures)
            checkFinisherThresholdRules(&failures)
            checkRewardAndCounterRules(&failures)
            checkEnemyTypeRules(&failures)
            checkLevelRules(&failures)
            checkCharacterRules(&failures)

            return failures
        }

        private static func checkBasicAttackRules(_ failures: inout [String]) {
            let game = GameState()
            let firstEvents = game.startAttack()
            record(
                game.playerFrame == "attack1",
                "first tap should show attack1",
                &failures
            )
            record(
                firstEvents.containsSound("slash_1"),
                "first tap should request slash_1 sound",
                &failures
            )

            _ = game.startAttack()
            record(
                game.playerFrame == "attack2",
                "second tap should show attack2",
                &failures
            )

            let thirdEvents = game.startAttack()
            record(
                game.playerFrame == "attack3",
                "third tap should show attack3",
                &failures
            )
            record(
                game.enemyHealth < game.enemyMaxHealth,
                "third tap should damage enemy",
                &failures
            )
            record(
                thirdEvents.containsSound("hit"),
                "third tap should request hit sound",
                &failures
            )
        }

        private static func checkFinisherThresholdRules(
            _ failures: inout [String]
        ) {
            let lowStyleGame = GameState()
            lowStyleGame.isEnemyBroken = true
            lowStyleGame.style = 10
            let blockedEvents = lowStyleGame.startAttack()
            record(
                lowStyleGame.isEnemyBroken,
                "low style finisher should not clear broken state",
                &failures
            )
            record(
                blockedEvents.isEmpty,
                "low style finisher should not emit finisher events",
                &failures
            )
            record(
                lowStyleGame.bossVerdict == "NOT ENOUGH STYLE",
                "low style finisher should update verdict",
                &failures
            )

            let highStyleGame = GameState()
            highStyleGame.isEnemyBroken = true
            highStyleGame.style = 90
            let finisherEvents = highStyleGame.startAttack()
            record(
                !highStyleGame.isEnemyBroken,
                "high style finisher should clear broken state",
                &failures
            )
            record(
                highStyleGame.isChoosingReward,
                "high style finisher should open reward choice",
                &failures
            )
            record(
                highStyleGame.fightsCleared == 1,
                "high style finisher should increment fights cleared",
                &failures
            )
            record(
                finisherEvents.containsFinisherImpact,
                "high style finisher should emit finisher impact",
                &failures
            )
        }

        private static func checkRewardAndCounterRules(
            _ failures: inout [String]
        ) {
            let rewardGame = GameState()
            let redReaper = RewardCatalog.shared.rewards.first {
                $0.id == "red_reaper"
            }!
            let rewardEvents = rewardGame.chooseReward(redReaper)
            record(
                rewardGame.chosenRewards == [redReaper],
                "chosen reward should be tracked",
                &failures
            )
            record(
                rewardGame.fightLevel == 2,
                "reward should advance fight level",
                &failures
            )
            record(
                rewardGame.enemyMaxHealth > 100,
                "reward should scale next enemy health",
                &failures
            )
            record(
                rewardEvents.containsUnlockReward("RED REAPER"),
                "reward should emit unlock event",
                &failures
            )

            let hitGame = GameState()
            hitGame.enemyActionCountdown = 1
            hitGame.activeStyle = .killer
            let hitEvents = hitGame.handleSwipe(width: -40)
            record(
                hitGame.playerHealth < 100,
                "enemy counter should damage non-phantom player",
                &failures
            )
            record(
                hitEvents.containsPlayerHitImpact,
                "enemy counter should emit player hit impact",
                &failures
            )

            let dodgeGame = GameState()
            dodgeGame.enemyActionCountdown = 1
            dodgeGame.activeStyle = .reaper
            dodgeGame.style = 20
            let dodgeEvents = dodgeGame.handleSwipe(width: -40)
            record(
                dodgeGame.activeStyle == .phantom,
                "swipe should enter phantom style",
                &failures
            )
            record(
                dodgeGame.playerHealth == 100,
                "phantom with enough style should dodge counter",
                &failures
            )
            record(
                dodgeGame.bossVerdict == "CLEAN DODGE",
                "phantom dodge should update verdict",
                &failures
            )
            record(
                dodgeEvents.isEmpty,
                "phantom dodge should not emit hit events",
                &failures
            )
        }

        private static func checkEnemyTypeRules(_ failures: inout [String]) {
            record(
                EnemyType.forFight(1) == .grunt,
                "fight 1 should start with grunt",
                &failures
            )
            record(
                EnemyType.forFight(2) == .duelist,
                "fight 2 should rotate to duelist",
                &failures
            )
            record(
                EnemyType.forFight(3) == .brute,
                "fight 3 should rotate to brute",
                &failures
            )
            record(
                EnemyType.forFight(5) == .judge,
                "fight 5 should be judge",
                &failures
            )
            record(
                EnemyType.grunt.idleAsset == "enemy_grunt_idle",
                "grunt idle asset should come from enemy definition",
                &failures
            )
            record(
                EnemyType.judge.hitFrames.contains("enemy_judge_hit3"),
                "judge hit frames should come from enemy definition",
                &failures
            )

            let duelistGame = GameState()
            duelistGame.currentEnemy = .duelist
            duelistGame.enemyActionCountdown = 1
            duelistGame.activeStyle = .killer
            _ = duelistGame.handleSwipe(width: -40)
            record(
                duelistGame.enemyActionCountdown
                    == EnemyType.duelist.counterDelay,
                "duelist should reset to fast counter delay",
                &failures
            )

            let bruteGame = GameState()
            bruteGame.currentEnemy = .brute
            bruteGame.enemyActionCountdown = 1
            bruteGame.activeStyle = .killer
            _ = bruteGame.handleSwipe(width: -40)
            record(
                bruteGame.playerHealth <= 80,
                "brute counter should hit harder than base enemy",
                &failures
            )
        }

        private static func checkLevelRules(_ failures: inout [String]) {
            record(
                LevelCatalog.shared.level(for: 1).id == "vhs_alley",
                "fight 1 should use VHS alley level",
                &failures
            )
            record(
                LevelCatalog.shared.level(for: 2).id == "blood_rooftop",
                "fight 2 should use rooftop level definition",
                &failures
            )
            record(
                LevelCatalog.shared.level(for: 5).id == "judge_arena",
                "fight 5 should use judge arena definition",
                &failures
            )
            record(
                LevelCatalog.shared.level(for: 3).paintPalette.count >= 2,
                "levels should provide paint palettes",
                &failures
            )

            let game = GameState()
            let bloodRose = RewardCatalog.shared.rewards.first {
                $0.id == "blood_rose"
            }!
            _ = game.chooseReward(bloodRose)
            record(
                game.currentLevel.id == "blood_rooftop",
                "choosing reward into fight 2 should update current level",
                &failures
            )
            record(
                game.bossVerdict.contains(game.currentLevel.title),
                "level title should appear in intro verdict",
                &failures
            )
        }

        private static func checkCharacterRules(_ failures: inout [String]) {
            let defaultCharacter = CharacterCatalog.shared.defaultCharacter
            record(
                defaultCharacter.id == "vhs_blade",
                "default character should be VHS Blade",
                &failures
            )
            record(
                defaultCharacter.attackFrames == [
                    "attack1", "attack2", "attack3",
                ],
                "default character should use current player frames",
                &failures
            )

            let bloodSaint = CharacterCatalog.shared.character(
                id: "blood_saint"
            )
            record(
                bloodSaint.maxHP == 90,
                "blood saint max HP should load from JSON",
                &failures
            )
            record(
                bloodSaint.bloodCostModifier == -2,
                "blood saint blood modifier should load from JSON",
                &failures
            )

            let game = GameState()
            game.currentCharacter = bloodSaint
            game.restartRun()
            record(
                game.playerHealth == bloodSaint.maxHP,
                "restart should use character max HP",
                &failures
            )
            record(
                game.playerFrame == bloodSaint.idleAsset,
                "restart should use character idle asset",
                &failures
            )

            let reaperZero = CharacterCatalog.shared.character(
                id: "reaper_zero"
            )
            game.currentCharacter = reaperZero
            game.restartRun()
            record(
                game.currentCharacter.id == "reaper_zero",
                "restart should preserve selected character",
                &failures
            )
            record(
                game.playerHealth == reaperZero.maxHP,
                "selected reaper zero should set HP",
                &failures
            )
        }

        private static func record(
            _ condition: Bool,
            _ message: String,
            _ failures: inout [String]
        ) {
            if !condition {
                failures.append(message)
            }
        }
    }

    extension Array where Element == GameEvent {
        fileprivate func containsSound(_ name: String) -> Bool {
            contains { event in
                if case .sound(name) = event {
                    return true
                }
                return false
            }
        }

        fileprivate func containsUnlockReward(_ title: String) -> Bool {
            contains { event in
                if case .unlockReward(title) = event {
                    return true
                }
                return false
            }
        }

        fileprivate var containsPlayerHitImpact: Bool {
            contains { event in
                if case .playerHitImpact = event {
                    return true
                }
                return false
            }
        }

        fileprivate var containsFinisherImpact: Bool {
            contains { event in
                if case .finisherImpact = event {
                    return true
                }
                return false
            }
        }
    }
#endif
