//
//  ExpenseType+CoreDataProperties.swift
//  Expense Tracker
//
//  Created by madi on 3/22/19.
//  Copyright © 2019 com.madi.budget. All rights reserved.
//
//

import Foundation
import CoreData


extension ExpenseType {

    @nonobjc public class func createFetchRequest() -> NSFetchRequest<ExpenseType> {
        return NSFetchRequest<ExpenseType>(entityName: "ExpenseType")
    }

    @NSManaged public var id: Int64
    @NSManaged public var limit: Decimal
    @NSManaged public var type: String?

}
