//
//  LeaderboardView.swift
//  Violence Has Style
//
//  Created by Tufan Cakir on 30.05.26.
//

import GameKit
import SwiftUI

struct LeaderboardView: View {
    @State private var isShowingGameCenter = false

    var body: some View {
        ZStack {
            Color.black.opacity(0.86)
                .ignoresSafeArea()

            VStack(alignment: .leading, spacing: 16) {
                Text("LEADERBOARDS")
                    .font(.system(size: 30, weight: .black, design: .rounded))
                    .foregroundStyle(.white)

                Text("ENDLESS SCORE")
                    .font(.system(size: 12, weight: .black, design: .monospaced))
                    .foregroundStyle(.yellow)

                Button {
                    isShowingGameCenter = true
                } label: {
                    Text("OPEN GAME CENTER")
                        .font(.system(size: 15, weight: .black, design: .rounded))
                        .frame(maxWidth: .infinity)
                        .frame(height: 52)
                }
                .buttonStyle(.borderedProminent)
                .tint(.yellow)

                Text("Requires Game Center capability and leaderboard IDs in App Store Connect.")
                    .font(.system(size: 10, weight: .black, design: .monospaced))
                    .foregroundStyle(.white.opacity(0.52))

                Spacer()
            }
            .padding(24)
        }
        .sheet(isPresented: $isShowingGameCenter) {
            GameCenterLeaderboardController()
                .ignoresSafeArea()
        }
    }
}

private struct GameCenterLeaderboardController: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> GKGameCenterViewController {
        let controller = GKGameCenterViewController(state: .leaderboards)
        controller.gameCenterDelegate = context.coordinator
        return controller
    }

    func updateUIViewController(_ uiViewController: GKGameCenterViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    final class Coordinator: NSObject, GKGameCenterControllerDelegate {
        func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
            gameCenterViewController.dismiss(animated: true)
        }
    }
}
