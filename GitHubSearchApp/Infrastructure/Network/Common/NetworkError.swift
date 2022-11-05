//
//  NetworkError.swift
//  GitHubSearchApp
//
//  Created by chmini on 2022/10/17.
//

import Foundation

enum NetworkError: Error, Equatable {
    static func == (lhs: NetworkError, rhs: NetworkError) -> Bool {
        return lhs.description == rhs.description
    }

    case urlReqeustError(URLRequestError)
    case responseError(Error)
    case unknownError
    case statusCodeError(Int)
    case noDataError
    case decodingError
    case requestLimitError
    
    var description: String {
        let base = "😡😡😡😡😡"
        switch self {
        case .urlReqeustError(let urlReqeustError):
            return urlReqeustError.description
        case .responseError(let error):
            return base + "responseError : \(error.localizedDescription)"
        case .unknownError:
            return base + "unknownError"
        case .statusCodeError(let code):
            return base + "statusCodeError : \(code)"
        case .noDataError:
            return base + "noDataError"
        case .decodingError:
            return base + "decodingError"
        case .requestLimitError:
            return base + "requestLimitError"
        }
    }
}

enum URLRequestError: Error {
    case urlComponentError
    case queryEncodingError
    case makeURLError
    
    var description: String {
        let base = "😡😡😡😡😡"
        switch self {
        case .urlComponentError:
            return base + "urlComponentError"
        case .queryEncodingError:
            return base + "queryEncodingError"
        case .makeURLError:
            return base + "makeURLError"
        }
    }
}
