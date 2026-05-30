//
//  Violence_Has_StyleApp.swift
//  Violence Has Style
//
//  Created by Tufan Cakir on 30.05.26.
//

import SwiftData
import SwiftUI

@main
struct Violence_Has_StyleApp: App {

    var body: some Scene {
        WindowGroup {
            GameView()
        }
        .modelContainer(
            for: [
                PlayerProgress.self,
                EventWallet.self,
            ]
        )
    }
}
