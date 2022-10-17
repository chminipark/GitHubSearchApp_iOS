//
//  Endpoint.swift
//  GitHubSearchApp
//
//  Created by chmini on 2022/10/17.
//

import Foundation

struct QueryParameter: Encodable {
    
}

protocol Requestable {
    var baseURL: String { get }
    var path: String { get }
    var queryParameter: QueryParameter { get }
}


