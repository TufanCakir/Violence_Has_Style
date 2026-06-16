//
//  EnemyAvatarView.swift
//  Violence Has Style
//
//  Created by Tufan Cakir on 11.06.26.
//

import SwiftUI

struct EnemyAvatarBattleSprite: View {
    let enemy: EnemyType
    let isBroken: Bool
    let isHit: Bool

    private var avatar: EnemyAvatarDefinition {
        EnemyAvatarCatalog.shared.avatar(for: enemy)
    }

    var body: some View {
        ZStack {
            EnemyAvatarView(avatar: avatar)
                .scaleEffect(isHit ? 0.94 : 1)
                .saturation(isBroken ? 1.35 : 1)
                .brightness(isBroken ? 0.08 : 0)
                .shadow(
                    color: enemy.tint.opacity(0.8),
                    radius: enemy.glowRadius
                )
                .shadow(
                    color: enemy.brokenColor.opacity(isBroken ? 0.95 : 0),
                    radius: 24
                )

            if isBroken {
                Image(systemName: "exclamationmark.triangle.fill")
                    .font(.system(size: enemy.isBoss ? 38 : 30, weight: .black))
                    .foregroundStyle(enemy.brokenColor)
                    .shadow(color: enemy.brokenColor, radius: 12)
                    .offset(y: -86)
            }
        }
        .animation(.snappy(duration: 0.08), value: isHit)
        .animation(.snappy(duration: 0.2), value: isBroken)
    }
}

struct EnemyAvatarView: View {
    let avatar: EnemyAvatarDefinition

