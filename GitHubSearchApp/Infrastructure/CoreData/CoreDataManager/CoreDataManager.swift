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
    static let shared = CoreDataManager()
    
    let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
    lazy var context = appDelegate?.persistentContainer.viewContext
    let modelName: String = "RepoModel"
    
    @Property var modifiedData = [String : Bool]()
    
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
    
    func saveRepo(_ repo: Repository) -> Observable<Result<Void, CoreDataError>> {
        Observable.create { [weak self] emitter in
            guard let `self` = self else {
                return Disposables.create()
            }
            
            if let context = `self`.context,
               let entity = NSEntityDescription.entity(forEntityName: `self`.modelName, in: context) {
                
                if let repoModel = NSManagedObject(entity: entity, insertInto: context) as? RepoModel {
                    repoModel.name = repo.name
                    repoModel.repoDescription = repo.description
                    repoModel.starCount = Int64(repo.starCount)
                    repoModel.urlString = repo.urlString
                    
                    `self`.contextSave { result in
                        switch result {
                        case .success:
                            emitter.onNext(.success(()))
                            `self`.addRepoInDict(key: repo.urlString, state: true)
                        case .failure(let error):
                            emitter.onNext(.failure(error))
                        }
                    }
                }
            }
            
            return Disposables.create()
        }
    }
    
    func deleteRepo(key urlString: String) -> Observable<Result<Void, CoreDataError>> {
        Observable.create { [weak self] emitter in
            guard let `self` = self else {
                return Disposables.create()
            }
            
            let fetchRequest = `self`.filteredRequest(id: urlString)
            
            do {
                if let results = try `self`.context?.fetch(fetchRequest) as? [RepoModel] {
                    if results.count != 0 {
                        `self`.context?.delete(results[0])
                        emitter.onNext(.success(()))
                        `self`.addRepoInDict(key: urlString, state: true)
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
    fileprivate func filteredRequest(id urlString: String) -> NSFetchRequest<NSFetchRequestResult> {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: modelName)
        fetchRequest.predicate = NSPredicate(format: "urlString == %@", urlString)
        return fetchRequest
    }
    
    fileprivate func contextSave(completion: ((Result<Void, CoreDataError>) -> Void)) {
        do {
            try context?.save()
            completion(.success(()))
        } catch {
            completion(.failure(.saveError(error)))
        }
    }
}

extension CoreDataManager {
    func addRepoInDict(key urlString: String, state: Bool) {
        modifiedData[urlString] = state
    }
    
    func resetDict() {
        modifiedData.removeAll()
    }
}
