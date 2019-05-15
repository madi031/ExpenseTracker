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
    
    class func fetchByType(type: String, context: NSManagedObjectContext) -> ExpenseType? {
        let request = createFetchRequest()
        request.fetchLimit = 1
        request.predicate = NSPredicate(format: "type = %@", type)
        
        do {
            let type = try context.fetch(request)
            return type.first
        } catch let error as NSError {
            print("Could not fetch expense by type, \(error), \(error.description)")
            return nil
        }
    }
    
    class func fetch(context: NSManagedObjectContext) -> [ExpenseTypes] {
        var expenseTypesContext: [NSManagedObject] = [NSManagedObject]()
        let request = createFetchRequest()
        
        do {
            expenseTypesContext = try context.fetch(request)
        } catch let error as NSError {
            print("Could not fetch expense types, \(error), \(error.description)")
        }
        
        var expenseTypes: [ExpenseTypes] = [ExpenseTypes]()
        
        for expenseType in expenseTypesContext {
            let id = expenseType.value(forKeyPath: ExpenseTypeAttributes.id) as! Int
            let limit = expenseType.value(forKeyPath: ExpenseTypeAttributes.limit) as? Decimal
            let type = expenseType.value(forKeyPath: ExpenseTypeAttributes.type) as! String
            expenseTypes.append(ExpenseTypes(id: id, limit: limit, type: type))
        }
        
        return expenseTypes
    }
    
    class func save(type: String, limit: Decimal?, context: NSManagedObjectContext, callback: @escaping (NSError?) -> Void) {
        let entity = NSEntityDescription.entity(forEntityName: Entities.expenseType, in: context)!
        let expenseType = NSManagedObject(entity: entity, insertInto: context)
        
        let id = getLastId(context: context) + 1
        print("id...\(id)")
        
        expenseType.setValue(id, forKey: ExpenseTypeAttributes.id)
        expenseType.setValue(limit, forKey: ExpenseTypeAttributes.limit)
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
    
    class func delete(type: String, context: NSManagedObjectContext, callback: @escaping (NSError?) -> Void) {
        let request = createFetchRequest()
        request.predicate = NSPredicate(format: "type = %@", type)
        
        do {
            let expenseTypes = try context.fetch(request)
            
            if expenseTypes.count == 0 {
                callback(nil)
                return
            }
            
            let typeToDelete = expenseTypes[0] as NSManagedObject
            context.delete(typeToDelete)
            do {
                try context.save()
                callback(nil)
            } catch let error as NSError {
                print("Could not save expense after delete, \(error), \(error.description)")
                callback(error)
            }
        } catch let error as NSError {
            print("Could not fetch expense type, \(error), \(error.description)")
            callback(error)
        }
    }
    
    class func update(byType type: String, limit: Decimal?, context: NSManagedObjectContext) {
         let request = createFetchRequest()
        request.predicate = NSPredicate(format: "type = %@", type)
        
        do {
            let expenseType = try context.fetch(request)
            
            if expenseType.count == 0 {
                return
            }
            
            let expenseTypeToUpdate = expenseType[0] as NSManagedObject
            
            expenseTypeToUpdate.setValue(limit, forKey: ExpenseTypeAttributes.limit)
            
            do {
                try context.save()
            } catch let error as NSError {
                print("Could not save expense type by typw, \(error), \(error.description)")
            }
        } catch let error as NSError {
            print("Could not fetch expense type by typw, \(error), \(error.description)")
        }
    }
}
