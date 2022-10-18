//
//  APIEndpoints.swift
//  GitHubSearchApp
//
//  Created by chmini on 2022/10/18.
//

import Foundation

struct APIEndpoints {
    static func searchRepo(with searchRepoRequestDTO: SearchRepoRequestDTO) -> Endpoint<SearchRepoResponseDTO> {
        return Endpoint(baseURL: "https://api.github.com/", path: "/search/repositories", queryParameter: searchRepoRequestDTO)
    }
}
