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
    
    func transform(_ input: Input, disposeBag: DisposeBag) -> Output
}

class SearchRepoViewModel: ViewModel {
    struct Input {
        let searchBarText: Driver<String>
    }
    
    struct Output {
//        @Property var repoList = [Repository]()
        @Property var searchBarText = ""
    }
    
    func transform(_ input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        input.searchBarText
            .drive(output.$searchBarText)
            .disposed(by: disposeBag)
        
        return output
    }
    
}
