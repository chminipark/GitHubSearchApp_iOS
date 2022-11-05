//
//  FavoriteRepoViewModel.swift
//  GitHubSearchApp
//
//  Created by chmini on 2022/11/05.
//

import Foundation
import RxSwift

class FavoriteRepoViewModel {
    let coreDataRepoUseCase: DefaultCoreDataRepoUseCase
    
    let fetchRequest = PublishSubject<Void>()
    
    init() {
        let coreDataRepoGateway = DefaultCoreDataRepoGateway()
        self.coreDataRepoUseCase = DefaultCoreDataRepoUseCase(coreDataRepoGateway: coreDataRepoGateway)
    }
}

extension FavoriteRepoViewModel: ViewModelType {
    struct Input {
    }
    
    struct Output {
        @Property var repoList = [MySection]()
    }
    
    func transform(input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        fetchRequest
            .withUnretained(self)
            .flatMap { (owner, _) -> Observable<Result<[MySection], CoreDataError>> in
                return owner.coreDataRepoUseCase.getFavoriteRepoList()
            }
            .map { result -> [MySection] in
                switch result {
                case .success(let data):
                    return data
                case .failure(let error):
                    print(error.description)
                    return []
                }
            }
            .bind(to: output.$repoList)
            .disposed(by: disposeBag)
        
        return output
    }
}
