//
//  Immutables.swift
//  Expense Tracker
//
//  Created by madi on 3/21/19.
//  Copyright © 2019 com.madi.budget. All rights reserved.
//

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
    static let name = "name"
    static let type = "type"
}
