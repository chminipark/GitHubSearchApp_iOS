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
    let endpoint = APIEndpoints.searchRepo(with: SearchRepoRequestDTO(searchText: "", currentPage: 1))
    let observable = sut.request(endpoint: endpoint)
    
    // when
    let result = try! observable.toBlocking().first()
    
    // then
    switch result {
    case .success(let data):
      XCTAssertEqual(data.totalCount, 40)
    default:
      XCTFail()
    }
  }
  
  func test_ProviderRequestWithSearchRepo_Fail() {
    // given
    self.sut = ProviderImpl(session: MockURLSession(isFail: true))
    let endpoint = APIEndpoints.searchRepo(with: SearchRepoRequestDTO(searchText: "", currentPage: 1))
    let observable = sut.request(endpoint: endpoint)
    
    // when
    let result = try! observable.toBlocking().first()
    
    // then
    switch result {
    case .failure(let error):
      XCTAssertEqual(error.description, "😡😡😡😡😡" + "statusCodeError : 500")
    default:
      XCTFail()
    }
  }
}
