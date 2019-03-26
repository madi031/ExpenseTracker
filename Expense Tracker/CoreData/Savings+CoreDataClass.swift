//
//  Savings+CoreDataClass.swift
//  Expense Tracker
//
//  Created by madi on 3/26/19.
//  Copyright © 2019 com.madi.budget. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Savings)
public class Savings: NSManagedObject {
    class func save(type: String, amount: String, month: String, year: Int64, context: NSManagedObjectContext, callback: @escaping (NSError?) -> Void) {
        let entity = NSEntityDescription.entity(forEntityName: Entities.savings, in: context)
        let savings = NSManagedObject(entity: entity!, insertInto: context)
        
        let id = getLastId(context: context) + 1
        
        savings.setValue(Decimal(string: amount), forKey: SavingsAttributes.amount)
        savings.setValue(id, forKey: SavingsAttributes.id)
        savings.setValue(month, forKey: SavingsAttributes.month)
        savings.setValue(type, forKey: SavingsAttributes.type)
        savings.setValue(year, forKey: SavingsAttributes.year)
        
        context.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
        
        do {
            try context.save()
            callback(nil)
        } catch let error as NSError {
            print("Could not save savings, \(error), \(error.description)")
            callback(error)
        }
    }
    
    class func getLastId(context: NSManagedObjectContext) -> Int {
        let request = createFetchRequest()
        request.fetchLimit = 1
        request.sortDescriptors = [NSSortDescriptor(key: SavingsAttributes.id, ascending: true)]
        
        do {
            let savingsContext = try context.fetch(request)
            let savings = savingsContext.first
            return savings?.value(forKey: SavingsAttributes.id) as! Int
        } catch let error as NSError {
            print("Could not fetch Savings, \(error), \(error.description)")
        }
        return 0
    }
    
    class func fetch(context: NSManagedObjectContext) -> [NSDictionary] {
        var savingsContext: [NSManagedObject] = [NSManagedObject]()
        let request = createFetchRequest()
        
        do {
            savingsContext = try context.fetch(request)
        } catch let error as NSError {
            print("Could not fetch savings, \(error), \(error.description)")
        }
        
        var savings: [NSDictionary] = [NSDictionary]()
        
        for saving in savingsContext {
            let dict: NSDictionary = [
                SavingsAttributes.amount: saving.value(forKeyPath: SavingsAttributes.amount) as Any,
                SavingsAttributes.id: saving.value(forKeyPath: SavingsAttributes.id) as Any,
                SavingsAttributes.type: saving.value(forKeyPath: SavingsAttributes.type) as Any
            ]
            savings.append(dict)
        }
        
        return savings
    }
    
    class func getSavings(forMonth month: String, andYear year: Int64, type: String? = nil, context: NSManagedObjectContext) -> [Credit] {
        var savings = [Credit]()
        
        let request = createFetchRequest()
        
        let datePredicate = NSPredicate(format: "month = %@ AND year = %d", month, year)
        
        if let type = type, type != "" {
            let typePredicate = NSPredicate(format: "type = %@", type)
            request.predicate = NSCompoundPredicate(type: .and, subpredicates: [datePredicate, typePredicate])
        } else {
            request.predicate = datePredicate
        }
        
        do {
            let savingsContext = try context.fetch(request)
            
            for saving in savingsContext {
                let amount = saving.value(forKeyPath: SavingsAttributes.amount) as! Decimal
                let id = saving.value(forKeyPath: SavingsAttributes.id) as! Int
                let type = saving.value(forKeyPath: SavingsAttributes.type) as! String
                
                savings.append(Credit(amount: amount, id: id, type: type))
            }
        } catch let error as NSError {
            print("Could not fetch savings, \(error), \(error.description)")
        }
        
        return savings
    }
    
}
