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
    case invalidReceipt
    case unknown
    
    var description: String {
        switch self {
        case .purchaseInProgress:
            return Strings.purchaseInProgress
        case .productNotFound:
            return Strings.productNotFound
        case .invalidReceipt:
            return Strings.badReceipt
        case .unknown:
            return Strings.unknownError
        }
    }
}

enum Product: String {
    case month = "com.assist.monthly"
}

final class PurchasesManager: NSObject {
    
    // MARK: - Properties
    
    private var products: [String: SKProduct]?
    private var productPurchaseCallback: PurchaseProductCompletion?
    private let paymentQueue = SKPaymentQueue.default()
    
    // MARK: - Lyfecycle
    
    override init() {
        super.init()
        requestProducts()
    }
    
    // MARK: - Private methods
    
    private func requestProducts() {
        paymentQueue.add(self)
        let productRequest = SKProductsRequest(productIdentifiers: [Product.month.rawValue])
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
//                        completion(.failure(PurchaseError.productNotFound))
            return
        }
        
        productPurchaseCallback = completion
        let payment = SKPayment(product: product)
        paymentQueue.add(payment)
    }
    
    private func restorePurchases(completion: @escaping PurchaseProductCompletion) {
        guard productPurchaseCallback == nil else {
            completion(.failure(PurchaseError.purchaseInProgress))
            return
        }
        
        productPurchaseCallback = completion
        paymentQueue.restoreCompletedTransactions()
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
            case .purchasing: break
            case .purchased, .restored:
                queue.finishTransaction(transaction)
                productPurchaseCallback?(.success(true))
            case .failed:
                queue.finishTransaction(transaction)
                productPurchaseCallback?(.failure(transaction.error ?? PurchaseError.unknown))
            default:
                queue.finishTransaction(transaction)
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
        purchaseProduct(productId: Product.month.rawValue, completion: completion)
    }
    
    func restorePurchase(_ completion: @escaping PurchaseProductCompletion) {
        restorePurchases(completion: completion)
    }
    
}
