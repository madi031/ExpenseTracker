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
    
    fileprivate var managedContext: NSManagedObjectContext!
    
    var totalAmountSpent: Decimal = 0
    var expenseTypeSelected = ""
    
    let today = Date()
    
    var monthDisplayed: String = ""
    var yearDisplayed: Int = 0
    
    var expenseTypes = [String]()
    var amountForExpenses = [[String: Decimal]]()

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        managedContext = appDelegate.persistentContainer.viewContext
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        amountForExpenses = [[String: Decimal]]()

        getExpenseDetails()
        
        monthDisplayed = today.month
        yearDisplayed = Int(today.year)
        
        navigationItem.title = "\(monthDisplayed), \(yearDisplayed)"
        
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
            cell.titleLabel.text = "Total Spent"
            cell.amountLabel.text = "$\(totalAmountSpent)"
        } else {
            let dict = amountForExpenses[indexPath.row]
            cell.titleLabel.text = Array(dict)[0].key
            cell.amountLabel.text = "$\(Array(dict)[0].value)"
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
            expenseTypeSelected = Array(amountForExpenses[indexPath.row])[0].key
        }
        performSegue(withIdentifier: "ExpenseHistorySegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ExpenseHistoryTableViewController
        
        destinationVC.expenseType = expenseTypeSelected
        destinationVC.month = monthDisplayed
        destinationVC.year = yearDisplayed
    }
    
    func getExpenseDetails() {
        totalAmountSpent = Transaction.getTotalSpent(forMonth: today.month, andYear: today.year, context: managedContext)
        expenseTypes = ExpenseType.fetch(context: managedContext)
        
        for type in expenseTypes {
            let amountSpent = Transaction.getTotalSpent(forMonth: today.month, andYear: today.year, type: type, context: managedContext)
            let spentDict = [type: amountSpent]
            amountForExpenses.append(spentDict)
        }
    }

}
