//
//  BaseAPI.swift
//  AIOnboarding
//
//  Created by Евгений  on 29/05/2023.
//

import Foundation

typealias RecieptValidationCompletion = (Result<Bool, Error>) -> Void

enum NetworkError: Error {
    case failedResponse
    case failedDecoding
    case invalidUrl
    case invalidData
    
    var description: String {
        switch self {
        case .failedResponse:
            return Strings.failedResponse
        case .failedDecoding:
            return Strings.failedDecoding
        case .invalidUrl:
            return Strings.invalidUrl
        case .invalidData:
            return Strings.invalidData
        }
    }
}

class BaseAPIClient {
    func execute<T: Decodable>(request: URLRequest, completion: @escaping (Result<T, NetworkError>) -> Void) {
        URLSession.shared.dataTask(with: request) { data, urlResponse, error in
            // 1 check the response
            guard let urlResponse = urlResponse as? HTTPURLResponse, (200...299).contains(urlResponse.statusCode) else {
                completion(.failure(.failedResponse))
                return
            }
            // 2 check the data
            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }
            // 3 Decode the data
            do {
                let decodedData = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodedData))
            } catch {
                completion(.failure(.failedDecoding))
            }
        }
        .resume()
    }
}
