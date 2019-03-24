//
//  ExpenseHistoryTableViewController.swift
//  Expense Tracker
//
//  Created by madi on 3/24/19.
//  Copyright © 2019 com.madi.budget. All rights reserved.
//

import CoreData
import UIKit

class ExpenseHistoryTableViewController: UITableViewController {
    
    fileprivate var managedContext: NSManagedObjectContext!
    
    var expenseType: String = ""
    var month: String = ""
    var year: Int = 0
    
    var expenses = [Expense]()

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        managedContext = appDelegate.persistentContainer.viewContext
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadExpenses()
        
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return expenses.count
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 40.0))
        let button = UIButton(frame: CGRect(x: 0, y: 10, width: 60, height: 30))
        button.setTitleColor(UIColor(red: 52.0/255.0, green: 108.0/255.0, blue: 240.0/255.0, alpha: 1.0), for: .normal)
        button.setTitle("X", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(closeButton), for: .touchUpInside)
        view.addSubview(button)
        
        let label = UILabel(frame: CGRect(x: self.view.frame.size.width/4, y: 10, width: self.view.frame.size.width/2, height: 20))
        label.textAlignment = .center
        label.text = expenseType
        
        if expenseType == "" {
            label.text = "Total"
        }

        view.addSubview(label)
        
        return view
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ExpenseHistoryTableViewCell", for: indexPath) as? ExpenseHistoryTableViewCell else {
            fatalError("The dequeued cell is not an instance of ExpenseHistoryTableViewCell.")
        }

        let expense = expenses[indexPath.row]
        cell.nameLabel.text = expense.name
        cell.amountLabel.text = "$\(expense.amount)"

        return cell
    }
    
    @objc
    func closeButton() {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }

    func loadExpenses() {
        expenses = Transaction.getTransactionLists(forMonth: month, andYear: Int64(year), type: expenseType, context: managedContext)
    }
}
