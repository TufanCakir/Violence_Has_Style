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
                            .vhs(
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
