//
//  PurchasesManager.swift
//  AIOnboarding
//
//  Created by Евгений  on 26/05/2023.
//

import Foundation
import StoreKit

typealias PurchaseProductCompletion = (Result<Bool, Error>) -> Void

protocol PurchasesManagerProtocol {
    func purchase(_ completion: @escaping PurchaseProductCompletion)
    func restorePurchase(_ completion: @escaping PurchaseProductCompletion)
}

enum PurchaseError: Error {
   
    case purchaseInProgress
    case productNotFound
    case unknown
    
    var description: String {
        switch self {
        case .purchaseInProgress:
           return Strings.purchaseInProgress
        case .productNotFound:
            return Strings.productNotFound
        case .unknown:
            return Strings.unknownError
        }
    }
}

final class PurchasesManager: NSObject {

    // MARK: - Properties
    
    private let productIdentifiers = Set(arrayLiteral: String.productId)
    private var products: [String: SKProduct]?
    private var productPurchaseCallback: PurchaseProductCompletion?
 
    // MARK: - Lyfecycle
    
    override init() {
        super.init()
        requestProducts()
    }
   
    // MARK: - Private methods
    
    private func requestProducts() {
        let productRequest = SKProductsRequest(productIdentifiers: productIdentifiers)
        productRequest.delegate = self
        productRequest.start()
    }

    private func purchaseProduct(productId: String, completion: @escaping PurchaseProductCompletion) {
        guard productPurchaseCallback == nil else {
            completion(.failure(PurchaseError.purchaseInProgress))
            return
        }
 
        guard let product = products?[productId] else {
            /// Just to simulate a successful result
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                completion(.success(true))
                self.productPurchaseCallback = nil
            }
            ///
            
//            completion(.failure(PurchasesError.productNotFound))
            return
        }
        
        productPurchaseCallback = completion
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
    }

    private func restorePurchases(completion: @escaping PurchaseProductCompletion) {
        guard productPurchaseCallback == nil else {
            completion(.failure(PurchaseError.purchaseInProgress))
            return
        }
        
        productPurchaseCallback = completion
        SKPaymentQueue.default().restoreCompletedTransactions()
        
        /// Just to simulate a successful result
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            completion(.success(true))
            self.productPurchaseCallback = nil
        }
        ///
    }
    
}

// MARK: - SKProductsRequestDelegate

extension PurchasesManager: SKProductsRequestDelegate {
    
    func productsRequest(_ request: SKProductsRequest,
                        didReceive response: SKProductsResponse) {
        var products = [String: SKProduct]()
        for skProduct in response.products {
            products[skProduct.productIdentifier] = skProduct
        }
        self.products = products
    }

}

// MARK: - SKPaymentTransactionObserver

extension PurchasesManager: SKPaymentTransactionObserver {
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchased, .restored:
                productPurchaseCallback?(.success(true))
            case .failed:
                productPurchaseCallback?(.failure(transaction.error ?? PurchaseError.unknown))
            default:
                break
            }
        }
        productPurchaseCallback = nil
   }
    
    func paymentQueue(_ queue: SKPaymentQueue, restoreCompletedTransactionsFailedWithError error: Error) {
        productPurchaseCallback?(.failure(error))
        productPurchaseCallback = nil
    }
 
}

// MARK: - PurchasesManagerProtocol

extension PurchasesManager: PurchasesManagerProtocol {
    
    func purchase(_ completion: @escaping PurchaseProductCompletion) {
        purchaseProduct(productId: .productId, completion: completion)
    }
    
    func restorePurchase(_ completion: @escaping PurchaseProductCompletion) {
        restorePurchases(completion: completion)
    }
    
}

private extension String {
    static let productId = "Monthly-Premium"
}
