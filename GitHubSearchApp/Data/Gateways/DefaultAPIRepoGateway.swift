//
//  DefaultAPIRepoGateway.swift
//  GitHubSearchApp
//
//  Created by chmini on 2022/10/22.
//

import Foundation
import RxSwift

protocol APIRepoGateWay {
    func fetchRepoList(with searchRepoRequestDTO: SearchRepoRequestDTO) -> Observable<Result<SearchRepoResponseDTO, NetworkError>>
}

struct DefaultAPIRepoGateway: APIRepoGateWay {
    func fetchRepoList(with searchRepoRequestDTO: SearchRepoRequestDTO) -> Observable<Result<SearchRepoResponseDTO, NetworkError>> {
        let endpoint = APIEndpoints.searchRepo(with: searchRepoRequestDTO)
        return ProviderImpl.shared.request(endpoint: endpoint)
    }
}
