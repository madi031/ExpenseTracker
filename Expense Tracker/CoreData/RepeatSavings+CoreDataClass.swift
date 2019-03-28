//
//  RepeatSavings+CoreDataClass.swift
//  Expense Tracker
//
//  Created by madi on 3/27/19.
//  Copyright © 2019 com.madi.budget. All rights reserved.
//
//

import Foundation
import CoreData

@objc(RepeatSavings)
public class RepeatSavings: NSManagedObject {
    class func save(type: String, month: Int64, year: Int64, context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entity(forEntityName: Entities.repeatSavings, in: context)
        let savings = NSManagedObject(entity: entity!, insertInto: context)
        
        savings.setValue(month, forKey: RepeatSavingsAttributes.month)
        savings.setValue(type, forKey: RepeatSavingsAttributes.type)
        savings.setValue(year, forKey: RepeatSavingsAttributes.year)
        
        context.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
        
        do {
            try context.save()
        } catch let error as NSError {
            print("Could not saving repeat savings, \(error), \(error.description)")
        }
    }
    
    class func fetch(context: NSManagedObjectContext) -> [Repeat] {
        var repContext: [NSManagedObject] = [NSManagedObject]()
        let request = createFetchRequest()
        
        do {
            repContext = try context.fetch(request)
        } catch let error as NSError {
            print("Could not fetch repeat savings, \(error), \(error.description)")
        }
        
        var reps: [Repeat] = [Repeat]()
        
        for rep in repContext {
            let month = rep.value(forKeyPath: RepeatSavingsAttributes.month) as! Int
            let type = rep.value(forKeyPath: RepeatSavingsAttributes.type) as! String
            let year = rep.value(forKeyPath: RepeatSavingsAttributes.year) as! Int
            
            let saving = Repeat(month: month, type: type, year: year)
            
            reps.append(saving)
        }
        
        return reps
    }
    
    class func fetch(afterMonth month: Int64, andYear year: Int64, context: NSManagedObjectContext) -> [String] {
        var reps: [String] = [String]()
        var repContext: [NSManagedObject] = [NSManagedObject]()
        let request = createFetchRequest()
        
        request.predicate = NSPredicate(format: "month < %d AND year <= %d", month, year)
        
        do {
            repContext = try context.fetch(request)
        } catch let error as NSError {
            print("Could not fetch repeat savings, \(error), \(error.description)")
        }
        
        for rep in repContext {
            let type = rep.value(forKeyPath: RepeatSavingsAttributes.type) as! String
            reps.append(type)
        }
        
        return reps
    }
    
    class func isPresent(type: String, context: NSManagedObjectContext) -> Bool {
        let request = createFetchRequest()
        request.predicate = NSPredicate(format: "type = %@", type)
        
        do {
            let rep = try context.fetch(request)
            
            if rep.count > 0 {
                return true
            }
        } catch let error as NSError {
            print("Could not fetch savings, \(error), \(error.description)")
        }
        return false
    }
    
    class func delete(type: String, context: NSManagedObjectContext) {
        let request = createFetchRequest()
        request.predicate = NSPredicate(format: "type = %@", type)
        
        do {
            let reps = try context.fetch(request)
            
            if reps.count == 0 {
                return
            }
            
            let repsToDelete = reps[0] as NSManagedObject
            context.delete(repsToDelete)
            do {
                try context.save()
            } catch let error as NSError {
                print("Could not save savings after delete, \(error), \(error.description)")
            }
        } catch let error as NSError {
            print("Could not fetch repeat savings, \(error), \(error.description)")
        }
    }
}
