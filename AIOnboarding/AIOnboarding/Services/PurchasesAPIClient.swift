//
//  PurchasesAPIClient.swift
//  AIOnboarding
//
//  Created by Евгений  on 30/05/2023.
//

import Foundation

protocol PurchasesAPIClient {
    func requestReceiptValidation(endpoint: EndPoint, completion: @escaping RecieptValidationCompletion)
}

final class DefaultPurchasesAPIClient: BaseAPIClient, PurchasesAPIClient {
    
    func requestReceiptValidation(endpoint: EndPoint, completion: @escaping RecieptValidationCompletion) {
        guard let url = URL(string: endpoint.urlString) else {
            return completion(.failure(NetworkError.invalidUrl))
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.httpMethod.rawValue
        request.httpBody = endpoint.body
        request.allHTTPHeaderFields = endpoint.headers
        
        execute(request: request) { (result: Result<AppStoreValidationResult, NetworkError>) in
            switch result {
            case .success(let success):
                switch(success.status) {
                    /// Simulated valid reciept status == 0
                case 0:
                    completion(.success(true))
                default:
                    completion(.failure(PurchaseError.invalidReceipt))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
}
