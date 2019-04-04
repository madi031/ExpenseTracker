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
    static let savings = "Savings"
    static let repeatSavings = "RepeatSavings"
    static let transaction = "Transaction"
}

struct ExpenseTypeAttributes {
    static let id = "id"
    static let type = "type"
}

struct RepeatSavingsAttributes {
    static let month = "month"
    static let type = "type"
    static let year = "year"
}

struct SavingsAttributes {
    static let amount = "amount"
    static let id = "id"
    static let month = "month"
    static let type = "type"
    static let year = "year"
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

struct SegueIds {
    static let addExpense = "AddExpenseSegue"
    static let authenticateUser = "authenticateUserSegue"
    static let editExpense = "EditExpenseSegue"
    static let editSavings = "EditSavingsSegue"
    static let expenseHistory = "ExpenseHistorySegue"
    static let newSavings = "newSavingsSegue"
    static let savingsTableView = "SavingsTableViewSegue"
}

struct Credit {
    var amount: Decimal
    var id: Int
    var repeatEnabled: Bool
    var type: String
    
    init(amount: Decimal, id: Int, repeatEnabled: Bool = true, type: String) {
        self.amount = amount
        self.id = id
        self.repeatEnabled = repeatEnabled
        self.type = type
    }
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

struct Repeat {
    var month: Int
    var type: String
    var year: Int
    
    init(month: Int, type: String, year: Int) {
        self.month = month
        self.type = type
        self.year = year
    }
}
