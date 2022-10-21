//
//  Repository.swift
//  GitHubSearchApp
//
//  Created by chmini on 2022/10/17.
//

import Foundation
import Differentiator

struct Repository: IdentifiableType, Equatable {
    let id = UUID()
    let name: String
    
    var identity: UUID {
        return id
    }
}
