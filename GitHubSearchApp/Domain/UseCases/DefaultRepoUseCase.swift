//
//  DefaultRepoUseCase.swift
//  GitHubSearchApp
//
//  Created by chmini on 2022/10/22.
//

import Foundation
import RxSwift

protocol RepoUseCase {
    func getRepoList(searchText: String, currentPage: Int, originData: [Repository]?) -> Observable<Result<[MySection], Error>>
}

class DefaultRepoUseCase: RepoUseCase {
    let repoGateWay: RepoGateWay
    var mySection = MySection(headerTitle: "mySection", items: [])
    
    init (repoGateWay: RepoGateWay) {
        self.repoGateWay = repoGateWay
    }
    
    func getRepoList(searchText: String, currentPage: Int, originData: [Repository]?) -> Observable<Result<[MySection], Error>> {
        return repoGateWay
            .fetchRepoList(with: SearchRepoRequestDTO(searchText: searchText,
                                                      currentPage: currentPage))
            .withUnretained(self)
            .map { (owner, data) -> Result<[MySection], Error> in
                switch data {
                case .success(let dto):
                    owner.mySection.items = (originData ?? []) + dto.toDomain()
                    return .success([owner.mySection])
                case .failure(let error):
                    return .failure(error)
                }
            }
    }
}
