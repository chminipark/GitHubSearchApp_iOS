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
    case requestLimit
}

class SearchRepoViewModel {
    let apiRepoUseCase: APIRepoUseCase
    
    let disposeBag = DisposeBag()
    var localData = [Repository]()
    var searchText: String = ""
    var currentPage: Int = 1
    var viewState: ViewState = .idle {
        didSet {
            switch viewState {
            case .requestLimit:
                alertRequestLimit.onNext(())
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(10)) { [weak self] in
                    guard let `self` = self else {
                        return
                    }
                    `self`.viewState = .idle
                }
            default:
                break
            }
        }
    }
    
    let pagination = PublishSubject<Void>()
    let alertRequestLimit = PublishSubject<Void>()
    
    init() {
        let apiRepoGateway = DefaultAPIRepoGateway()
        self.apiRepoUseCase = DefaultAPIRepoUseCase(apiRepoGateway: apiRepoGateway)
    }
}

extension SearchRepoViewModel: ViewModelType {
    struct Input {
        let searchBarText: Observable<String>
        let viewWillAppear: Observable<Bool>
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
            .share()
        
        searchTextWithDebounce
            .bind(to: output.$searchBarText)
            .disposed(by: disposeBag)
        
        searchTextWithDebounce
            .withUnretained(self)
            .flatMap { (owner, text) -> Observable<Result<[MySection], NetworkError>> in
                owner.setFirstFetching(with: text)
                return owner.apiRepoUseCase.getSearchRepoList(searchText: text, currentPage: 1, originData: nil)
            }
            .withUnretained(self)
            .map { (owner, result) -> [MySection] in
                return owner.checkAPIResult(result)
            }
            .withUnretained(self)
            .filter { (owner, _) -> Bool in
                return owner.viewState == .isLoading
            }
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
            .flatMap { (owner, originData) -> Observable<Result<[MySection], NetworkError>> in
                owner.setPaginationFetching()
                return owner.apiRepoUseCase.getSearchRepoList(searchText: owner.searchText,
                                                     currentPage: owner.currentPage,
                                                     originData: originData!)
            }
            .withUnretained(self)
            .map { (owner, result) -> [MySection] in
                return owner.checkAPIResult(result)
            }
            .withUnretained(self)
            .filter { (owner, _) -> Bool in
                return owner.viewState == .isLoading
            }
            .map { (owner, mySection) -> [MySection] in
                owner.viewState = .idle
                return mySection
            }
            .bind(to: output.$repoList)
            .disposed(by: disposeBag)
        
        let dataChangeObservable = CoreDataManager.shared.$modifiedData
        input.viewWillAppear.withLatestFrom(dataChangeObservable)
            .map { modifiedData -> (Set<Repository>, [MySection]) in
                return (modifiedData, output.repoList)
            }
            .withUnretained(self)
            .filter { (owner, tuple) -> Bool in
                return owner.checkReloadData(modifiedData: tuple.0, mySection: tuple.1)
            }
            .map { (owner, tuple) -> [MySection] in
                let originData = tuple.1.first!.items as [Repository]
                let modifyData = Array(tuple.0)
                let newData = CoreDataManager.shared.modifyDataInOrigin(modifiyData: modifyData, originData: originData)
                var newMySection = tuple.1.first!
                newMySection.items = newData
                
                CoreDataManager.shared.modifiedData.removeAll()
                print("😋 SearchRepoViewModel : withLatestFrom!")
                return [newMySection]
            }
            .bind(to: output.$repoList)
            .disposed(by: disposeBag)
        
        return output
    }
}

// CoreData
extension SearchRepoViewModel {
    func fetchLocalData(completion: @escaping (() -> ())) {
        CoreDataManager.shared.fetchRepos()
            .subscribe(with: self, onNext: { (owner, result) in
                switch result {
                case .success(let data):
                    var repoList = [Repository]()
                    data.forEach { repo in
                        if let repo = repo.toDomain() {
                            repoList.append(repo)
                        }
                    }
                    owner.localData = repoList
                    completion()
                case .failure(let error):
                    print(error.description)
                    owner.localData = []
                    completion()
                }
            })
            .disposed(by: disposeBag)
    }
    
    func checkReloadData(modifiedData: Set<Repository>, mySection: [MySection]) -> Bool {
        guard let originData = mySection.first?.items as? [Repository],
              !modifiedData.isEmpty
        else {
            return false
        }
        
        for modified in modifiedData {
            for origin in originData {
                if modified.urlString == origin.urlString {
                    return true
                }
            }
        }
        
        return false
    }
}

// API
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
    
    func finishFetching() {
        if viewState != .requestLimit {
            viewState = .idle
        }
    }
    
    func checkAPIResult(_ result: Result<[MySection], NetworkError>) -> [MySection] {
        switch result {
        case .success(let mySection):
            return mySection
        case .failure(let error):
            if error == .requestLimitError {
                viewState = .requestLimit
                currentPage -= 1
                return []
            }
            print(error.description)
            return []
        }
    }
}
