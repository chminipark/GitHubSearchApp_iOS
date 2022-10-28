//
//  DefaultRepoUseCase.swift
//  GitHubSearchApp
//
//  Created by chmini on 2022/10/22.
//

import Foundation
import RxSwift

protocol RepoUseCase {
    func getRepoList(searchText: String) -> Observable<[MySection]>
}

class DefaultRepoUseCase: RepoUseCase {
    let repoGateWay: RepoGateWay
    let searchRepoSubject = PublishSubject<String>()
    var mySection = MySection(headerTitle: "mySection", items: [])
    
    init (repoGateWay: RepoGateWay) {
        self.repoGateWay = repoGateWay
    }
    
    func getRepoList(searchText: String) -> Observable<[MySection]> {
        searchRepoSubject.onNext(searchText)
        
        return searchRepoSubject
            .filter { $0 != "" }
            .withUnretained(self)
            .flatMap { (owner, text) in
                return owner.repoGateWay
                    .fetchRepoList(with:
                                    SearchRepoRequestDTO(searchString: text,
                                                         perPage: 20,
                                                         currentPage: 1)
                    )
            }
            .withUnretained(self)
            .map { (owner, data) -> [MySection] in
                owner.mySection.items = data.toDomain()
                return [owner.mySection]
            }
    }
}
