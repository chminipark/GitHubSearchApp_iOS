//
//  Repository.swift
//  GitHubSearchApp
//
//  Created by chmini on 2022/10/17.
//

import Foundation
import Differentiator

struct Repository: IdentifiableType, Equatable {
    var id = UUID()
    let name: String
    let description: String
    let starCount: Int
    let urlString: String
    
    var identity: UUID {
        return id
    }
}
