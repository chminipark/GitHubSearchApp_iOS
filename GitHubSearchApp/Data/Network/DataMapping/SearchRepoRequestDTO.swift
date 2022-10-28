//
//  SearchRepoRequestDTO.swift
//  GitHubSearchApp
//
//  Created by chmini on 2022/10/17.
//

import Foundation

struct SearchRepoRequestDTO: Encodable {
    let searchString: String
    let perPage: Int
    let currentPage: Int
    
    enum CodingKeys: String, CodingKey {
        case searchString = "q"
        case perPage = "per_page"
        case currentPage = "page"
    }
}
