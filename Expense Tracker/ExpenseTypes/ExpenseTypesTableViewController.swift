//
//  ExpenseTypesTableViewController.swift
//  Expense Tracker
//
//  Created by madi on 3/22/19.
//  Copyright © 2019 com.madi.budget. All rights reserved.
//

import CoreData
import UIKit

class ExpenseTypesTableViewController: UITableViewController {
    
    fileprivate var managedContext: NSManagedObjectContext!
    
    var expenseTypes = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        managedContext = appDelegate.persistentContainer.viewContext
        
        loadExistingTypes()
        setPlaceholderType()
        
        tableView.register(UINib(nibName: "NewExpenseTypeTableViewCell", bundle: nil), forCellReuseIdentifier: "NewExpenseTypeTableViewCell")
        
        self.tableView.reloadData()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tapGesture.cancelsTouchesInView = true
        tableView.addGestureRecognizer(tapGesture)
    }
    
    @objc
    func hideKeyboard() {
        tableView.endEditing(true)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return expenseTypes.count + 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "NewExpenseTypeTableViewCell", for: indexPath) as? NewExpenseTypeTableViewCell else {
                fatalError("The dequeued cell is not an instance of NewExpenseTypeTableViewCell.")
            }
            cell.delegate = self
            return cell
        }
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ExpenseTypeCell", for: indexPath) as? ExpenseTypesTableViewCell else {
            fatalError("The dequeued cell is not an instance of ExpenseTypesTableViewCell.")
        }
        
        cell.expenseTypeLabel.text = expenseTypes[indexPath.row - 1]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 80.0
        }
        
        return 50.0
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            return
        }
        
        if editingStyle == .delete {
            ExpenseType.delete(type: self.expenseTypes[indexPath.row - 1], context: self.managedContext, callback: { (error) in
                if error == nil {
                    // Object array has to be deleted first before deleting the row
                    self.loadExistingTypes()
                    self.tableView.deleteRows(at: [indexPath], with: .fade)
                    self.setPlaceholderType()
                    self.tableView.reloadData()
                }
            })
        }
    }
    
    func loadExistingTypes() {
        expenseTypes = ExpenseType.fetch(context: managedContext)
    }
    
    func setPlaceholderType() {
        if expenseTypes == [] {
            expenseTypes = [""]
        }
    }
}

extension ExpenseTypesTableViewController: ExpenseTypesUpdater {
    func updateTableView() {
        loadExistingTypes()
        setPlaceholderType()
        self.tableView.reloadData()
    }
}
