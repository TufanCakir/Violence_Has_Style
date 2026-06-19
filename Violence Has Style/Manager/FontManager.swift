//
//  FontManager.swift
//  Violence Has Style
//
//  Created by Tufan Cakir on 19.06.26.
//

import CoreText
import Foundation
import SwiftUI

enum FontManager {
    static let fallbackFontName = "DEADLY KILLERS"

    static func registerBundledFonts() {
        let fontExtensions = ["ttf", "otf"]
        let subdirectories: [String?] = [nil, "Fonts"]

        for fileExtension in fontExtensions {
            for subdirectory in subdirectories {
                guard
                    let urls = Bundle.main.urls(
                        forResourcesWithExtension: fileExtension,
                        subdirectory: subdirectory
                    )
                else {
                    continue
                }

                for url in urls {
                    CTFontManagerRegisterFontsForURL(
                        url as CFURL,
                        .process,
                        nil
                    )
                }
            }
        }
    }
}

extension Font {
    static func vhs(
        size: CGFloat,
        weight: Font.Weight = .regular,
        design: Font.Design? = nil
    ) -> Font {
        let fontName =
            RemoteContentStore.shared.uiConfig.typography.fontName
            ?? FontManager.fallbackFontName

        return .custom(fontName, size: size).weight(weight)
    }
}
