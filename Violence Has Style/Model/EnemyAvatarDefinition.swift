//
//  EnemyAvatarDefinition.swift
//  Violence Has Style
//
//  Created by Tufan Cakir on 11.06.26.
//

import SwiftUI

struct EnemyAvatarDefinition: Codable, Equatable, Identifiable {
    let id: String
    let title: String
    let bodyType: String
    let headType: String
    let weaponType: String
    let earType: String
    let noseType: String
    let mouthType: String
    let primaryHex: String
    let secondaryHex: String
    let accentHex: String
    let eyeHex: String
    let scale: Double
    let hasHorns: Bool
    let hasMask: Bool

    var primaryColor: Color { Color(hex: primaryHex) }
    var secondaryColor: Color { Color(hex: secondaryHex) }
    var accentColor: Color { Color(hex: accentHex) }
    var eyeColor: Color { Color(hex: eyeHex) }

    static let fallback: [EnemyAvatarDefinition] = [
        EnemyAvatarDefinition(
            id: "grunt",
            title: "BLADE GRUNT",
            bodyType: "fighter",
            headType: "helmet",
            weaponType: "sword",
            earType: "none",
            noseType: "slash",
            mouthType: "scar",
            primaryHex: "#FF1744",
            secondaryHex: "#2B0A10",
            accentHex: "#C7F9FF",
            eyeHex: "#FFFFFF",
            scale: 1,
            hasHorns: false,
            hasMask: false
        ),
        EnemyAvatarDefinition(
            id: "duelist",
            title: "VOID KNIGHT",
            bodyType: "armored",
            headType: "mask",
            weaponType: "axe",
            earType: "spike",
            noseType: "none",
            mouthType: "visor",
            primaryHex: "#7D3CFF",
            secondaryHex: "#101016",
            accentHex: "#00E5FF",
            eyeHex: "#00E5FF",
            scale: 1.08,
            hasHorns: true,
            hasMask: true
        ),
    ]

    static func loadDefinitions() -> [EnemyAvatarDefinition] {
        guard
            let url = Bundle.main.url(
                forResource: "EnemyAvatarDefinitions",
                withExtension: "json"
            )
        else {
            return fallback
        }

        do {
            let data = try Data(contentsOf: url)
            return try JSONDecoder().decode(
                [EnemyAvatarDefinition].self,
                from: data
            )
        } catch {
            print(
                "EnemyAvatarDefinitions.json failed: \(error.localizedDescription)"
            )
            return fallback
        }
    }
}

struct EnemyAvatarCatalog {
    static let shared = EnemyAvatarCatalog()

    private init() {}

    func avatar(for enemy: EnemyType) -> EnemyAvatarDefinition {
        let avatars = Dictionary(
            uniqueKeysWithValues:
                RemoteContentStore.shared.enemyAvatarDefinitions.map {
                    ($0.id, $0)
                }
        )

        return avatars[enemy.rawValue] ?? EnemyAvatarDefinition.fallback[0]
    }
}
