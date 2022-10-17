//
//  GitHubSearchAppTests.swift
//  GitHubSearchAppTests
//
//  Created by chmini on 2022/10/17.
//

import XCTest
@testable import GitHubSearchApp
import RxSwift

protocol Provider {
    func request<E: RequestResponsable, R: Decodable>(endpoint: E) -> Single<R> where E.Response == R
}

//class ProviderImpl: Provider {
//    let session = URLSession.shared
//
//    func request<E: RequestResponsable, R: Decodable>(endpoint: E) -> Single<R> where E.Response == R {
//        return Single.create { emitter in
//            do {
//                let urlRequest = try endpoint.makeURLRequest()
//                session.dataTask(with: urlRequest) { data, response, error in
//                    <#code#>
//                }
//                
//            } catch {
//                emitter(.failure(error))
//            }
//            
//            
//            return Disposables.create()
//        }
//    }
//    
//    func checkError(data: Data?, response: URLResponse?, error: Error?, completion: @escaping (Result<SearchRepoResponseDTO, Error>) -> Void) {
//        if let error = error {
//            completion(.failure(NetworkError.unknownError(error)))
//            return
//        }
//        
//        guard let response = response else {
//            completion(.failure(<#T##Error#>))
//        }
//
//        
//        
//    }
//}



class GitHubSearchAppTests: XCTestCase {
    

}
