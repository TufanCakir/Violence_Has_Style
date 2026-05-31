//
//  PremiumStoreView.swift
//  Violence Has Style
//
//  Created by Tufan Cakir on 31.05.26.
//

import SwiftUI

struct PremiumStoreView: View {
    let products: [PremiumStoreProduct]
    let purchasedProductIds: [String]
    let unlockProduct: (String) -> Void
    let restoreProducts: ([String]) -> Void
    let back: () -> Void

    @State private var store = StoreKitManager.shared
    @State private var isBuyingProductId: String?

    private var displayedProducts: [PremiumStoreProduct] {
        products.isEmpty ? Self.fallbackProducts : products
    }

    var body: some View {
        ZStack {
            ThemeBackgroundView()

            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("PREMIUM STORE")
                                .font(
                                    .system(
                                        size: 30,
                                        weight: .black,
                                        design: .rounded
                                    )
                                )
                                .foregroundStyle(.white)

                            Text("COSMETICS ONLY. NO PAY TO WIN.")
                                .font(
                                    .system(
                                        size: 10,
                                        weight: .black,
                                        design: .monospaced
                                    )
                                )
                                .foregroundStyle(.white.opacity(0.58))
                        }

                        Spacer()

                        VStack(alignment: .trailing, spacing: 8) {
                            BackButton(action: back)

                            Button {
                                Task {
                                    await restorePurchases()
                                }
                            } label: {
                                Text("RESTORE")
                                    .font(
                                        .system(
                                            size: 10,
                                            weight: .black,
                                            design: .monospaced
                                        )
                                    )
                            }
                            .buttonStyle(.plain)
                            .foregroundStyle(
                                ThemeManager.shared.currentTheme.accentColor
                            )
                        }
                    }

                    PremiumStoreHero(
                        product: displayedProducts[0],
                        priceText: store.displayPrice(
                            for: displayedProducts[0]
                        ),
                        isOwned: isOwned(displayedProducts[0]),
                        isAvailable: store.canPurchase(displayedProducts[0]),
                        isBuying: isBuyingProductId
                            == displayedProducts[0].productId,
                        buy: {
                            Task {
                                await buy(displayedProducts[0])
                            }
                        }
                    )

                    Text(store.statusMessage)
                        .font(
                            .system(
                                size: 10,
                                weight: .black,
                                design: .monospaced
                            )
                        )
                        .foregroundStyle(.white.opacity(0.52))

                    VStack(spacing: 10) {
                        ForEach(displayedProducts) { product in
                            PremiumProductCard(
                                product: product,
                                priceText: store.displayPrice(for: product),
                                isOwned: isOwned(product),
                                isAvailable: store.canPurchase(product),
                                isBuying: isBuyingProductId
                                    == product.productId,
                                buy: {
                                    Task {
                                        await buy(product)
                                    }
                                }
                            )
                        }
                    }
                }
                .padding(24)
            }
        }
        .task(id: displayedProducts.map(\.productId)) {
            await store.loadProducts(for: displayedProducts)
        }
    }

    private func isOwned(_ product: PremiumStoreProduct) -> Bool {
        purchasedProductIds.contains(product.productId)
    }

    private func buy(_ product: PremiumStoreProduct) async {
        guard !isOwned(product) else { return }

        isBuyingProductId = product.productId
        let result = await store.purchase(product)
        isBuyingProductId = nil

        if case .purchased(let productId) = result {
            unlockProduct(productId)
        }
    }

    private func restorePurchases() async {
        let result = await store.restorePurchases()

        if case .restored(let productIds) = result {
            restoreProducts(productIds)
        }
    }

    private static let fallbackProducts: [PremiumStoreProduct] = [
        PremiumStoreProduct(
            id: "premium_pass_s1",
            productId:
                "com.tufancakir.violencehasstyle.premiumpass.season1",
            title: "SEASON 1 PREMIUM PASS",
            description: "Unlock premium cosmetic rewards, themes and FX.",
            category: "STYLE PASS",
            priceText: "COMING SOON",
            badge: "BEST VALUE",
            symbol: "ticket.fill",
            colorHex: "#FF1744",
            isFeatured: true,
            unlockType: "premiumPass",
            unlockValue: "gold_style_pass_01",
            unlockAmount: 0
        )
    ]
}

