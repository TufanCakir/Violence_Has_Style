//
//  StoreKitManager.swift
//  Violence Has Style
//
//  Created by Tufan Cakir on 31.05.26.
//

import Foundation
import Observation
import StoreKit

@MainActor
@Observable
final class StoreKitManager {
    static let shared = StoreKitManager()

    private(set) var productsById: [String: Product] = [:]
    private(set) var isLoading = false
    private(set) var statusMessage = "STORE READY"

    private init() {}

    func loadProducts(for definitions: [PremiumStoreProduct]) async {
        let productIds = Set(definitions.map(\.productId))
        guard !productIds.isEmpty else { return }

        isLoading = true
        defer { isLoading = false }

        do {
            let products = try await Product.products(for: Array(productIds))
            productsById = Dictionary(
                uniqueKeysWithValues: products.map { ($0.id, $0) }
            )
            statusMessage =
                products.isEmpty
                ? "STORE PRODUCTS NOT FOUND"
                : "STORE PRODUCTS LOADED"
        } catch {
            statusMessage = "STORE UNAVAILABLE"
        }
    }

    func displayPrice(for definition: PremiumStoreProduct) -> String {
        productsById[definition.productId]?.displayPrice ?? definition.priceText
    }

    func canPurchase(_ definition: PremiumStoreProduct) -> Bool {
        productsById[definition.productId] != nil
    }

    func purchase(_ definition: PremiumStoreProduct) async
        -> StorePurchaseResult
    {
        guard let product = productsById[definition.productId] else {
            statusMessage = "PRODUCT NOT AVAILABLE"
            return .failed
        }

        do {
            let result = try await product.purchase()

            switch result {
            case .success(let verification):
                let transaction = try checkVerified(verification)
                await transaction.finish()
                statusMessage = "PURCHASE UNLOCKED"
                return .purchased(transaction.productID)
            case .userCancelled:
                statusMessage = "PURCHASE CANCELLED"
                return .cancelled
            case .pending:
                statusMessage = "PURCHASE PENDING"
                return .pending
            @unknown default:
                statusMessage = "PURCHASE FAILED"
                return .failed
            }
        } catch {
            statusMessage = "PURCHASE FAILED"
            return .failed
        }
    }

    func restorePurchases() async -> StorePurchaseResult {
        var restoredProductIds: [String] = []

        for await result in Transaction.currentEntitlements {
            if let transaction = try? checkVerified(result) {
                restoredProductIds.append(transaction.productID)
            }
        }

        statusMessage =
            restoredProductIds.isEmpty
            ? "NO PURCHASES FOUND" : "PURCHASES RESTORED"
        return .restored(restoredProductIds)
    }

    private func checkVerified<T>(
        _ result: VerificationResult<T>
    ) throws -> T {
        switch result {
        case .verified(let safe):
            return safe
        case .unverified:
            throw StoreKitError.failedVerification
        }
    }
}

enum StorePurchaseResult {
    case purchased(String)
    case restored([String])
    case pending
    case cancelled
    case failed
}

enum StoreKitError: Error {
    case failedVerification
}
