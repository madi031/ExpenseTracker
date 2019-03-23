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
    
    var totalAmountSpent: Int = 0
    
    let today = Date()
    
    var monthDisplayed: String = ""
    var yearDisplayed: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        managedContext = appDelegate.persistentContainer.viewContext
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        getExpenseDetails()
        
        monthDisplayed = today.month
        yearDisplayed = Int(today.year)
        
        navigationItem.title = "\(monthDisplayed), \(yearDisplayed)"
        
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ExpensesTableViewCell", for: indexPath) as? ExpensesTableViewCell else {
            fatalError("The dequeued cell is not an instance of ExpensesTableViewCell.")
        }

        cell.titleLabel.text = "Total Spent"
        cell.amountLabel.text = "$\(totalAmountSpent)"

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    func getExpenseDetails() {
        totalAmountSpent = Transaction.getTotalSpent(forMonth: today.month, andYear: today.year, context: managedContext)
    }

}
