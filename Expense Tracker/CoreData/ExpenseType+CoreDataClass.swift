//
//  ExpenseType+CoreDataClass.swift
//  Expense Tracker
//
//  Created by madi on 3/22/19.
//  Copyright © 2019 com.madi.budget. All rights reserved.
//
//

import Foundation
import CoreData

class ExpenseType: NSManagedObject {
    class func getLastId(context: NSManagedObjectContext) -> Int {
        let request = createFetchRequest()
        
        request.sortDescriptors = [NSSortDescriptor(key: ExpenseTypeAttributes.id, ascending: true)]
        
        do {
            let types = try context.fetch(request)
            let expense = types.last
            
            return expense?.value(forKey: ExpenseTypeAttributes.id) as! Int
        } catch let error as NSError {
            print("Could not fetch expense types, \(error), \(error.description)")
        }
        
        return 0
    }
    
    class func fetch(context: NSManagedObjectContext) -> [String] {
        var expenseTypesContext: [NSManagedObject] = [NSManagedObject]()
        let request = createFetchRequest()
        
        do {
            expenseTypesContext = try context.fetch(request)
        } catch let error as NSError {
            print("Could not fetch expense types, \(error), \(error.description)")
        }
        
        var expenseTypes: [String] = [String]()
        
        for expenseType in expenseTypesContext {
            let type = expenseType.value(forKeyPath: ExpenseTypeAttributes.type) as! String
            expenseTypes.append(type)
        }
        
        return expenseTypes
    }
    
    class func save(type: String, context: NSManagedObjectContext, callback: @escaping (NSError?) -> Void) {
        let entity = NSEntityDescription.entity(forEntityName: Entities.expenseType, in: context)!
        let expenseType = NSManagedObject(entity: entity, insertInto: context)
        
        let id = getLastId(context: context) + 1
        
        expenseType.setValue(id, forKey: ExpenseTypeAttributes.id)
        expenseType.setValue(type, forKey: ExpenseTypeAttributes.type)
        
        context.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
        
        do {
            try context.save()
            callback(nil)
        } catch let error as NSError {
            print("Could not save expense type, \(error), \(error.description)")
            callback(error)
        }
    }
}