private struct PremiumStoreHero: View {
    let product: PremiumStoreProduct
    let priceText: String
    let isOwned: Bool
    let isAvailable: Bool
    let isBuying: Bool
    let buy: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 12) {
                Image(systemName: product.symbol)
                    .font(.system(size: 32, weight: .black))
                    .foregroundStyle(product.color)
                    .frame(width: 52, height: 52)

                VStack(alignment: .leading, spacing: 4) {
                    Text(product.badge)
                        .font(
                            .system(
                                size: 10,
                                weight: .black,
                                design: .monospaced
                            )
                        )
                        .foregroundStyle(product.color)

                    Text(product.title)
                        .font(
                            .system(size: 20, weight: .black, design: .rounded)
                        )
                        .foregroundStyle(.white)
                }

                Spacer()
            }

            Text(product.description)
                .font(.system(size: 13, weight: .bold, design: .rounded))
                .foregroundStyle(.white.opacity(0.68))

            Button(action: buy) {
                Text(buttonTitle)
                    .font(
                        .system(size: 13, weight: .black, design: .monospaced)
                    )
                    .frame(maxWidth: .infinity)
                    .frame(height: 44)
            }
            .buttonStyle(.borderedProminent)
            .tint(product.color)
            .disabled(isOwned || !isAvailable || isBuying)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            LinearGradient(
                colors: [
                    product.color.opacity(0.28),
                    ThemeManager.shared.currentTheme.panelColor.opacity(0.78),
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .overlay {
            RoundedRectangle(cornerRadius: 8)
                .stroke(product.color.opacity(0.72), lineWidth: 1)
        }
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }

    private var buttonTitle: String {
        if isOwned {
            return "OWNED"
        }

        if isBuying {
            return "BUYING..."
        }

        return isAvailable ? priceText : "APP STORE CONNECT NEEDED"
    }
}

private struct PremiumProductCard: View {
    let product: PremiumStoreProduct
    let priceText: String
    let isOwned: Bool
    let isAvailable: Bool
    let isBuying: Bool
    let buy: () -> Void

    var body: some View {
        Button(action: buy) {
            HStack(spacing: 12) {
                Image(systemName: product.symbol)
                    .font(.system(size: 22, weight: .black))
                    .foregroundStyle(product.color)
                    .frame(width: 34, height: 34)

                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 8) {
                        Text(product.category)
                            .font(
                                .system(
                                    size: 9,
                                    weight: .black,
                                    design: .monospaced
                                )
                            )
                            .foregroundStyle(product.color)

                        if product.isFeatured {
                            Text(product.badge)
                                .font(
                                    .system(
                                        size: 9,
                                        weight: .black,
                                        design: .monospaced
                                    )
                                )
                                .foregroundStyle(.white.opacity(0.52))
                        }
                    }

                    Text(product.title)
                        .font(
                            .system(size: 15, weight: .black, design: .rounded)
                        )
                        .foregroundStyle(.white)

                    Text(product.description)
                        .font(
                            .system(size: 11, weight: .bold, design: .rounded)
                        )
                        .foregroundStyle(.white.opacity(0.56))
                        .lineLimit(2)
                }

                Spacer()

                Text(buttonTitle)
                    .font(
                        .system(size: 10, weight: .black, design: .monospaced)
                    )
                    .foregroundStyle(product.color)
                    .multilineTextAlignment(.trailing)
                    .frame(width: 92, alignment: .trailing)
            }
        }
        .buttonStyle(.plain)
        .disabled(isOwned || !isAvailable || isBuying)
        .padding(13)
        .background(ThemeManager.shared.currentTheme.panelColor.opacity(0.56))
        .overlay {
            RoundedRectangle(cornerRadius: 8)
                .stroke(product.color.opacity(0.36), lineWidth: 1)
        }
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }

    private var buttonTitle: String {
        if isOwned {
            return "OWNED"
        }

        if isBuying {
            return "BUYING..."
        }

        return isAvailable ? priceText : "SETUP"
    }
}
