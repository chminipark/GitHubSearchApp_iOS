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
    func getRepoList(searchText: String, currentPage: Int, originData: [Repository]) -> Observable<[MySection]>
}

class DefaultRepoUseCase: RepoUseCase {
    let repoGateWay: RepoGateWay
    var mySection = MySection(headerTitle: "mySection", items: [])
    
    init (repoGateWay: RepoGateWay) {
        self.repoGateWay = repoGateWay
    }
    
    func getRepoList(searchText: String) -> Observable<[MySection]> {
        return repoGateWay
            .fetchRepoList(with: SearchRepoRequestDTO(searchText: searchText,
                                                      currentPage: 1))
            .asObservable()
            .withUnretained(self)
            .map { (owner, data) -> [MySection] in
                owner.mySection.items = data.toDomain()
                return [owner.mySection]
            }
    }
    
    func getRepoList(searchText: String,
                     currentPage: Int,
                     originData: [Repository]) -> Observable<[MySection]> {
        return repoGateWay
            .fetchRepoList(with: SearchRepoRequestDTO(searchText: searchText,
                                                      currentPage: currentPage))
            .asObservable()
            .withUnretained(self)
            .map { (owner, data) -> [MySection] in
                owner.mySection.items = originData + data.toDomain()
                return [owner.mySection]
            }
    }
}
