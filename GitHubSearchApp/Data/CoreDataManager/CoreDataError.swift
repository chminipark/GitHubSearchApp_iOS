//
//  CoreDataError.swift
//  GitHubSearchApp
//
//  Created by chmini on 2022/11/04.
//

import Foundation

enum CoreDataError: Error {
    case saveError(Error)
    case fetchError(Error)
    case deleteError(Error)
    
    var description: String {
        let base = "😡😡😡😡😡"
        switch self {
        case .saveError(let error):
            return base + "saveError : \(error.localizedDescription)"
        case .fetchError(let error):
            return base + "fetchError : \(error.localizedDescription)"
        case .deleteError(let error):
            return base + "deleteError : \(error.localizedDescription)"
        }
    }
}
