//
//  SearchRepoResponseDTO.swift
//  GitHubSearchApp
//
//  Created by chmini on 2022/10/17.
//

import Foundation

struct SearchRepoResponseDTO: Decodable {
    let totalCount: Int
    let repositories: [RepoInfoDTO]

    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case repositories = "items"
    }
}

extension SearchRepoResponseDTO {
    func toDomain() -> [Repository] {
        var repoList = [Repository]()
        self.repositories.forEach { data in
            repoList.append(Repository(name: data.repository.name))
        }
        return repoList
    }
}

struct RepoInfoDTO: Decodable {
    let repository: RepositoryDTO
}

struct RepositoryDTO: Decodable {
    let name: String
}
