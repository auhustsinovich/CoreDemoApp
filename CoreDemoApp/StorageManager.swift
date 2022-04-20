//
//  StorageManager.swift
//  CoreDemoApp
//
//  Created by Daniil on 20.04.22.
//

import CoreData

class StorageManager {
    
    static let shared = StorageManager()
    
    private var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CoreDemoApp")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Error: \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    private init() {}
    
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func fetchContext(_ data: inout [Task]) {
        let fetchRequest = Task.fetchRequest()
        let context = persistentContainer.viewContext
        do {
            data = try context.fetch(fetchRequest)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func createTask() -> Task {
        let context = persistentContainer.viewContext
        return Task(context: context)
    }
    
    func deleteTask(_ task: Task) {
        let context = persistentContainer.viewContext
        context.delete(task)
    }
}
