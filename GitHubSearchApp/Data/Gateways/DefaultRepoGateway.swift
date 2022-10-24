//
//  DefaultRepoGateway.swift
//  GitHubSearchApp
//
//  Created by chmini on 2022/10/22.
//

import Foundation
import RxSwift

protocol RepoGateWay {
    func fetchRepoList(with searchRepoRequestDTO: SearchRepoRequestDTO) -> Single<SearchRepoResponseDTO>
}

struct DefaultRepoGateway: RepoGateWay {
    func fetchRepoList(with searchRepoRequestDTO: SearchRepoRequestDTO) -> Single<SearchRepoResponseDTO> {
        let endpoint = APIEndpoints.searchRepo(with: searchRepoRequestDTO)
        return ProviderImpl.shared.request(endpoint: endpoint)
    }
}
