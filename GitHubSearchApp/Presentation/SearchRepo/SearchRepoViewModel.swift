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
    let provider = ProviderImpl(session: URLSession.shared)
    
    func getRepoList(with text: String) -> Single<[MySection]> {
        let searchRepoRequestDTO = SearchRepoRequestDTO(q: text)
        let endpoint = APIEndpoints.searchRepo(with: searchRepoRequestDTO)
        var mySection = MySection(headerTitle: "mySection", items: [])
        
        return provider.request(endpoint: endpoint)
            .map { data -> [MySection] in
                mySection.items = data.toDomain()
                return [mySection]
            }
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
            .filter { $0 != "" }
            .withUnretained(self)
            .flatMapLatest { owner, text in
                owner.getRepoList(with: text)
            }
            .bind(to: output.$repoList)
            .disposed(by: disposeBag)
        
        return output
    }
}
