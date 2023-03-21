//
//  DefaultRepoUseCase.swift
//  GitHubSearchApp
//
//  Created by chmini on 2022/10/22.
//

import Foundation
import RxSwift

protocol APIRepoUseCase {
  func getSearchRepoList(searchText: String,
                         currentPage: Int,
                         originData: [Repository]?)
  -> Observable<Result<[MySection], NetworkError>>
}

class DefaultAPIRepoUseCase: APIRepoUseCase {
  let apiRepoGateway: APIRepoGateWay
  let coreDataRepoGateWay: CoreDataRepoGateway
  var mySection = MySection(headerTitle: "mySection", items: [])
  
  @Property var localData = Set<Repository>()
  let disposeBag = DisposeBag()
  
  init(apiRepoGateway: APIRepoGateWay,
       coreDataRepoGateWay: CoreDataRepoGateway) {
    self.apiRepoGateway = apiRepoGateway
    self.coreDataRepoGateWay = coreDataRepoGateWay
    
    Observable.just(())
      .flatMapLatest { _ in
        coreDataRepoGateWay.fetchRepoList()
      }
      .map { result -> Set<Repository> in
        switch result {
        case .success(let repoModelList):
          var repoSet = Set<Repository>()
          repoModelList.forEach { repo in
            if let repo = repo.toDomain() {
              repoSet.insert(repo)
            }
          }
          return repoSet
        case .failure(let error):
          print(error.description)
          return Set<Repository>()
        }
      }
      .bind(to: $localData)
      .disposed(by: disposeBag)
    
    ApplicationNotificationCenter.dataDidChange
      .addObserver()
      .flatMapLatest { _ in
        coreDataRepoGateWay.fetchRepoList()
      }
      .map { result -> Set<Repository> in
        switch result {
        case .success(let repoModelList):
          var repoSet = Set<Repository>()
          repoModelList.forEach { repo in
            if let repo = repo.toDomain() {
              repoSet.insert(repo)
            }
          }
          return repoSet
        case .failure(let error):
          print(error.description)
          return Set<Repository>()
        }
      }
      .bind(to: $localData)
      .disposed(by: disposeBag)
  }
  
  func getSearchRepoList(searchText: String,
                         currentPage: Int,
                         originData: [Repository]?)
  -> Observable<Result<[MySection], NetworkError>> {
    return apiRepoGateway
      .fetchRepoList(with: SearchRepoRequestDTO(searchText: searchText,
                                                currentPage: currentPage))
      .withUnretained(self)
      .map { (owner, result) -> Result<[MySection], NetworkError> in
        switch result {
        case .success(let dto):
          let localData = owner.localData
          let newData = owner.checkResultInLocalData(localData: localData,
                                                     fetchedData: dto.toDomain())
          owner.mySection.items = (originData ?? []) + newData
          return .success([owner.mySection])
        case .failure(let error):
          return .failure(error)
        }
      }
  }
}

extension DefaultAPIRepoUseCase {
  func checkResultInLocalData(localData: Set<Repository>,
                              fetchedData: [Repository]) -> [Repository] {
    if localData.isEmpty {
      return fetchedData
    }
    
    let localURLSet = Set(localData.map { $0.urlString })
    
    var repoList = fetchedData
    for (index, repo) in fetchedData.enumerated() {
      if localURLSet.contains(repo.urlString) {
        repoList[index].isStore = true
      } else {
        repoList[index].isStore = false
      }
    }
    return repoList
  }
}
