//
//  Repository.swift
//  GitHubSearchApp
//
//  Created by chmini on 2022/10/17.
//

import Foundation
import Differentiator

struct Repository: IdentifiableType, Equatable {
    let name: String
    let description: String
    let starCount: Int
    let urlString: String
    
    init(name: String,
         description: String,
         starCount: Int,
         urlString: String) {
        self.name = name
        self.description = description
        self.starCount = starCount
        self.urlString = urlString
    }
    
    var identity: String {
        return urlString
    }
}
