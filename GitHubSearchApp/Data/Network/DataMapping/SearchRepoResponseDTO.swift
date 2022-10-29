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
    
    init(from decoder: Decoder) throws {
        let value = try decoder.container(keyedBy: CodingKeys.self)
        totalCount = (try? value.decode(Int.self, forKey: .totalCount)) ?? 0
        repositoryDTOList = (try? value.decode([RepositoryDTO].self, forKey: .repositoryDTOList)) ?? []
    }
}

extension SearchRepoResponseDTO {
    func toDomain() -> [Repository] {
        var repoList = [Repository]()
        self.repositoryDTOList.forEach { repo in
            repoList.append(
                Repository(name: repo.name,
                           description: repo.description,
                           starCount: repo.starCount,
                           urlString: repo.urlString)
            )
        }
        return repoList
    }
}

struct RepositoryDTO: Decodable {
    let name: String
    let description: String
    let starCount: Int
    let urlString: String
    
    enum CodingKeys: String, CodingKey {
        case name
        case description
        case starCount = "stargazers_count"
        case urlString = "html_url"
    }
    
    init(from decoder: Decoder) throws {
        let value = try decoder.container(keyedBy: CodingKeys.self)
        name = (try? value.decode(String.self, forKey: .name)) ?? ""
        description = (try? value.decode(String.self, forKey: .description)) ?? ""
        starCount = (try? value.decode(Int.self, forKey: .starCount)) ?? 0
        urlString = (try? value.decode(String.self, forKey: .urlString)) ?? ""
    }
}
