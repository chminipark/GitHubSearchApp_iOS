//
//  SearchRepoViewModel.swift
//  GitHubSearchApp
//
//  Created by chmini on 2022/10/19.
//

import Foundation
import RxSwift
import RxCocoa

class SearchRepoViewModel {
    let repoUseCase: RepoUseCase
    var searchText: String = ""
    var currentPage: Int = 1
    
    init() {
        let repoGateWay = DefaultRepoGateway()
        self.repoUseCase = DefaultRepoUseCase(repoGateWay: repoGateWay)
    }
}

extension SearchRepoViewModel: ViewModel {
    struct Input {
        let searchBarText: Observable<String>
    }
    
    struct Output {
        @Property var repoList = [MySection]()
        @Property var searchBarText = ""
    }
    
    func transform(input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        let searchTextWithDebounce = input.searchBarText
            .debounce(RxTimeInterval.milliseconds(1500), scheduler: MainScheduler.instance)
            .filter { [weak self] text in
                guard let `self` = self else {
                    return false
                }
                return (text != "" && text != `self`.searchText)
            }
        
        searchTextWithDebounce
            .bind(to: output.$searchBarText)
            .disposed(by: disposeBag)
        
        searchTextWithDebounce
            .withUnretained(self)
            .flatMap { (owner, text) -> Observable<[MySection]> in
                owner.currentPage = 1
                owner.searchText = text
                return owner.repoUseCase.getRepoList(searchText: text, currentPage: 1)
            }
            .bind(to: output.$repoList)
            .disposed(by: disposeBag)
        
        return output
    }
}
