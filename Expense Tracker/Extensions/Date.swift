//
//  Date.swift
//  Expense Tracker
//
//  Created by madi on 3/23/19.
//  Copyright © 2019 com.madi.budget. All rights reserved.
//

import Foundation

extension Date {
    var month: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM"
        return dateFormatter.string(from: self)
    }
    
    var year: Int64 {
        return Int64(Calendar.current.component(.year, from: self))
    }
    
    func toString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM yyyy"
        return dateFormatter.string(from: self)
    }
}
