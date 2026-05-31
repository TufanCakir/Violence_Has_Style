//
//  BattleViews.swift
//  Violence Has Style
//
//  Created by Tufan Cakir on 30.05.26.
//

import SwiftUI

struct BattleSceneView: View {
    let game: GameState
    let screenShakeOffset: CGSize
    let brokenPulse: Bool
    let styleGodPulse: Bool
    let exit: () -> Void

    var body: some View {
        VStack(spacing: 18) {
            BattleHUDView(
                game: game,
                exit: exit
            )

            Spacer(minLength: 12)

            BattleArenaView(
                game: game,
                brokenPulse: brokenPulse,
                styleGodPulse: styleGodPulse
            )
            .frame(maxWidth: .infinity)
            .frame(height: 460)
            .contentShape(Rectangle())

            BattleStatusView(game: game)
        }
        .padding(20)
        .offset(screenShakeOffset)
        .background(BattleBackgroundView(level: game.currentLevel))
    }
}

private struct BattleArenaView: View {
    let game: GameState
    let brokenPulse: Bool
    let styleGodPulse: Bool

    var body: some View {
        ZStack(alignment: .bottom) {
            BattlePaintLayerView(strokes: game.paintStrokes)

            HStack(alignment: .bottom) {
                FighterSprite(
                    assetName: game.playerFrame,
                    fallbackTitle: "PLAYER",
                    tint: game.currentCharacter.tint,
                    isEnemy: false
                )
                .frame(width: 180, height: 280)
                .scaleEffect(styleGodScale)
                .offset(x: game.playerOffset)
                .shadow(
                    color: game.activeStyle.tint.opacity(playerAuraOpacity),
                    radius: playerAuraRadius
                )
                .shadow(
                    color: game.currentCharacter.tint.opacity(0.35),
                    radius: 8
                )
                .animation(
                    .snappy(duration: 0.12),
                    value: game.attackFrameIndex
                )
                .animation(.snappy(duration: 0.2), value: game.styleRank)
                .animation(.snappy(duration: 0.18), value: game.activeStyle)
                .animation(
                    .easeInOut(duration: 0.55).repeatForever(
                        autoreverses: true
                    ),
                    value: styleGodPulse
                )

                Spacer()

                FighterSprite(
                    assetName: game.enemyFrame,
                    fallbackTitle: game.isEnemyBroken ? "BROKEN" : "ENEMY",
                    tint: game.flashHit ? .red : game.currentEnemy.tint,
                    isEnemy: true
                )
                .frame(width: 140, height: 220)
                .scaleEffect(enemyScale)
                .offset(x: game.flashHit ? 14 : 0)
                .shadow(
                    color: game.currentEnemy.tint.opacity(
                        game.currentEnemy.isBoss ? 0.95 : 0.6
                    ),
                    radius: game.currentEnemy.glowRadius
                )
                .animation(.snappy(duration: 0.08), value: game.flashHit)
                .animation(.snappy(duration: 0.2), value: game.isEnemyBroken)
                .animation(
                    .easeInOut(duration: 0.58).repeatForever(
                        autoreverses: true
                    ),
                    value: styleGodPulse
                )
            }
            .padding(.horizontal, 24)

            if game.isEnemyBroken {
                Text("BROKEN")
                    .font(.system(size: 42, weight: .black, design: .rounded))
                    .foregroundStyle(game.currentEnemy.brokenColor)
                    .shadow(
                        color: game.currentEnemy.brokenColor.opacity(0.8),
                        radius: 10
                    )
                    .scaleEffect(brokenPulse ? 1.08 : 0.96)
                    .offset(x: 78, y: -210)
                    .animation(
                        .easeInOut(duration: 0.45).repeatForever(
                            autoreverses: true
                        ),
                        value: brokenPulse
                    )
                    .transition(.scale.combined(with: .opacity))
            }
        }
    }

    private var styleGodScale: CGFloat {
        guard game.styleRank == .styleGod else { return 1 }
        return styleGodPulse ? 1.17 : 1.09
    }

    private var playerAuraOpacity: Double {
        if game.styleRank == .styleGod {
            return 0.98
        }

        return 0.55 + Double(game.styleRank.score) * 0.12
    }

