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
    @nonobjc public class func fetchRequest() -> NSFetchRequest<RepoModel> {
        return NSFetchRequest<RepoModel>(entityName: "RepoModel")
    }

    @NSManaged public var urlString: String?
    @NSManaged public var starCount: Int64
    @NSManaged public var repoDescription: String?
    @NSManaged public var name: String?
    @NSManaged public var id: UUID?
}

extension RepoModel : Identifiable {}
