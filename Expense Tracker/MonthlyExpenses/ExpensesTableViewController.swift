//
//  ExpensesTableViewController.swift
//  Expense Tracker
//
//  Created by madi on 3/23/19.
//  Copyright © 2019 com.madi.budget. All rights reserved.
//

import CoreData
import UIKit

class ExpensesTableViewController: UITableViewController {
    
    struct ExpensesCellValue {
        var amount: Decimal
        var count: Int
        var limit: Decimal?
        var type: String
    
        init(amount: Decimal, count: Int, limit: Decimal?, type: String) {
            self.amount = amount
            self.count = count
            self.limit = limit
            self.type = type
        }
    }
    
    fileprivate var managedContext: NSManagedObjectContext!
    
    var totalAmountSpent: Decimal = 0
    var totalCount: Int = 0
    var expenseTypeSelected = ""
    
    var today = Date()
    
    var monthDisplayed: String = ""
    var yearDisplayed: Int = 0
    
    var expenseTypes = [ExpenseTypes]()
    var amountForExpenses = [ExpensesCellValue]()

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        managedContext = appDelegate.persistentContainer.viewContext
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        amountForExpenses = [ExpensesCellValue]()
        
        today = Date()
        
        monthDisplayed = today.month
        yearDisplayed = Int(today.year)
        
        navigationItem.title = "\(monthDisplayed), \(yearDisplayed)"
        
        getExpenseDetails()
        
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        return amountForExpenses.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ExpensesTableViewCell", for: indexPath) as? ExpensesTableViewCell else {
            fatalError("The dequeued cell is not an instance of ExpensesTableViewCell.")
        }
        
        if indexPath.section == 0 {
            cell.backgroundColor = UIColor(red: 0.22, green: 0.32, blue: 0.60, alpha: 1.0)
            cell.titleLabel.text = "Total Spent"
            cell.titleLabel.textColor = .white
            cell.amountLabel.text = String(format: "$%.2f", Float(truncating: totalAmountSpent as NSNumber))
            cell.amountLabel.textColor = .white
            if totalCount == 0 {
                cell.countLabel.text = ""
            } else {
                cell.countLabel.text = "\(totalCount) transactions"
            }
        } else {
            let dict = amountForExpenses[indexPath.row]
            
            cell.titleLabel.text = dict.type
            cell.amountLabel.text = String(format: "$%.2f", Float(truncating: dict.amount as NSNumber))
            cell.countLabel.text = "\(dict.count) transactions"
            
            cell.backgroundColor = .white
            cell.titleLabel.textColor = .black
            cell.amountLabel.textColor = .black
            
            if let limit = dict.limit, limit != 0 {
                if dict.amount >= limit {
                    cell.backgroundColor = UIColor(red:1.00, green:0.26, blue:0.18, alpha:1.0)
                    cell.titleLabel.textColor = .white
                    cell.amountLabel.textColor = .white
                } else if dict.amount > 0.7 * limit {
                    cell.backgroundColor = UIColor(red:1.00, green:0.75, blue:0.21, alpha:1.0)
                }
            }
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            expenseTypeSelected = ""
        } else {
            expenseTypeSelected = amountForExpenses[0].type
        }
        performSegue(withIdentifier: SegueIds.expenseHistory, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ExpenseHistoryTableViewController
        
        destinationVC.expenseType = expenseTypeSelected
        destinationVC.month = monthDisplayed
        destinationVC.year = yearDisplayed
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        today = Calendar.current.date(byAdding: .month, value: -1, to: today)!
        
        monthDisplayed = today.month
        yearDisplayed = Int(today.year)
        
        navigationItem.title = "\(monthDisplayed), \(yearDisplayed)"
        
        amountForExpenses = [ExpensesCellValue]()
        getExpenseDetails()
        
        tableView.reloadData()
    }
    
    @IBAction func nextButtonPressed(_ sender: Any) {
        today = Calendar.current.date(byAdding: .month, value: 1, to: today)!
        
        monthDisplayed = today.month
        yearDisplayed = Int(today.year)
        
        navigationItem.title = "\(monthDisplayed), \(yearDisplayed)"
        
        amountForExpenses = [ExpensesCellValue]()
        getExpenseDetails()
        
        tableView.reloadData()
    }
    
    func getExpenseDetails() {
        (totalAmountSpent, totalCount) = Transaction.getTotalSpent(forMonth: today.month, andYear: today.year, context: managedContext)
        
        expenseTypes = ExpenseType.fetch(context: managedContext)
        
        for expenseType in expenseTypes {
            var amountSpent: Decimal = 0
            var typeCount: Int = 0
            let totalSpent = Transaction.getTotalSpent(forMonth: today.month, andYear: today.year, type: expenseType.type, context: managedContext)
            (amountSpent, typeCount) = totalSpent
            if typeCount > 0 {
                amountForExpenses.append(ExpensesCellValue(amount: amountSpent, count: typeCount, limit: expenseType.limit, type: expenseType.type))
            }
        }
    }

}
