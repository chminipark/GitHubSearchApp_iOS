//
//  DefaultCoreDataRepoGateway.swift
//  GitHubSearchApp
//
//  Created by chmini on 2022/11/04.
//

import Foundation
import RxSwift

protocol CoreDataRepoGateway {
    func fetchRepoList() -> Observable<Result<[RepoModel], CoreDataError>>
}

struct DefaultCoreDataRepoGateway: CoreDataRepoGateway {
    func fetchRepoList() -> Observable<Result<[RepoModel], CoreDataError>> {
        return CoreDataManager.shared.fetchRepos()
    }
}
