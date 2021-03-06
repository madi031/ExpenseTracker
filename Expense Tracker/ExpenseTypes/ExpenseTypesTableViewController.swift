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
    
    var expenseTypes = [ExpenseTypes]()
    var expenseTypeSelected: ExpenseTypes!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        managedContext = appDelegate.persistentContainer.viewContext
        
        loadExistingTypes()
        
        tableView.register(UINib(nibName: "NewExpenseTypeTableViewCell", bundle: nil), forCellReuseIdentifier: "NewExpenseTypeTableViewCell")
        
        self.tableView.reloadData()
        
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
//        tapGesture.cancelsTouchesInView = true
//        tableView.addGestureRecognizer(tapGesture)
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
            
            // draw bottom border
            let border = CALayer()
            let width = CGFloat(1.0)
            border.borderColor = UIColor.gray.cgColor
            border.frame = CGRect(x: 0, y: cell.frame.size.height - width, width:  cell.frame.size.width, height: cell.frame.size.height)
            
            border.borderWidth = width
            cell.layer.addSublayer(border)
            cell.layer.masksToBounds = true
            
            cell.delegate = self
            return cell
        }
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ExpenseTypeCell", for: indexPath) as? ExpenseTypesTableViewCell else {
            fatalError("The dequeued cell is not an instance of ExpenseTypesTableViewCell.")
        }
        
        var limitText: String
        if let limit = expenseTypes[indexPath.row - 1].limit, limit != 0 {
            limitText = "$\(limit) limit"
        } else {
            limitText = ""
        }
        
        cell.expenseTypeLabel.text = expenseTypes[indexPath.row - 1].type
        cell.expenseLimitLabel.text = limitText
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 100.0
        }
        
        return 50.0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            return
        }
        
        expenseTypeSelected = expenseTypes[indexPath.row - 1]
        performSegue(withIdentifier: SegueIds.editExpenseType, sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            return
        }
        
        if editingStyle == .delete {
            ExpenseType.delete(type: self.expenseTypes[indexPath.row - 1].type, context: self.managedContext, callback: { (error) in
                if error == nil {
                    // Object array has to be deleted first before deleting the row
                    self.loadExistingTypes()
                    self.tableView.deleteRows(at: [indexPath], with: .fade)
                    self.tableView.reloadData()
                }
            })
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueIds.editExpenseType {
            let destinationVC = segue.destination as! EditExpenseTypeViewController
            
            destinationVC.typeText = expenseTypeSelected.type
            destinationVC.limitText = expenseTypeSelected.limit
            destinationVC.delegate = self
        }
    }
    
    func loadExistingTypes() {
        expenseTypes = ExpenseType.fetch(context: managedContext)
    }
}

extension ExpenseTypesTableViewController: ExpenseTypesUpdater {
    func updateTableView() {
        loadExistingTypes()
        self.tableView.reloadData()
    }
}
