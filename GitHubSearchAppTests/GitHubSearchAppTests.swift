//
//  GitHubSearchAppTests.swift
//  GitHubSearchAppTests
//
//  Created by chmini on 2022/10/17.
//

import XCTest
@testable import GitHubSearchApp
import RxSwift
import RxCocoa

protocol URLSessionable {
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}

extension URLSession: URLSessionable {}

class MockURLSessionDataTask: URLSessionDataTask {
    var resumeDidCall: (() -> ())?
    
    override func resume() {
        resumeDidCall?()
    }
}

//class MockURLSession: URLSessionable {
//
//    var isFail: Bool
//
//    init(isFail: Bool) {
//        self.isFail = isFail
//    }
//
//    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
//
//    }
//}



class GitHubSearchAppTests: XCTestCase {
    

}
