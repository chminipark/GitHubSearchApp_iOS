//
//  SearchRepoViewModel.swift
//  GitHubSearchApp
//
//  Created by chmini on 2022/10/19.
//

import Foundation
import RxSwift

protocol ViewModel {
    associatedtype Input
    associatedtype Output
    
    func transform(_ input: Input, disposeBag: DisposeBag) -> Output
}

class SearchRepoViewModel: ViewModel {
    struct Input {
    }
    
    struct Output {
        @Property var repoList = [Repository]()
    }
    
    func transform(_ input: Input, disposeBag: DisposeBag) -> Output {
        var output = Output()
        
        return output
    }
    
}
