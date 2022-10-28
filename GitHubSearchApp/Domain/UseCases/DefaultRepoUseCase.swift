//
//  DefaultRepoUseCase.swift
//  GitHubSearchApp
//
//  Created by chmini on 2022/10/22.
//

import Foundation
import RxSwift

protocol RepoUseCase {
    func getRepoList(searchText: String, currentPage: Int) -> Observable<[MySection]>
}

class DefaultRepoUseCase: RepoUseCase {
    let repoGateWay: RepoGateWay
    var mySection = MySection(headerTitle: "mySection", items: [])
    
    init (repoGateWay: RepoGateWay) {
        self.repoGateWay = repoGateWay
    }
    
    func getRepoList(searchText: String, currentPage: Int) -> Observable<[MySection]> {
        return repoGateWay
            .fetchRepoList(with: SearchRepoRequestDTO(searchText: searchText,
                                                      currentPage: currentPage))
            .asObservable()
            .withUnretained(self)
            .map { (owner, data) -> [MySection] in
                owner.mySection.items = data.toDomain()
                return [owner.mySection]
            }
    }
}