    private var playerAuraRadius: CGFloat {
        CGFloat(14 + game.styleRank.score * 6)
            + (game.styleRank == .styleGod && styleGodPulse ? 10 : 0)
    }

    private var enemyScale: CGFloat {
        let base = game.isEnemyBroken ? 0.88 : (game.flashHit ? 0.96 : 1)
        let bossPulse: CGFloat =
            game.currentEnemy.isBoss && styleGodPulse ? 1.06 : 1
        return base * game.currentEnemy.scale * bossPulse
    }
}

private struct BattleHUDView: View {
    let game: GameState
    let exit: () -> Void

    var body: some View {
        VStack(spacing: 12) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(game.styleRank.title)
                        .font(
                            .system(size: 24, weight: .black, design: .rounded)
                        )
                        .foregroundStyle(game.styleRank.color)
                        .tracking(1.2)

                    Text("STYLE \(game.style)%")
                        .font(
                            .system(
                                size: 11,
                                weight: .black,
                                design: .monospaced
                            )
                        )
                        .foregroundStyle(.white.opacity(0.7))
                }

                Spacer()

                VStack(alignment: .trailing, spacing: 4) {
                    Text(game.activeStyle.title)
                        .font(
                            .system(size: 15, weight: .black, design: .rounded)
                        )
                        .foregroundStyle(game.activeStyle.tint)
                        .tracking(1)

                    Text("FIGHT \(game.fightLevel)  HP \(game.playerHealth)%")
                        .font(
                            .system(
                                size: 11,
                                weight: .black,
                                design: .monospaced
                            )
                        )
                        .foregroundStyle(.white.opacity(0.72))

                    Text(game.currentCharacter.title)
                        .font(
                            .system(
                                size: 10,
                                weight: .black,
                                design: .monospaced
                            )
                        )
                        .foregroundStyle(
                            game.currentCharacter.tint.opacity(0.8)
                        )

                    Text("ENEMY IN \(game.enemyActionCountdown)")
                        .font(
                            .system(
                                size: 10,
                                weight: .black,
                                design: .monospaced
                            )
                        )
                        .foregroundStyle(.red.opacity(0.78))

                    Text(game.currentEnemy.title)
                        .font(
                            .system(
                                size: 11,
                                weight: .black,
                                design: .monospaced
                            )
                        )
                        .foregroundStyle(game.currentEnemy.tint.opacity(0.9))

                    Button("EXIT") {
                        exit()
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(.red.opacity(0.2))
                    .clipShape(Capsule())

                    Text(game.currentLevel.title)
                        .font(
                            .system(
                                size: 10,
                                weight: .black,
                                design: .monospaced
                            )
                        )
                        .foregroundStyle(
                            game.currentLevel.accentColor.opacity(0.82)
                        )
                }
            }

            BattleMeterView(
                value: game.style,
                maxValue: game.maxStyle,
                fill: LinearGradient(
                    colors: [.white, game.styleRank.color],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )

            if !game.isEnemyBroken {
                BattleHealthBarView(game: game)
            }
        }
    }
}

private struct BattleMeterView<S: ShapeStyle>: View {
    let value: Int
    let maxValue: Int
    let fill: S

    var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(
                        ThemeManager.shared.currentTheme.panelColor.opacity(
                            0.35
                        )
                    )

                Capsule()
                    .fill(fill)
                    .frame(
                        width: proxy.size.width * CGFloat(value)
                            / CGFloat(max(1, maxValue))
                    )
            }
        }
        .frame(height: 10)
    }
}

private struct BattleHealthBarView: View {
    let game: GameState

    var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(game.currentEnemy.tint.opacity(0.16))

                Capsule()
                    .fill(
                        LinearGradient(
                            colors: [.red, game.currentEnemy.tint],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(
                        width: proxy.size.width * CGFloat(game.enemyHealth)
                            / CGFloat(max(1, game.enemyMaxHealth))
                    )
            }
        }
        .frame(height: 12)
        .overlay(alignment: .trailing) {
            Text(
                game.isEnemyBroken
                    ? "BROKEN"
                    : "\(game.currentEnemy.title) \(game.enemyHealth)/\(game.enemyMaxHealth)"
            )
            .font(.system(size: 10, weight: .black, design: .monospaced))
            .foregroundStyle(.white.opacity(0.8))
            .padding(.trailing, 8)
        }
    }
}

