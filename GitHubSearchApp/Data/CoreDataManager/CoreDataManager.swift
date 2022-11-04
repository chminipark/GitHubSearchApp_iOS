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
    
//    func getRepos(ascending: Bool = false) -> [RepoModel] {
//        var models: [RepoModel] = [RepoModel]()
//
//        if let context = context {
//            let starCountSort = NSSortDescriptor(key: "starCount", ascending: ascending)
//            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: modelName)
//            fetchRequest.sortDescriptors = [starCountSort]
//
//            do {
//                if let fetchResult = try context.fetch(fetchRequest) as? [RepoModel] {
//                    models = fetchResult
//                }
//            } catch let error as NSError {
//                print("Could not fetch🥺: \(error), \(error.userInfo)")
//            }
//        }
//        return models
//    }
    
    func fetchRepos(ascending: Bool = false) -> Observable<Result<[RepoModel], CoreDataError>> {
        Observable.create { [weak self] emitter in
            guard let `self` = self else {
                return Disposables.create()
            }
            
            if let context = `self`.context {
                let starCountSort = NSSortDescriptor(key: "starCount", ascending: ascending)
                let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: `self`.modelName)
                fetchRequest.sortDescriptors = [starCountSort]
                
                do {
                    if let fetchResult = try context.fetch(fetchRequest) as? [RepoModel] {
                        emitter.onNext(.success(fetchResult))
                    }
                } catch {
                    emitter.onNext(.failure(.fetchError(error)))
                }
            }
            
            return Disposables.create()
        }
    }
    
//    func saveRepo(_ repo: Repository,
//                  onSuccess: @escaping ((Bool) -> Void)) {
//        if let context = context,
//            let entity = NSEntityDescription.entity(forEntityName: modelName, in: context) {
//
//            if let repoModel = NSManagedObject(entity: entity, insertInto: context) as? RepoModel {
//
//                repoModel.id = repo.id
//                repoModel.name = repo.name
//                repoModel.repoDescription = repo.description
//                repoModel.starCount = Int16(repo.starCount)
//                repoModel.urlString = repo.urlString
//
//                contextSave { success in
//                    onSuccess(success)
//                }
//            }
//        }
//    }
    
    func saveRepo(_ repo: Repository) -> Observable<Result<Bool, CoreDataError>> {
        Observable.create { [weak self] emitter in
            guard let `self` = self else {
                return Disposables.create()
            }
            
            if let context = `self`.context,
               let entity = NSEntityDescription.entity(forEntityName: `self`.modelName, in: context) {
                
                if let repoModel = NSManagedObject(entity: entity, insertInto: context) as? RepoModel {
                    repoModel.id = repo.id
                    repoModel.name = repo.name
                    repoModel.repoDescription = repo.description
                    repoModel.starCount = Int64(repo.starCount)
                    repoModel.urlString = repo.urlString
                    
                    `self`.contextSave { result in
                        switch result {
                        case .success(let isSuccess):
                            emitter.onNext(.success(isSuccess))
                        case .failure(let error):
                            emitter.onNext(.failure(error))
                        }
                    }
                }
            }
            return Disposables.create()
        }
    }
    
//    func deleteRepo(id: UUID, onSuccess: @escaping ((Bool) -> Void)) {
//        let fetchRequest = filteredRequest(id: id)
//
//        do {
//            if let results = try context?.fetch(fetchRequest) as? [RepoModel] {
//                if results.count != 0 {
//                    context?.delete(results[0])
//                }
//            }
//        } catch let error as NSError {
//            print("Could not fatch🥺: \(error), \(error.userInfo)")
//            onSuccess(false)
//        }
//
//        contextSave { success in
//            onSuccess(success)
//        }
//    }
    
    func deleteRepo(id: UUID) -> Observable<Result<Bool, CoreDataError>> {
        Observable.create { [weak self] emitter in
            guard let `self` = self else {
                return Disposables.create()
            }
            
            let fetchRequest = `self`.filteredRequest(id: id)
            
            do {
                if let results = try `self`.context?.fetch(fetchRequest) as? [RepoModel] {
                    if results.count != 0 {
                        `self`.context?.delete(results[0])
                        emitter.onNext(.success(true))
                    }
                }
            } catch {
                emitter.onNext(.failure(.deleteError(error)))
            }
            
            return Disposables.create()
        }
    }
}

extension CoreDataManager {
    fileprivate func filteredRequest(id: UUID) -> NSFetchRequest<NSFetchRequestResult> {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: modelName)
        fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        return fetchRequest
    }
    
    fileprivate func contextSave(completion: ((Result<Bool, CoreDataError>) -> Void)) {
        do {
            try context?.save()
            completion(.success(true))
        } catch {
            completion(.failure(.saveError(error)))
        }
    }
    
//    fileprivate func contextSave(onSuccess: ((Bool) -> Void)) {
//        do {
//            try context?.save()
//            onSuccess(true)
//        } catch let error as NSError {
//            print("Could not save🥶: \(error), \(error.userInfo)")
//            onSuccess(false)
//        }
//    }
}
