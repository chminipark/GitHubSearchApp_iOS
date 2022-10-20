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
    
    func getRepo(with text: String) -> Single<[Repository]> {
        let searchRepoRequestDTO = SearchRepoRequestDTO(q: text)
        let endpoint = APIEndpoints.searchRepo(with: searchRepoRequestDTO)
        
        return provider.request(endpoint: endpoint)
            .map { data in
                data.toDomain()
            }
    }
}

extension SearchRepoViewModel: ViewModel {
    struct Input {
        let searchBarText: Driver<String>
    }
    
    struct Output {
        @Property var repoList = [Repository]()
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
                owner.getRepo(with: text)
            }
            .subscribe(onNext: {data in
                print(data.first?.name)
            }, onError: { error in
                if let error = error as? NetworkError {
                    print(error.description)
                } else {
                    print(error.localizedDescription)
                }
            })
            .disposed(by: disposeBag)
//            .bind(to: output.$repoList)
//            .disposed(by: disposeBag)
        
        return output
    }
    
}
