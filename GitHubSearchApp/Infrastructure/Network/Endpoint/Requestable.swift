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
        guard var urlComponent = URLComponents(string: baseURL) else {
            throw URLRequestError.urlComponentError
        }
        urlComponent.path = path
        
        guard let queryDictionary = try? queryParameter.toDictionary() else {
            throw URLRequestError.queryEncodingError
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
            throw URLRequestError.makeURLError
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
