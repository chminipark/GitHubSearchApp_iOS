//
//  NetworkError.swift
//  GitHubSearchApp
//
//  Created by chmini on 2022/10/17.
//

import Foundation

enum NetworkError: Error {
    case urlComponentError
    case queryEncodingError
    case makeURLError
    case responseError(Error)
    case unknownError(Error)
    case statusCodeError(Int)
    
    var description: String {
        let base = "😡😡😡😡😡"
        switch self {
        case .urlComponentError:
            return base + "urlComponentError"
        case .queryEncodingError:
            return base + "queryEncodingError"
        case .makeURLError:
            return base + "makeURLError"
        case .responseError(let error):
            return base + "responseError : \(error.localizedDescription)"
        case .unknownError(let error):
            return base + "unknownError : \(error.localizedDescription)"
        case .statusCodeError(let code):
            return base + "statusCodeError : \(code)"
        }
    }
}
