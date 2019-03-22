//
//  Transaction+CoreDataProperties.swift
//  Expense Tracker
//
//  Created by madi on 3/22/19.
//  Copyright © 2019 com.madi.budget. All rights reserved.
//
//

import Foundation
import CoreData


extension Transaction {

    @nonobjc public class func createFetchRequest() -> NSFetchRequest<Transaction> {
        return NSFetchRequest<Transaction>(entityName: "Transaction")
    }

    @NSManaged public var amount: Int64
    @NSManaged public var date: NSDate?
    @NSManaged public var name: String?
    @NSManaged public var type: String?

}
