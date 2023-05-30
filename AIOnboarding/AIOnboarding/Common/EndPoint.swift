//
//  EndPoint.swift
//  AIOnboarding
//
//  Created by Евгений  on 29/05/2023.
//

import Foundation

enum HTTPMethod: String {
    case get     = "GET"
    case post    = "POST"
    case put     = "PUT"
    case patch   = "PATCH"
    case delete  = "DELETE"
}

protocol EndPointType {
    var httpMethod: HTTPMethod { get }
    var baseUrl: String { get }
    var path: String { get }
    var headers: [String: String]? { get }
    var body: Data? { get }
    var parameters: [String: Any]? { get }
}

enum EndPoint {
    case receiptValidation
}

extension EndPoint: EndPointType {
   
    var urlString: String {
        return baseUrl + path
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .receiptValidation:
            return .post
        }
    }
    
    var baseUrl: String {
        switch self {
        case .receiptValidation:
            return "https://api.assist.org/"
        }
    }
    
    var path: String {
        switch self {
        case .receiptValidation:
            return "validate"
        }
    }
    var headers: [String: String]? {
        switch self {
        case .receiptValidation:
            return ["application/json" : "Content-Type"]
        }
    }
    
    var body: Data? {
        switch self {
        case .receiptValidation:
            return receipt()
        }
    }
    
    var parameters: [String : Any]? {
        switch self {
        case .receiptValidation:
            return nil
        }
    }
    
    func receipt() -> Data? {
        guard let receiptURL = Bundle.main.appStoreReceiptURL,
              let receiptData = try? Data(contentsOf: receiptURL),
              let requestbody = try? JSONEncoder().encode(receiptData)
        else {
            return nil
        }
        return requestbody
    }
    
}


