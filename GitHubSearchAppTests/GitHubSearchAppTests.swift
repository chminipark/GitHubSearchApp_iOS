//
//  GitHubSearchAppTests.swift
//  GitHubSearchAppTests
//
//  Created by chmini on 2022/10/17.
//

import XCTest
import RxSwift
@testable import GitHubSearchApp

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
//    var mockURLSessionDataTask: URLSessionDataTask?
//    
//    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
//
//        let mockSessionDataTask = MockURLSessionDataTask()
        
//        guard let url = request.url else {
//            isFail = true
//            return
//        }
                
//        let successResponse = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
//        let failureResponse = HTTPURLResponse(url: url, statusCode: 500, httpVersion: nil, headerFields: nil)
//
//        if isFail {
//            mockSessionDataTask.resumeDidCall = { completionHandler(nil, failureResponse, nil) }
//        } else {
//            mockSessionDataTask.resumeDidCall = { completionHandler(nil, successResponse, nil) }
//        }
//
//        self.mockURLSessionDataTask = mockSessionDataTask
//        return mockSessionDataTask
//    }
//}

class GitHubSearchAppTests: XCTestCase {
    
    var sut: Provider!
    
    override func setUpWithError() throws {
        
    }
    

}
