//
//  Persistence.swift
//  Shared
//
//  Created by Tomáš Mišutka on 03/01/2022.
//

import CoreData

struct PersistenceController
{
    static let shared = PersistenceController()

    static var preview: PersistenceController =
    {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        for _ in 0..<10
        {
            let newProduct = Product(context: viewContext)
            newProduct.warrantyUntil = Date()
            newProduct.category = "SPORT"
            newProduct.status = 0 //0 - active, 1 - expire soon, 2 - expired
            newProduct.name = "Testing product"
        }
        do
        {
            try viewContext.save()
        } catch
        {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false)
    {
        container = NSPersistentContainer(name: "WarrantyReminderSwiftUI")
        if inMemory
        {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }
    
    func getAllProduct() -> [Product]
    {
        let fetchRequest: NSFetchRequest<Product> = Product.fetchRequest()
        
        do
        {
            return try container.viewContext.fetch(fetchRequest)
        } catch
        {
            return []
        }
    }
}
