//
//  Persistence.swift
//  BarcodeScanner
//
//  Created by Evgeni Novik on 17.10.2025.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    let container = NSPersistentContainer(name: "BarcodeScanner")

    init() {
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                print("Error with loading PersistentStores \(error)")
            }
        })
    }
}

extension NSManagedObjectContext {
    
    func saveContext() throws {
        if self.hasChanges {
            do {
                try self.save()
            }
        }
    }
}
