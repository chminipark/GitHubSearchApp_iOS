//
//  Endpoint.swift
//  GitHubSearchApp
//
//  Created by chmini on 2022/10/17.
//

import Foundation

protocol RequestResponsable: Requestable, Responsable {}

struct Endpoint<R>: RequestResponsable {
    typealias Response = R
    
    var baseURL: String
    var path: String
    var queryParameter: Encodable
    
    init(baseURL: String,
         path: String,
         queryParameter: Encodable) {
        self.baseURL = baseURL
        self.path = path
        self.queryParameter = queryParameter
    }
}
