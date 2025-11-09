//
//  PurchaseManager.swift
//  BetterBAC
//
//  Created by Cline on 11/6/25.
//

import Foundation
import StoreKit

@MainActor
class PurchaseManager: ObservableObject {
    static let shared = PurchaseManager()
    
    @Published var hasRemoveAdsPurchase = false
    @Published var isLoading = false
    @Published var purchaseError: String?
    
    private let productID = "com.betterbac.removeads"
    private var product: Product?
    private var updateListenerTask: Task<Void, Error>?
    
    private init() {
        // Start listening for transaction updates
        updateListenerTask = listenForTransactions()
        
        Task {
            await loadProducts()
            await checkPurchaseStatus()
        }
    }
    
    deinit {
        updateListenerTask?.cancel()
    }
    
    // MARK: - Load Products
    
    func loadProducts() async {
        do {
            let products = try await Product.products(for: [productID])
            if let product = products.first {
                self.product = product
                print("✅ Loaded product: \(product.displayName) - \(product.displayPrice)")
            } else {
                print("⚠️ Product not found: \(productID)")
            }
        } catch {
            print("❌ Failed to load products: \(error.localizedDescription)")
            purchaseError = "Failed to load products"
        }
    }
    
    // MARK: - Check Purchase Status
    
    func checkPurchaseStatus() async {
        var hasPurchase = false
        
        for await result in Transaction.currentEntitlements {
            if case .verified(let transaction) = result {
                if transaction.productID == productID {
                    hasPurchase = true
                    print("✅ Active purchase found")
                    break
                }
            }
        }
        
        hasRemoveAdsPurchase = hasPurchase
    }
    
    // MARK: - Purchase
    
    func purchase() async {
        guard let product = product else {
            purchaseError = "Product not available"
            return
        }
        
        isLoading = true
        purchaseError = nil
        
        do {
            let result = try await product.purchase()
            
            switch result {
            case .success(let verification):
                // Verify the transaction
                switch verification {
                case .verified(let transaction):
                    // Transaction is verified, grant access
                    hasRemoveAdsPurchase = true
                    await transaction.finish()
                    print("✅ Purchase successful!")
                    
                case .unverified(_, let error):
                    // Transaction failed verification
                    purchaseError = "Purchase verification failed"
                    print("❌ Verification failed: \(error)")
                }
                
            case .userCancelled:
                print("ℹ️ User cancelled purchase")
                
            case .pending:
                print("⏳ Purchase pending")
                purchaseError = "Purchase pending approval"
                
            @unknown default:
                print("⚠️ Unknown purchase result")
            }
        } catch {
            purchaseError = error.localizedDescription
            print("❌ Purchase error: \(error)")
        }
        
        isLoading = false
    }
    
    // MARK: - Restore Purchases
    
    func restorePurchases() async {
        isLoading = true
        purchaseError = nil
        
        do {
            try await AppStore.sync()
            await checkPurchaseStatus()
            
            if hasRemoveAdsPurchase {
                print("✅ Purchases restored successfully")
            } else {
                purchaseError = "No previous purchases found"
                print("ℹ️ No purchases to restore")
            }
        } catch {
            purchaseError = "Failed to restore purchases"
            print("❌ Restore error: \(error)")
        }
        
        isLoading = false
    }
    
    // MARK: - Offer Code Redemption
    
    @MainActor
    func presentOfferCodeRedemption() async {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            print("❌ Unable to get window scene for offer code redemption")
            return
        }

        do {
            try await AppStore.presentOfferCodeRedeemSheet(in: windowScene)
            print("📋 Presenting offer code redemption sheet")
        } catch {
            print("❌ Failed to present offer code redemption sheet: \(error)")
        }
    }
    
    // MARK: - Transaction Listener
    
    private func listenForTransactions() -> Task<Void, Error> {
        return Task.detached {
            for await result in Transaction.updates {
                do {
                    let transaction = try self.checkVerified(result)
                    
                    // Update purchase status
                    await self.checkPurchaseStatus()
                    
                    // Finish the transaction
                    await transaction.finish()
                } catch {
                    print("❌ Transaction verification failed: \(error)")
                }
            }
        }
    }
    
    private nonisolated func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .unverified:
            throw StoreError.failedVerification
        case .verified(let safe):
            return safe
        }
    }
}

// MARK: - Store Error

enum StoreError: Error {
    case failedVerification
}
