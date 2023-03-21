//
//  DefaultCoreDataRepoUseCase.swift
//  GitHubSearchApp
//
//  Created by chmini on 2022/11/04.
//

import Foundation
import RxSwift

protocol CoreDataRepoUseCase {
  func getFavoriteRepoList() -> Observable<Result<[MySection], CoreDataError>>
}

class DefaultCoreDataRepoUseCase: CoreDataRepoUseCase {
  let coreDataRepoGateway: CoreDataRepoGateway
  var mySection = MySection(headerTitle: "mySection", items: [])
  
  init (coreDataRepoGateway: CoreDataRepoGateway) {
    self.coreDataRepoGateway = coreDataRepoGateway
  }
  
  func getFavoriteRepoList() -> Observable<Result<[MySection], CoreDataError>> {
    return coreDataRepoGateway
      .fetchRepoList()
      .withUnretained(self)
      .map { (owner, data) -> Result<[MySection], CoreDataError> in
        switch data {
        case .success(let repoModel):
          var repoList = [Repository]()
          repoModel.forEach { repo in
            if let repo = repo.toDomain() {
              repoList.append(repo)
            }
          }
          owner.mySection.items = repoList
          return .success([owner.mySection])
        case .failure(let error):
          return .failure(error)
        }
      }
  }
}
