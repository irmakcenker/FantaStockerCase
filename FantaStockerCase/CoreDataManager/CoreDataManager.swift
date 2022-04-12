//
//  CoreDataManager.swift
//  FantaStockerCase
//
//  Created by cenker.irmak on 8.04.2022.
//

import Foundation
import UIKit
import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    private init() {}
    
    
    private lazy var persistentContainer: NSPersistentContainer = {

        let container = NSPersistentContainer(name: "FantaStockerCase")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    
    var mainContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func saveContext() {

        if mainContext.hasChanges {
            do {
                try mainContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func getSavedUser() -> User? {
        return try? mainContext.fetch(SavedUser.fetchRequest()).first?.user
    }
    
    func getPosts() -> [Post]? {
        return try? mainContext.fetch(Post.fetchRequest())
    }
    
    func backgroundContext() -> NSManagedObjectContext {
        return persistentContainer.newBackgroundContext()
    }
}
