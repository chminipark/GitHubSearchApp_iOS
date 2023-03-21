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
  let disposeBag = DisposeBag()
  
  var mySection = MySection(headerTitle: "mySection", items: [])
  @Property var localData = Set<Repository>()
  
  init() {
    let apiRepoGateway = DefaultAPIRepoGateway()
    let coreDataRepoGateWay = DefaultCoreDataRepoGateway()
    
    self.apiRepoUseCase = DefaultAPIRepoUseCase(apiRepoGateway: apiRepoGateway,
                                                coreDataRepoGateWay: coreDataRepoGateWay)
    
    Observable.just(())
      .flatMapLatest { _ in
        coreDataRepoGateWay.fetchRepoList()
      }
      .map { result -> Set<Repository> in
        switch result {
        case .success(let repoModelList):
          var repoSet = Set<Repository>()
          repoModelList.forEach { repo in
            if let repo = repo.toDomain() {
              repoSet.insert(repo)
            }
          }
          return repoSet
        case .failure(let error):
          print(error.description)
          return Set<Repository>()
        }
      }
      .bind(to: $localData)
      .disposed(by: disposeBag)
    
    ApplicationNotificationCenter.dataDidChange
      .addObserver()
      .flatMapLatest { _ in
        coreDataRepoGateWay.fetchRepoList()
      }
      .map { result -> Set<Repository> in
        switch result {
        case .success(let repoModelList):
          var repoSet = Set<Repository>()
          repoModelList.forEach { repo in
            if let repo = repo.toDomain() {
              repoSet.insert(repo)
            }
          }
          print("LocalData : \(repoSet.count)")
          return repoSet
        case .failure(let error):
          print(error.description)
          return Set<Repository>()
        }
      }
      .bind(to: $localData)
      .disposed(by: disposeBag)
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
        return owner.apiRepoUseCase.getSearchRepoList(searchText: text,
                                                      currentPage: 1,
                                                      originData: nil)
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
        owner.mySection = mySection.first!
        return mySection
      }
      .bind(to: output.$repoList)
      .disposed(by: disposeBag)
    
    pagination
      .withUnretained(self)
      .filter { (owner, _) -> Bool in
        return owner.checkPagination()
      }
      .flatMap { (owner, _) -> Observable<Result<[MySection], NetworkError>> in
        owner.setPaginationFetching()
        let originData = owner.mySection.items as Array<Repository>
        return owner.apiRepoUseCase.getSearchRepoList(searchText: owner.searchText,
                                                      currentPage: owner.currentPage,
                                                      originData: originData)
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
        owner.mySection = mySection.first!
        return mySection
      }
      .bind(to: output.$repoList)
      .disposed(by: disposeBag)
    
    input.viewWillAppear
      .withUnretained(self)
      .filter { (owner, _) -> Bool in
        return !owner.localData.isEmpty
      }
      .map { (owner, _) -> [MySection] in
        let localData = owner.localData
        let fetchedData = owner.mySection.items as [Repository]
        let newData = owner.checkResultInLocalData(localData: localData,
                                                   fetchedData: fetchedData)
        owner.mySection.items = newData
        print("😈 SearchRepoViewModel : ViewWillAppear!")
        return [owner.mySection]
      }
      .bind(to: output.$repoList)
      .disposed(by: disposeBag)
    
    return output
  }
}

// CoreData
extension SearchRepoViewModel {
  func checkResultInLocalData(localData: Set<Repository>,
                              fetchedData: [Repository]) -> [Repository] {
    if localData.isEmpty {
      return fetchedData
    }
    
    let localURLSet = Set(localData.map { $0.urlString })
    
    var repoList = fetchedData
    for (index, repo) in fetchedData.enumerated() {
      if localURLSet.contains(repo.urlString) {
        repoList[index].isStore = true
      } else {
        repoList[index].isStore = false
      }
    }
    return repoList
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
  
  func checkPagination() -> Bool {
    let originData = mySection.items as Array<Repository>
    if searchText == "" || viewState == .isLoading || originData.isEmpty {
      return false
    }
    
    return true
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
