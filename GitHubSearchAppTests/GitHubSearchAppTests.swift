//
//  GitHubSearchAppTests.swift
//  GitHubSearchAppTests
//
//  Created by chmini on 2022/10/17.
//

import XCTest
@testable import GitHubSearchApp
import RxSwift

//
//protocol Provider {
//    func request<E: RequestResponsable, R: Decodable>(endpoint: E) -> Single<Result<>> where E.Response == R
//}
//
//class ProviderImpl: Provider {
//
//    let session = URLSession.shared
//
//    func request<E: RequestResponsable, R: Decodable>(endpoint: E) -> Single<R> where E.Response == R {
//
//        do {
//            let urlRequest = try endpoint.makeURLRequest()
//        } catch {
//            return .create { emitter in
//                emitter(.)
//            }
//        }
//
//        return Single.create { emitter in
//
//            return Disposables.create()
//        }
//    }
//}

class GitHubSearchAppTests: XCTestCase {
    

}
