//
//  ThemeManager.swift
//  Violence Has Style
//
//  Created by Tufan Cakir on 31.05.26.
//

import SwiftUI

@Observable
final class ThemeManager {
    static let shared = ThemeManager()

    private let selectedThemeKey = "selectedThemeId"
    var selectedThemeId: String

    private init() {
        selectedThemeId =
            UserDefaults.standard.string(forKey: selectedThemeKey)
            ?? "vhs_default"
    }

    var themes: [ThemeDefinition] {
        let remoteThemes = RemoteContentStore.shared.themeDefinitions
        return remoteThemes.isEmpty
            ? ThemeDefinition.fallbackThemes : remoteThemes
    }

    var currentTheme: ThemeDefinition {
        themes.first { $0.id == selectedThemeId } ?? themes.first ?? .fallback
    }

    func selectTheme(_ theme: ThemeDefinition) {
        selectedThemeId = theme.id
        UserDefaults.standard.set(theme.id, forKey: selectedThemeKey)
    }
}
