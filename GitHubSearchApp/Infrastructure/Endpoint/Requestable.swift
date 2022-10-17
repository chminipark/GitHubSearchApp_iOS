//
//  Requestable.swift
//  GitHubSearchApp
//
//  Created by chmini on 2022/10/17.
//

import Foundation

protocol Requestable {
    var baseURL: String { get }
    var path: String { get }
    var queryParameter: Encodable { get }
}

extension Requestable {
    func makeURLRequest() throws -> URLRequest {
        let urlString = baseURL + path
        guard var urlComponent = URLComponents(string: urlString) else {
            throw NetworkError.urlComponentError
        }
        
        guard let queryDictionary = try? queryParameter.toDictionary() else {
            throw NetworkError.queryEncodingError
        }
        
        var queryItemList = [URLQueryItem]()
        queryDictionary.forEach { (key, value) in
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            queryItemList.append(queryItem)
        }
        
        if !queryItemList.isEmpty {
            urlComponent.queryItems = queryItemList
        }
        
        guard let url = urlComponent.url else {
            throw NetworkError.makeURLError
        }
        
        return URLRequest(url: url)
    }
}

extension Encodable {
    func toDictionary() throws -> [String : Any] {
        let data = try JSONEncoder().encode(self)
        let jsonObject = try JSONSerialization.jsonObject(with: data)
        return jsonObject as! [String : Any]
    }
}
