//
//  RepoModel+CoreDataProperties.swift
//  GitHubSearchApp
//
//  Created by chmini on 2022/11/04.
//
//

import Foundation
import CoreData

extension RepoModel {
    @NSManaged public var urlString: String?
    @NSManaged public var starCount: Int64
    @NSManaged public var repoDescription: String?
    @NSManaged public var name: String?
}

extension RepoModel : Identifiable {}

extension RepoModel {
    func toDomain() -> Repository? {
        guard let name = name,
              let description = repoDescription,
              let urlString = urlString
        else {
            return nil
        }
        let starCount = Int(starCount)
        
        return Repository(
            name: name,
            description: description,
            starCount: starCount,
            urlString: urlString)
    }
}
