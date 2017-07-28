//
//  SKCoredataManager.swift
//  Sudoku
//
//  Created by 宋碧海 on 2017/7/26.
//  Copyright © 2017年 songbihai. All rights reserved.
//

import UIKit
import CoreData

private let manager: SKCoredataManager = SKCoredataManager()

class SKCoredataManager {
    
    class var share: SKCoredataManager {
        return manager
    }
    
    //没改完...
    func fetchRequest<T>(level: String, entityName: String, type: T.Type, key: String, ascending: Bool) -> [T] {
        let request = NSFetchRequest<NSFetchRequestResult>.init(entityName: entityName)
        request.predicate = NSPredicate(format: "level == %@", level)
        request.sortDescriptors = [NSSortDescriptor.init(key: key, ascending: ascending)]
        do {
            let results =
                try persistentContainer.viewContext.fetch(request) as! [T]
            return results
        } catch {
            fatalError("\(error)")
        }
    }
    
    func addOneRankEntity(level: String, name: String, time: String, seconds: Int64) {
        let rank = NSEntityDescription.insertNewObject(forEntityName: "SKRank", into: persistentContainer.viewContext) as! SKRank
        rank.name = name
        rank.time = time
        rank.seconds = seconds
        rank.level = level
        saveContext ()
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Sudoku")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    fileprivate init() {}
    
}
