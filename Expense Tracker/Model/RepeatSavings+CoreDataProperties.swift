//
//  RepeatSavings+CoreDataProperties.swift
//  Expense Tracker
//
//  Created by madi on 3/27/19.
//  Copyright © 2019 com.madi.budget. All rights reserved.
//
//

import Foundation
import CoreData


extension RepeatSavings {

    @nonobjc public class func createFetchRequest() -> NSFetchRequest<RepeatSavings> {
        return NSFetchRequest<RepeatSavings>(entityName: "RepeatSavings")
    }

    @NSManaged public var type: String?
    @NSManaged public var month: Int64
    @NSManaged public var year: Int64

}
