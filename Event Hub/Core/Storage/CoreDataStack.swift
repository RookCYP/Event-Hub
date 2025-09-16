//
//  CoreDataStack.swift
//  Event Hub
//
//  Created by Aleksandr Meshchenko on 15.09.25.
//

// /Core/Storage/CoreDataStack.swift
import CoreData

final class CoreDataStack {
    static let shared = CoreDataStack()
    
    private init() {}
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "EventHub")
        
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Core Data failed to load: \(error)")
            }
        }
        
        container.viewContext.automaticallyMergesChangesFromParent = true
        return container
    }()
    
    var viewContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    func save() throws {
        guard viewContext.hasChanges else { return }
        try viewContext.save()
    }
}
