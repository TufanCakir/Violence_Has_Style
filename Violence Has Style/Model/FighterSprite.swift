//
//  FighterSprite.swift
//  Violence Has Style
//
//  Created by Tufan Cakir on 30.05.26.
//

import SwiftUI

struct FighterSprite: View {
    let assetName: String
    let fallbackTitle: String
    let tint: Color
    let isEnemy: Bool

    var body: some View {
        ZStack(alignment: .bottom) {
            AsyncImage(
                url: RemoteContentStore.shared.assetURL(named: assetName)
            ) { phase in
                if let image = phase.image {
                    image
                        .resizable()
                        .scaledToFit()
                        .id(assetName)
                        .shadow(color: tint.opacity(0.8), radius: 14)
                } else {
                    fallbackSprite
                }
            }
        }
        .scaleEffect(x: isEnemy ? -1 : 1, y: 1)
    }

    private var fallbackSprite: some View {
        VStack(spacing: 0) {
            Circle()
                .fill(tint.opacity(0.9))
                .frame(width: 62, height: 62)
                .overlay {
                    Circle()
                        .stroke(.white.opacity(0.45), lineWidth: 3)
                }

            RoundedRectangle(cornerRadius: 14)
                .fill(
                    LinearGradient(
                        colors: [tint, .black],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .frame(width: 82, height: 112)
                .overlay {
                    Text(fallbackTitle)
                        .font(
                            .system(
                                size: 12,
                                weight: .black,
                                design: .monospaced
                            )
                        )
                        .foregroundStyle(.white)
                        .scaleEffect(x: isEnemy ? -1 : 1, y: 1)
                }

            HStack(spacing: 14) {
                Capsule()
                    .fill(tint.opacity(0.75))
                    .frame(width: 22, height: 52)
                Capsule()
                    .fill(tint.opacity(0.75))
                    .frame(width: 22, height: 52)
            }
        }
        .shadow(color: tint.opacity(0.65), radius: 18)
    }
}

struct EnemyShapeSprite: View {
    let enemy: EnemyType
    let isBroken: Bool
    let isHit: Bool

    var body: some View {
        ZStack {
            StyleEnemyShape(kind: enemy.shape)
                .fill(enemyFill)
                .overlay {
                    StyleEnemyShape(kind: enemy.shape)
                        .stroke(
                            .white.opacity(isBroken ? 0.85 : 0.36),
                            lineWidth: 3
                        )
                }
                .shadow(
                    color: enemy.tint.opacity(0.85),
                    radius: enemy.glowRadius
                )
                .shadow(
                    color: enemy.brokenColor.opacity(isBroken ? 0.9 : 0),
                    radius: 24
                )

            Image(
                systemName: isBroken
                    ? "exclamationmark.triangle.fill" : enemy.symbol
            )
            .font(.system(size: enemy.isBoss ? 54 : 42, weight: .black))
            .foregroundStyle(.white.opacity(isHit ? 1 : 0.82))
            .shadow(color: enemy.tint, radius: 10)

            if enemy.isBoss {
                Circle()
                    .stroke(enemy.tint.opacity(0.26), lineWidth: 12)
                    .scaleEffect(isHit ? 1.08 : 1)
            }
        }
        .padding(enemy.isBoss ? 4 : 16)
        .scaleEffect(isHit ? 0.94 : 1)
    }

    private var enemyFill: LinearGradient {
        LinearGradient(
            colors: [
                enemy.tint.opacity(isBroken ? 0.95 : 0.8),
                ThemeManager.shared.currentTheme.panelColor.opacity(0.88),
                enemy.brokenColor.opacity(isBroken ? 0.9 : 0.28),
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

}

private struct StyleEnemyShape: Shape {
    let kind: String

    func path(in rect: CGRect) -> Path {
        switch kind {
        case "circle", "ring":
            return Path(ellipseIn: rect)
        case "capsule":
            return Path(
                roundedRect: rect,
                cornerRadius: min(rect.width, rect.height) / 2
            )
        case "hexagon":
            return hexagonPath(in: rect)
        default:
            return diamondPath(in: rect)
        }
    }

    private func diamondPath(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.midY))
        path.closeSubpath()
        return path
    }

    private func hexagonPath(in rect: CGRect) -> Path {
        let inset = rect.width * 0.18
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(
            to: CGPoint(
                x: rect.maxX - inset,
                y: rect.minY + rect.height * 0.18
            )
        )
        path.addLine(
            to: CGPoint(
                x: rect.maxX - inset,
                y: rect.maxY - rect.height * 0.18
            )
        )
        path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
        path.addLine(
            to: CGPoint(
                x: rect.minX + inset,
                y: rect.maxY - rect.height * 0.18
            )
        )
        path.addLine(
            to: CGPoint(
                x: rect.minX + inset,
                y: rect.minY + rect.height * 0.18
            )
        )
        path.closeSubpath()
        return path
    }
}