    var body: some View {
        GeometryReader { proxy in
            let size = min(proxy.size.width, proxy.size.height)
            let unit = size / 220

            ZStack {
                Circle()
                    .fill(avatar.primaryColor.opacity(0.13))
                    .frame(width: 160 * unit, height: 160 * unit)
                    .blur(radius: 12 * unit)

                legs(unit: unit)
                    .offset(y: 70 * unit)

                arms(unit: unit)
                    .offset(y: 32 * unit)

                AvatarBodyShape(kind: avatar.bodyType)
                    .fill(bodyFill)
                    .frame(width: 86 * unit, height: 106 * unit)
                    .overlay {
                        AvatarBodyShape(kind: avatar.bodyType)
                            .stroke(
                                avatar.accentColor.opacity(0.34),
                                lineWidth: 2
                            )
                    }
                    .shadow(color: avatar.primaryColor.opacity(0.7), radius: 11)
                    .offset(y: 40 * unit)

                weapon(unit: unit)
                    .offset(x: 56 * unit, y: 28 * unit)

                head(unit: unit)
                    .offset(y: -34 * unit)
            }
            .scaleEffect(avatar.scale)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }

    private var bodyFill: LinearGradient {
        LinearGradient(
            colors: [
                avatar.primaryColor,
                avatar.secondaryColor,
                .black.opacity(0.9),
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    private func head(unit: CGFloat) -> some View {
        ZStack {
            if avatar.hasHorns {
                HStack(spacing: 36 * unit) {
                    Triangle()
                        .fill(avatar.accentColor)
                        .frame(width: 24 * unit, height: 36 * unit)
                        .rotationEffect(.degrees(-28))

                    Triangle()
                        .fill(avatar.accentColor)
                        .frame(width: 24 * unit, height: 36 * unit)
                        .rotationEffect(.degrees(28))
                }
                .offset(y: -27 * unit)
            }

            ears(unit: unit)

            AvatarHeadShape(kind: avatar.headType)
                .fill(
                    LinearGradient(
                        colors: [avatar.secondaryColor, avatar.primaryColor],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .frame(width: 70 * unit, height: 66 * unit)
                .overlay {
                    AvatarHeadShape(kind: avatar.headType)
                        .stroke(avatar.accentColor.opacity(0.5), lineWidth: 2)
                }

            face(unit: unit)
        }
    }

    private func ears(unit: CGFloat) -> some View {
        HStack(spacing: 54 * unit) {
            ear(unit: unit)
                .scaleEffect(x: -1, y: 1)
            ear(unit: unit)
        }
    }

    @ViewBuilder
    private func ear(unit: CGFloat) -> some View {
        switch avatar.earType {
        case "pointed", "spike":
            Triangle()
                .fill(avatar.primaryColor.opacity(0.88))
                .frame(width: 18 * unit, height: 26 * unit)
                .rotationEffect(.degrees(90))
        default:
            EmptyView()
        }
    }

    private func face(unit: CGFloat) -> some View {
        VStack(spacing: 8 * unit) {
            HStack(spacing: 16 * unit) {
                eye(unit: unit)
                eye(unit: unit)
            }

            nose(unit: unit)

            mouth(unit: unit)
        }
        .offset(y: 5 * unit)
    }

    private func eye(unit: CGFloat) -> some View {
        Capsule()
            .fill(avatar.eyeColor)
            .frame(width: 13 * unit, height: 7 * unit)
            .shadow(color: avatar.eyeColor, radius: 5 * unit)
    }

    @ViewBuilder
    private func nose(unit: CGFloat) -> some View {
        switch avatar.noseType {
        case "slash", "beast":
            Capsule()
                .fill(avatar.accentColor.opacity(0.75))
                .frame(width: 5 * unit, height: 14 * unit)
                .rotationEffect(.degrees(12))
        case "small":
            Circle()
                .fill(avatar.accentColor.opacity(0.75))
                .frame(width: 5 * unit, height: 5 * unit)
        default:
            EmptyView()
        }
    }

    @ViewBuilder
    private func mouth(unit: CGFloat) -> some View {
        switch avatar.mouthType {
        case "visor":
            Capsule()
                .fill(avatar.eyeColor.opacity(0.9))
                .frame(width: 36 * unit, height: 5 * unit)
        case "fangs":
            HStack(spacing: 4 * unit) {
                Triangle()
                    .fill(.white)
                    .frame(width: 7 * unit, height: 10 * unit)
                    .rotationEffect(.degrees(180))
                Triangle()
                    .fill(.white)
                    .frame(width: 7 * unit, height: 10 * unit)
                    .rotationEffect(.degrees(180))
            }
        case "grin":
            Capsule()
                .fill(.white.opacity(0.85))
                .frame(width: 30 * unit, height: 4 * unit)
        default:
            Capsule()
                .fill(avatar.accentColor.opacity(0.85))
                .frame(width: 24 * unit, height: 4 * unit)
        }
    }

    private func arms(unit: CGFloat) -> some View {
        HStack(spacing: 78 * unit) {
            limb(width: 18 * unit, height: 76 * unit)
                .rotationEffect(.degrees(18))

            limb(width: 18 * unit, height: 76 * unit)
                .rotationEffect(.degrees(-18))
        }
    }

    private func legs(unit: CGFloat) -> some View {
        HStack(spacing: 18 * unit) {
            limb(width: 20 * unit, height: 74 * unit)
                .rotationEffect(.degrees(8))

            limb(width: 20 * unit, height: 74 * unit)
                .rotationEffect(.degrees(-8))
        }
    }

    private func limb(width: CGFloat, height: CGFloat) -> some View {
        Capsule()
            .fill(
                LinearGradient(
                    colors: [avatar.primaryColor, avatar.secondaryColor],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .frame(width: width, height: height)
            .overlay {
                Capsule()
                    .stroke(avatar.accentColor.opacity(0.26), lineWidth: 1)
            }
    }

    @ViewBuilder
    private func weapon(unit: CGFloat) -> some View {
        switch avatar.weaponType {
        case "axe":
            ZStack(alignment: .top) {
                Capsule()
                    .fill(avatar.accentColor)
                    .frame(width: 6 * unit, height: 112 * unit)
                AvatarWeaponShape()
                    .fill(avatar.primaryColor)
                    .frame(width: 54 * unit, height: 42 * unit)
                    .offset(y: -8 * unit)
            }
            .rotationEffect(.degrees(-18))
        case "staff":
            ZStack(alignment: .top) {
                Capsule()
                    .fill(avatar.accentColor)
                    .frame(width: 6 * unit, height: 120 * unit)
                Circle()
                    .fill(avatar.eyeColor)
                    .frame(width: 24 * unit, height: 24 * unit)
                    .shadow(color: avatar.eyeColor, radius: 8 * unit)
            }
            .rotationEffect(.degrees(10))
        case "spear":
            ZStack(alignment: .top) {
                Capsule()
                    .fill(avatar.accentColor)
                    .frame(width: 5 * unit, height: 136 * unit)
                Triangle()
                    .fill(avatar.primaryColor)
                    .frame(width: 28 * unit, height: 42 * unit)
                    .offset(y: -18 * unit)
            }
            .rotationEffect(.degrees(-14))
        default:
            ZStack(alignment: .top) {
                Capsule()
                    .fill(avatar.accentColor)
                    .frame(width: 11 * unit, height: 118 * unit)
                Triangle()
                    .fill(.white.opacity(0.9))
                    .frame(width: 26 * unit, height: 70 * unit)
                    .offset(y: -24 * unit)
            }
            .rotationEffect(.degrees(-24))
        }
    }
}

private struct AvatarBodyShape: Shape {
    let kind: String

    func path(in rect: CGRect) -> Path {
        switch kind {
        case "armored":
            return armoredPath(in: rect)
        case "mage":
            return magePath(in: rect)
        case "beast":
            return beastPath(in: rect)
        default:
            return fighterPath(in: rect)
        }
    }

    private func fighterPath(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(
            to: CGPoint(x: rect.maxX, y: rect.minY + rect.height * 0.22)
        )
        path.addLine(
            to: CGPoint(x: rect.maxX - rect.width * 0.12, y: rect.maxY)
        )
        path.addLine(
            to: CGPoint(x: rect.minX + rect.width * 0.12, y: rect.maxY)
        )
        path.addLine(
            to: CGPoint(x: rect.minX, y: rect.minY + rect.height * 0.22)
        )
        path.closeSubpath()
        return path
    }

    private func armoredPath(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(
            to: CGPoint(x: rect.maxX, y: rect.minY + rect.height * 0.18)
        )
        path.addLine(
            to: CGPoint(x: rect.maxX - rect.width * 0.06, y: rect.maxY * 0.9)
        )
        path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
        path.addLine(
            to: CGPoint(x: rect.minX + rect.width * 0.06, y: rect.maxY * 0.9)
        )
        path.addLine(
            to: CGPoint(x: rect.minX, y: rect.minY + rect.height * 0.18)
        )
        path.closeSubpath()
        return path
    }

    private func magePath(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.closeSubpath()
        return path
    }

    private func beastPath(in rect: CGRect) -> Path {
        Path(
            roundedRect: rect,
            cornerSize: CGSize(
                width: rect.width * 0.18,
                height: rect.width * 0.18
            )
        )
    }
}

private struct AvatarHeadShape: Shape {
    let kind: String

    func path(in rect: CGRect) -> Path {
        switch kind {
        case "hood":
            var path = Path()
            path.move(to: CGPoint(x: rect.midX, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
            path.closeSubpath()
            return path
        case "mask", "helmet":
            return Path(roundedRect: rect, cornerRadius: rect.width * 0.2)
        default:
            return Path(ellipseIn: rect)
        }
    }
}

private struct AvatarWeaponShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX, y: rect.midY))
        path.addQuadCurve(
            to: CGPoint(x: rect.maxX, y: rect.midY),
            control: CGPoint(x: rect.midX, y: rect.minY)
        )
        path.addQuadCurve(
            to: CGPoint(x: rect.minX, y: rect.midY),
            control: CGPoint(x: rect.midX, y: rect.maxY)
        )
        path.closeSubpath()
        return path
    }
}

private struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}
