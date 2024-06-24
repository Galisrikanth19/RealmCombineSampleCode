//
//  ApiClientService.swift
//  Created by GaliSrikanth on 22/06/24.

import Foundation
import Combine

protocol ApiClientUseCase {
    func fetchData() -> AnyPublisher<[PostModel], NetworkError>
}

class ApiClientService: ApiClientUseCase {
    let networkManager: NetworkManager

    init(networkManager: NetworkManager = NetworkManager.shared) {
        self.networkManager = networkManager
    }
    
    func fetchData() -> AnyPublisher<[PostModel], NetworkError> {
        networkManager.request(urlString: ApiEndPoints.posts.endPoint)
    }
}
