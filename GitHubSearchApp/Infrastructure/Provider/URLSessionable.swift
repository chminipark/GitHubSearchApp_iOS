//
//  URLSessionable.swift
//  GitHubSearchApp
//
//  Created by chmini on 2022/10/24.
//

import Foundation

protocol URLSessionable {
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}

extension URLSession: URLSessionable {}
