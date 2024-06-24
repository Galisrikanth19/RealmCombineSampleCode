//
//  NetworkError.swift
//  Created by GaliSrikanth on 23/06/24.

import Foundation

enum NetworkError: Error {
    case invalidURL
    case requestFailed(Error)
    case invalidResponse
    case decodingFailed(Error)
}
