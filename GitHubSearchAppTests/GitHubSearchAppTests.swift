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
}
