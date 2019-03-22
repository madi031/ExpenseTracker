//
//  Transaction+CoreDataClass.swift
//  Expense Tracker
//
//  Created by madi on 3/22/19.
//  Copyright © 2019 com.madi.budget. All rights reserved.
//
//

import Foundation
import CoreData

class Transaction: NSManagedObject {
    class func save(dict: NSDictionary, context: NSManagedObjectContext) {
    
        let transactionEntity = NSEntityDescription.entity(forEntityName: Entities.transaction, in: context)!
        let transaction = NSManagedObject(entity: transactionEntity, insertInto: context)
    
        transaction.setValue(dict[TransactionAttributes.amount], forKey: TransactionAttributes.amount)
        transaction.setValue(dict[TransactionAttributes.date], forKey: TransactionAttributes.date)
        transaction.setValue(dict[TransactionAttributes.name], forKey: TransactionAttributes.name)
        transaction.setValue(dict[TransactionAttributes.type], forKey: TransactionAttributes.type)
    
        do {
            try context.save()
        } catch let error as NSError {
            print("Could not save transaction, \(error), \(error.description)")
        }
    }
    
    class func fetch(context: NSManagedObjectContext) -> [NSDictionary] {
        var transactionsContext: [NSManagedObject] = [NSManagedObject]()
        let request = createFetchRequest()
        
        do {
            transactionsContext = try context.fetch(request)
        } catch let error as NSError {
            print("Could not fetch transactions, \(error), \(error.description)")
        }
        
        var transactions: [NSDictionary] = [NSDictionary]()
        
        for transaction in transactionsContext {
            let dict: NSDictionary = [
                TransactionAttributes.amount: transaction.value(forKeyPath: TransactionAttributes.amount) as Any,
                TransactionAttributes.date: transaction.value(forKeyPath: TransactionAttributes.date) as Any,
                TransactionAttributes.name: transaction.value(forKeyPath: TransactionAttributes.name) as Any,
                TransactionAttributes.type: transaction.value(forKeyPath: TransactionAttributes.type) as Any
            ]
            transactions.append(dict)
        }
        
        return transactions
    }
}
