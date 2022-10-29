//
//  SearchRepoViewModel.swift
//  GitHubSearchApp
//
//  Created by chmini on 2022/10/19.
//

import Foundation
import RxSwift
import RxCocoa

enum ViewState {
    case idle
    case isLoading
}

class SearchRepoViewModel {
    let repoUseCase: RepoUseCase
    
    var searchText: String = ""
    var currentPage: Int = 1
    var viewState: ViewState = .idle
    
    let pagination = PublishSubject<Void>()
    
    init() {
        let repoGateWay = DefaultRepoGateway()
        self.repoUseCase = DefaultRepoUseCase(repoGateWay: repoGateWay)
    }
}

extension SearchRepoViewModel: ViewModelType {
    struct Input {
        let searchBarText: Observable<String>
    }
    
    struct Output {
        @Property var repoList = [MySection]()
        @Property var searchBarText = ""
    }
    
    func transform(input: Input, disposeBag: DisposeBag) -> Output  {
        let output = Output()
        
        let searchTextWithDebounce = input.searchBarText
            .debounce(RxTimeInterval.milliseconds(1500), scheduler: MainScheduler.instance)
            .filter { [weak self] text in
                guard let `self` = self else {
                    return false
                }
                return (text != "" && text != `self`.searchText)
            }
            .share()
        
        searchTextWithDebounce
            .bind(to: output.$searchBarText)
            .disposed(by: disposeBag)
        
        searchTextWithDebounce
            .withUnretained(self)
            .flatMap { (owner, text) -> Observable<[MySection]> in
                owner.setFirstFetching(with: text)
                return owner.repoUseCase.getRepoList(searchText: text)
            }
            .withUnretained(self)
            .map { (owner, mySection) -> [MySection] in
                owner.viewState = .idle
                return mySection
            }
            .bind(to: output.$repoList)
            .disposed(by: disposeBag)
        
        pagination
            .map { _ -> [Repository]? in
                let originData = output.repoList.first?.items as? Array<Repository>
                return originData
            }
            .withUnretained(self)
            .filter { (owner, repoList) -> Bool in
                owner.checkPagination(with: repoList)
            }
            .flatMap { (owner, originData) -> Observable<[MySection]> in
                owner.setPaginationFetching()
                return owner.repoUseCase.getRepoList(searchText: owner.searchText,
                                                     currentPage: owner.currentPage,
                                                     originData: originData!)
            }
            .withUnretained(self)
            .map { (owner, mySection) -> [MySection] in
                owner.viewState = .idle
                return mySection
            }
            .bind(to: output.$repoList)
            .disposed(by: disposeBag)
        
        return output
    }
}

extension SearchRepoViewModel {
    func setFirstFetching(with text: String) {
        viewState = .isLoading
        currentPage = 1
        searchText = text
    }
    
    func setPaginationFetching() {
        viewState = .isLoading
        currentPage += 1
    }
    
    func checkPagination(with originData: [Repository]?) -> Bool {
        if searchText == "" || viewState == .isLoading {
            return false
        }
        
        if let originData = originData {
            if !originData.isEmpty {
                return true
            }
        }
        
        return false
    }
}
