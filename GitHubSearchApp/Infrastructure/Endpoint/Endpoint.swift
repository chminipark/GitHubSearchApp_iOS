//
//  Endpoint.swift
//  GitHubSearchApp
//
//  Created by chmini on 2022/10/17.
//

import Foundation

struct Endpoint: Requestable {
    var baseURL: String
    var path: String
    var queryParameter: QueryParameter
    
    init(baseURL: String,
         path: String,
         queryParameter: QueryParameter) {
        self.baseURL = baseURL
        self.path = path
        self.queryParameter = queryParameter
    }
}
