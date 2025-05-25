//
//  CoreDataStack.swift
//  CoffeeMap
//
//  Created by Цховребова Яна on 22.05.2025.
//

import CoreData

final class CDStack {
    static let shared = CDStack()

    let container: NSPersistentContainer

    private init() {
        container = NSPersistentContainer(name: "CoffeeMap")
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError(
                    CDError.persistentStoreLoadFailed(
                        underlyingError: error
                    ).localizedDescription
                )
            }
        }
    }

    var context: NSManagedObjectContext {
        return container.viewContext
    }

    func saveContext() throws {
        let context = container.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch let error as NSError {
                throw CDError.saveFailed(underlyingError: error)
            }
        }
    }
}
