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
    var dataUUID: Int = 0
    
    init() {
        let coreDataRepoGateway = DefaultCoreDataRepoGateway()
        self.coreDataRepoUseCase = DefaultCoreDataRepoUseCase(coreDataRepoGateway: coreDataRepoGateway)
    }
}

extension FavoriteRepoViewModel: ViewModelType {
    struct Input {
        let viewWillAppear: Observable<Bool>
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
        
        let dataChangeObservable = CoreDataManager.shared.dataChangeObservable()
        input.viewWillAppear.withLatestFrom(dataChangeObservable)
            .withUnretained(self)
            .filter { (owner, dataUUId) -> Bool in
                owner.dataUUID != dataUUId
            }
            .subscribe(onNext: { (owner, dataUUID) in
                print("😘 withLatestFrom!")
                owner.dataUUID = dataUUID
                owner.fetchRequest.onNext(())
            })
            .disposed(by: disposeBag)
        
        return output
    }
}
