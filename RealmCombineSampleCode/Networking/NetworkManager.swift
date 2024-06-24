//
//  NetworkManager.swift
//  Created by GaliSrikanth on 23/06/24.

import Foundation
import Combine

class NetworkManager {
    static let shared = NetworkManager()
    
    private init() { }
    
    func request<T: Decodable>(urlString: String) -> AnyPublisher<T, NetworkError> {
        guard let url = URL(string: urlString) else {
            return Fail(error: NetworkError.invalidURL).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { result -> Data in
                guard let response = result.response as? HTTPURLResponse, response.statusCode == 200 else {
                    throw NetworkError.invalidResponse
                }
                print("received data")
                return result.data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError { error -> NetworkError in
                if let urlError = error as? URLError {
                    return .requestFailed(urlError)
                } else if let decodingError = error as? DecodingError {
                    return .decodingFailed(decodingError)
                } else {
                    return .invalidResponse
                }
            }
            .eraseToAnyPublisher()
    }
}
