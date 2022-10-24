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
        
        searchTextWithDebounce
            .bind(to: output.$searchBarText)
            .disposed(by: disposeBag)
        
        searchTextWithDebounce
            .withUnretained(self)
            .flatMap { (owner, text) in
                owner.repoUseCase.getRepoList(searchText: text)
            }
            .bind(to: output.$repoList)
            .disposed(by: disposeBag)
        
        return output
    }
}
