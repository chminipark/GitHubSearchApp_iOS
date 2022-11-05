//
//  Repository.swift
//  GitHubSearchApp
//
//  Created by chmini on 2022/10/17.
//

import Foundation
import Differentiator

struct Repository: IdentifiableType, Equatable {
    let id: UUID
    let name: String
    let description: String
    let starCount: Int
    let urlString: String
    
    init(id: UUID = UUID(),
         name: String,
         description: String,
         starCount: Int,
         urlString: String) {
        self.id = id
        self.name = name
        self.description = description
        self.starCount = starCount
        self.urlString = urlString
    }
    
    var identity: UUID {
        return id
    }
}
