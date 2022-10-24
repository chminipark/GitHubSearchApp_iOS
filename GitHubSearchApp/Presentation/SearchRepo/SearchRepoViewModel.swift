//
//  SearchRepoViewModel.swift
//  GitHubSearchApp
//
//  Created by chmini on 2022/10/19.
//

import Foundation
import RxSwift
import RxCocoa

protocol ViewModel {
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input, disposeBag: DisposeBag) -> Output
}

class SearchRepoViewModel {
    let repoUseCase: RepoUseCase
    
    init() {
        let repoGateWay = DefaultRepoGateway()
        self.repoUseCase = DefaultRepoUseCase(repoGateWay: repoGateWay)
    }
}

extension SearchRepoViewModel: ViewModel {
    struct Input {
        let searchBarText: Driver<String>
    }
    
    struct Output {
        @Property var repoList = [MySection]()
        @Property var searchBarText = ""
    }
    
    func transform(input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        input.searchBarText
            .drive(output.$searchBarText)
            .disposed(by: disposeBag)
        
        input.searchBarText
            .asObservable()
            .withUnretained(self)
            .flatMap { (owner, text) in
                owner.repoUseCase.getRepoList(searchText: text)
            }
            .bind(to: output.$repoList)
            .disposed(by: disposeBag)
        
        return output
    }
}
