//
//  ApiEndPoints.swift
//  Created by GaliSrikanth on 23/06/24.

import Foundation

struct BaseUrls {
    static let baseUrl = "https://jsonplaceholder.typicode.com/"
}

enum ApiEndPoints: String {
    case posts = "posts"
    
    var endPoint: String {
        return BaseUrls.baseUrl + self.rawValue
    }
}
