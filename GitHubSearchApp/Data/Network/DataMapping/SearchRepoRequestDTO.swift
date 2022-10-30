//
//  SearchRepoRequestDTO.swift
//  GitHubSearchApp
//
//  Created by chmini on 2022/10/17.
//

import Foundation

struct SearchRepoRequestDTO: Encodable {
    let searchText: String
    let perPage: Int = 20
    let currentPage: Int
    
    enum CodingKeys: String, CodingKey {
        case searchText = "q"
        case perPage = "per_page"
        case currentPage = "page"
    }
}
