//
//  SearchRepoResponseDTO.swift
//  GitHubSearchApp
//
//  Created by chmini on 2022/10/17.
//

import Foundation

struct SearchRepoResponseDTO: Decodable {
    let totalCount: Int
    let repositoryDTOList: [RepositoryDTO]

    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case repositoryDTOList = "items"
    }
}

extension SearchRepoResponseDTO {
    func toDomain() -> [Repository] {
        var repoList = [Repository]()
        self.repositoryDTOList.forEach { repo in
            repoList.append(
                Repository(name: repo.name,
                           description: repo.description,
                           starCount: repo.starCount)
            )
        }
        return repoList
    }
}

struct RepositoryDTO: Decodable {
    let name: String
    let description: String
    let starCount: Int
    
    enum CodingKeys: String, CodingKey {
        case name
        case description
        case starCount = "stargazers_count"
    }
}
