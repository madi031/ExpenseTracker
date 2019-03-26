//
//  Savings+CoreDataProperties.swift
//  Expense Tracker
//
//  Created by madi on 3/26/19.
//  Copyright © 2019 com.madi.budget. All rights reserved.
//
//

import Foundation
import CoreData


extension Savings {

    @nonobjc public class func createFetchRequest() -> NSFetchRequest<Savings> {
        return NSFetchRequest<Savings>(entityName: "Savings")
    }

    @NSManaged public var amount: NSDecimalNumber?
    @NSManaged public var id: Int64
    @NSManaged public var month: String?
    @NSManaged public var type: String?
    @NSManaged public var year: Int64
}
