//
//  ThemeDefinition.swift
//  Violence Has Style
//
//  Created by Tufan Cakir on 31.05.26.
//

import SwiftUI

struct ThemeDefinition: Codable, Equatable, Identifiable {
    let id: String
    let title: String
    let primaryHex: String
    let secondaryHex: String
    let accentHex: String
    let backgroundHex: String
    let panelHex: String
    let textHex: String
    let symbol: String
    let isStylePassExclusive: Bool

    var primaryColor: Color { Color(hex: primaryHex) }
    var secondaryColor: Color { Color(hex: secondaryHex) }
    var accentColor: Color { Color(hex: accentHex) }
    var backgroundColor: Color { Color(hex: backgroundHex) }
    var panelColor: Color { Color(hex: panelHex) }
    var textColor: Color { Color(hex: textHex) }

    static let fallback = ThemeDefinition(
        id: "vhs_default",
        title: "VHS DEFAULT",
        primaryHex: "#FF1744",
        secondaryHex: "#7CFFCE",
        accentHex: "#FFFFFF",
        backgroundHex: "#050505",
        panelHex: "#111111",
        textHex: "#FFFFFF",
        symbol: "slash.circle.fill",
        isStylePassExclusive: false
    )

    static let fallbackThemes: [ThemeDefinition] = [
        fallback,
        ThemeDefinition(
            id: "blood_moon",
            title: "BLOOD MOON",
            primaryHex: "#FF1744",
            secondaryHex: "#FF8A80",
            accentHex: "#FFFFFF",
            backgroundHex: "#080103",
            panelHex: "#170509",
            textHex: "#FFFFFF",
            symbol: "moon.stars.fill",
            isStylePassExclusive: false
        ),
    ]
}
