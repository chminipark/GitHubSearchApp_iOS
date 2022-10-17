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

struct APIEndpoints {
    static func getSearchRepoEndpoint(with searchRepoRequestDTO: SearchRepoRequestDTO) -> Endpoint<SearchRepoResponseDTO> {
        
        return Endpoint(baseURL: "https://api.github.com/",
                        path: "/search/repositories",
                        queryParameter: searchRepoRequestDTO)
    }
}

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
//        let successResult
//    }
//}


protocol Provider {
    func request<E: RequestResponsable, R: Decodable>(endpoint: E) -> Single<R> where E.Response == R
}

class ProviderImpl: Provider {
    let session = URLSession.shared

    func request<E: RequestResponsable, R: Decodable>(endpoint: E) -> Single<R> where E.Response == R {
        
        return Single.create { [weak self] emitter in
            guard let `self` = self else {
                return Disposables.create()
            }
            
            do {
                let urlRequest = try endpoint.makeURLRequest()
                
                `self`.session.dataTask(with: urlRequest) { data, response, error in
                    `self`.checkError(data: data, response: response, error: error) { result in
                        switch result {
                        case .success(let data):
                            do {
                                let decodedData = try JSONDecoder().decode(R.self, from: data)
                                emitter(.success(decodedData))
                            } catch {
                                emitter(.failure(NetworkError.decodingError))
                            }
                        case .failure(let error):
                            emitter(.failure(error))
                        }
                    }
                }
            } catch {
                emitter(.failure(error))
            }

            return Disposables.create()
        }
    }

    func checkError(data: Data?, response: URLResponse?, error: Error?, completion: @escaping (Result<Data, Error>) -> Void) {
        if let error = error {
            completion(.failure(NetworkError.responseError(error)))
            return
        }

        guard let response = response as? HTTPURLResponse else {
            completion(.failure(NetworkError.unknownError))
            return
        }

        if response.statusCode != 200 {
            completion(.failure(NetworkError.statusCodeError(response.statusCode)))
            return
        }
        
        guard let data = data else {
            completion(.failure(NetworkError.noDataError))
            return
        }

        completion(.success(data))
    }
}

class GitHubSearchAppTests: XCTestCase {
    

}