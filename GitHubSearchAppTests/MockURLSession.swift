//
//  MockURLSession.swift
//  GitHubSearchAppTests
//
//  Created by chmini on 2022/10/19.
//

import Foundation
@testable import GitHubSearchApp

class MockURLSessionDataTask: URLSessionDataTask {
    var resumeDidCall: (() -> ())?
    
    override func resume() {
        resumeDidCall?()
    }
}

class MockURLSession: URLSessionable {
    
    var isFail: Bool
    
    init(isFail: Bool) {
        self.isFail = isFail
    }
    
    var mockURLSessionDataTask: URLSessionDataTask?
    
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        let mockSessionDataTask = MockURLSessionDataTask()

        let data = MockData.searchRepoResponseDTO
        
        let successResponse = HTTPURLResponse(url: request.url!,
                                              statusCode: 200,
                                              httpVersion: nil,
                                              headerFields: nil)
        let failureResponse = HTTPURLResponse(url: request.url!,
                                              statusCode: 500,
                                              httpVersion: nil,
                                              headerFields: nil)

        if isFail {
            mockSessionDataTask.resumeDidCall = { completionHandler(nil, failureResponse, nil) }
        } else {
            mockSessionDataTask.resumeDidCall = { completionHandler(data, successResponse, nil) }
        }

        self.mockURLSessionDataTask = mockSessionDataTask
        return mockSessionDataTask
    }
}
