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

enum APIEndpoints {
    case searchRepo(text: String)
}



extension APIEndpoints {
    var baseURL: String {
        switch self {
        default:
            return "https://api.github.com/"
        }
    }
    
    var path: String {
        switch self {
        case .searchRepo:
            return "/search/repositories"
        }
    }
    
    var queryParameter: Encodable {
        switch self {
        case .searchRepo(let text):
            return SearchRepoRequestDTO(q: text)
        }
    }
    
    var responseType: Decodable.Type {
        switch self {
        case .searchRepo:
            return SearchRepoResponseDTO.self
        }
    }
}

struct End<Info> {
    
}


//extension APIEndpoints {
//
//    func getEndpoint() -> Endpoint<> {
//        let type = responseType
//        return Endpoint(baseURL: baseURL, path: path, queryParameter: queryParameter)
//    }
//}
//
//struct End {
//
//    let e: APIEndpoints
//
//    init(e: APIEndpoints) {
//        self.e = e
//    }
//
//    func getEndpoint() -> Endpoint<R> {
//        return Endpoint<e.reponsetype>(baseURL: e.baseURL, path: e.path, queryParameter: e.queryParameter)
//    }
//
//}
