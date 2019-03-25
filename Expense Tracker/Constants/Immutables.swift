//
//  Immutables.swift
//  Expense Tracker
//
//  Created by madi on 3/21/19.
//  Copyright © 2019 com.madi.budget. All rights reserved.
//

import Foundation

struct Entities {
    static let expenseType = "ExpenseType"
    static let transaction = "Transaction"
}

struct ExpenseTypeAttributes {
    static let id = "id"
    static let type = "type"
}

struct TransactionAttributes {
    static let amount = "amount"
    static let date = "date"
    static let id = "id"
    static let month = "month"
    static let name = "name"
    static let type = "type"
    static let year = "year"
}

struct Expense {
    var amount: Decimal
    var date: Date
    var id: Int
    var name: String
    var type: String
    
    init(amount: Decimal, date: Date, id: Int, name: String, type: String) {
        self.amount = amount
        self.date = date
        self.id = id
        self.name = name
        self.type = type
    }
}