private struct BattleStatusView: View {
    let game: GameState

    var body: some View {
        VStack(spacing: 6) {
            Text("BOSS: \(game.bossVerdict)")
                .font(.system(size: 12, weight: .black, design: .monospaced))
                .foregroundStyle(.white.opacity(0.82))

            Text(
                game.isEnemyBroken
                    ? "TAP FOR FINISHER / SWIPE STYLE"
                    : "TAP ATTACK / SWIPE STYLE"
            )
            .font(.system(size: 13, weight: .black, design: .rounded))
            .foregroundStyle(.white.opacity(0.58))
            .tracking(1.2)
        }
    }
}

private struct BattlePaintLayerView: View {
    let strokes: [PaintStroke]

    var body: some View {
        Canvas { context, size in
            for stroke in strokes {
                var path = Path()
                path.move(
                    to: CGPoint(
                        x: size.width * stroke.startX,
                        y: size.height * stroke.startY
                    )
                )
                path.addCurve(
                    to: CGPoint(
                        x: size.width * stroke.endX,
                        y: size.height * stroke.endY
                    ),
                    control1: CGPoint(
                        x: size.width * stroke.controlX,
                        y: size.height * stroke.controlY
                    ),
                    control2: CGPoint(
                        x: size.width * stroke.control2X,
                        y: size.height * stroke.control2Y
                    )
                )

                context.stroke(
                    path,
                    with: .color(stroke.color.opacity(stroke.opacity)),
                    style: StrokeStyle(
                        lineWidth: stroke.lineWidth,
                        lineCap: .round,
                        lineJoin: .round
                    )
                )
            }
        }
        .blur(radius: 0.4)
        .allowsHitTesting(false)
    }
}

struct BattleBackgroundView: View {
    let level: LevelDefinition

    var body: some View {
        ThemeBackgroundView()
            .overlay {
                RadialGradient(
                    colors: [level.accentColor.opacity(0.18), .clear],
                    center: .center,
                    startRadius: 40,
                    endRadius: 320
                )
            }
            .overlay {
                VStack(spacing: 18) {
                    ForEach(0..<18, id: \.self) { _ in
                        Rectangle()
                            .fill(.white.opacity(0.025))
                            .frame(height: 1)
                    }
                }
            }
            .ignoresSafeArea()
    }
}

struct RewardChoiceOverlayView: View {
    let fightLevel: Int
    let rewards: [RunReward]
    let chooseReward: (RunReward) -> Void

    var body: some View {
        ZStack {
            ThemeBackgroundView()
                .ignoresSafeArea()

            VStack(spacing: 16) {
                Text("CHOOSE YOUR STYLE")
                    .font(.system(size: 24, weight: .black, design: .rounded))
                    .foregroundStyle(.white)
                    .tracking(1.4)

                Text("FIGHT \(fightLevel + 1) WAITS")
                    .font(
                        .system(size: 11, weight: .black, design: .monospaced)
                    )
                    .foregroundStyle(.white.opacity(0.58))

                VStack(spacing: 10) {
                    ForEach(rewards) { reward in
                        Button {
                            chooseReward(reward)
                        } label: {
                            VStack(alignment: .leading, spacing: 5) {
                                Text(reward.title)
                                    .font(
                                        .system(
                                            size: 16,
                                            weight: .black,
                                            design: .rounded
                                        )
                                    )
                                    .foregroundStyle(reward.color)

                                Text(reward.description)
                                    .font(
                                        .system(
                                            size: 12,
                                            weight: .bold,
                                            design: .monospaced
                                        )
                                    )
                                    .foregroundStyle(.white.opacity(0.74))
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(14)
                            .background(
                                ThemeManager.shared.currentTheme.panelColor
                                    .opacity(0.58)
                            )
                            .overlay {
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(
                                        reward.color.opacity(0.7),
                                        lineWidth: 1
                                    )
                            }
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .padding(24)
        }
    }
}
