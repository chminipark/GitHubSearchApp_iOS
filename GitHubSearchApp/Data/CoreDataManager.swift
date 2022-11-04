//
//  CoreDataManager.swift
//  GitHubSearchApp
//
//  Created by chmini on 2022/11/04.
//

import UIKit
import CoreData
import RxSwift

class CoreDataManager {
    static let shared: CoreDataManager = CoreDataManager()
    
    let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
    lazy var context = appDelegate?.persistentContainer.viewContext
    
    let modelName: String = "RepoModel"
    
    func getRepos(ascending: Bool = false) -> [RepoModel] {
        var models: [RepoModel] = [RepoModel]()
        
        if let context = context {
            let starCountSort = NSSortDescriptor(key: "starCount", ascending: ascending)
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: modelName)
            fetchRequest.sortDescriptors = [starCountSort]
            
            do {
                if let fetchResult = try context.fetch(fetchRequest) as? [RepoModel] {
                    models = fetchResult
                }
            } catch let error as NSError {
                print("Could not fetch🥺: \(error), \(error.userInfo)")
            }
        }
        return models
    }
    
    func saveRepo(_ repo: Repository,
                  onSuccess: @escaping ((Bool) -> Void)) {
        if let context = context,
            let entity = NSEntityDescription.entity(forEntityName: modelName, in: context) {
            
            if let repoModel = NSManagedObject(entity: entity, insertInto: context) as? RepoModel {
                
                repoModel.id = repo.id
                repoModel.name = repo.name
                repoModel.repoDescription = repo.description
                repoModel.starCount = Int16(repo.starCount)
                repoModel.urlString = repo.urlString
                
                contextSave { success in
                    onSuccess(success)
                }
            }
        }
    }
    
    func deleteRepo(id: UUID, onSuccess: @escaping ((Bool) -> Void)) {
        let fetchRequest = filteredRequest(id: id)
        
        do {
            if let results = try context?.fetch(fetchRequest) as? [RepoModel] {
                if results.count != 0 {
                    context?.delete(results[0])
                }
            }
        } catch let error as NSError {
            print("Could not fatch🥺: \(error), \(error.userInfo)")
            onSuccess(false)
        }
        
        contextSave { success in
            onSuccess(success)
        }
    }
}

extension CoreDataManager {
    fileprivate func filteredRequest(id: UUID) -> NSFetchRequest<NSFetchRequestResult> {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: modelName)
        fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        return fetchRequest
    }
    
    fileprivate func contextSave(onSuccess: ((Bool) -> Void)) {
        do {
            try context?.save()
            onSuccess(true)
        } catch let error as NSError {
            print("Could not save🥶: \(error), \(error.userInfo)")
            onSuccess(false)
        }
    }
}
