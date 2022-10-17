//
//  NetworkError.swift
//  GitHubSearchApp
//
//  Created by chmini on 2022/10/17.
//

import Foundation

enum NetworkError: String, Error {
    case urlComponentError
    case queryEncodingError
    case makeURLError
    
    var description: String {
        "😡😡😡😡😡" + self.rawValue
    }
}
