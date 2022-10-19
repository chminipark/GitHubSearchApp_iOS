//
//  GitHubSearchAppTests.swift
//  GitHubSearchAppTests
//
//  Created by chmini on 2022/10/17.
//

import XCTest
import RxSwift
import RxBlocking
@testable import GitHubSearchApp

class GitHubSearchAppTests: XCTestCase {
    var sut: Provider!
    var disposeBag: DisposeBag!

    override func setUpWithError() throws {
        self.sut = ProviderImpl(session: MockURLSession(isFail: false))
        self.disposeBag = DisposeBag()
    }

    func test_ProviderRequestWithSearchRepo_Success() {
        // given
        let endpoint = APIEndpoints.searchRepo(with: SearchRepoRequestDTO(q: ""))
        let observable = sut.request(endpoint: endpoint)

        // when
        let data = try! observable.toBlocking().first()

        // then
        XCTAssertEqual(data?.totalCount, 40)
    }
    
    func test_ProviderRequestWithSearchRepo_Fail() {
        // given
        self.sut = ProviderImpl(session: MockURLSession(isFail: true))
        let endpoint = APIEndpoints.searchRepo(with: SearchRepoRequestDTO(q: ""))
        let observable = sut.request(endpoint: endpoint)
        let expectation = XCTestExpectation()

        // when, then
        observable.subscribe(onSuccess: { data in
            XCTFail("it's fail Test, should be Fail")
        }, onFailure: { error in
            if let error = error as? NetworkError {
                XCTAssertEqual(error.description, "😡😡😡😡😡" + "statusCodeError : 500")
                expectation.fulfill()
            }
        })
        .disposed(by: disposeBag)
        
        wait(for: [expectation], timeout: 5)
    }
}
