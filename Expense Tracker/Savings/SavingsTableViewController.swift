//
//  SavingsTableViewController.swift
//  Expense Tracker
//
//  Created by madi on 3/26/19.
//  Copyright © 2019 com.madi.budget. All rights reserved.
//

import CoreData
import UIKit

class SavingsTableViewController: UITableViewController {
    
    fileprivate var managedContext: NSManagedObjectContext!
    
    var today: Date!
    
    var monthDisplayed: String = ""
    var yearDisplayed: Int = 0
    
    var savings = [Credit]()
    var savingsSelected: Credit? = nil
    var amountForSavings = [[Int:[String: Decimal]]]()

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        managedContext = appDelegate.persistentContainer.viewContext
        
        NotificationCenter.default.addObserver(self, selector: #selector(loadTable), name: NSNotification.Name(rawValue: "loadSavings"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(nextButtonTapped), name: NSNotification.Name(rawValue: "nextButtonTapped"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(backButtonTapped), name: NSNotification.Name(rawValue: "backButtonTapped"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        monthDisplayed = today.month
        yearDisplayed = Int(today.year)
        
        loadSavings()
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return amountForSavings.count + 2
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SavingsTableViewCell", for: indexPath) as? SavingsTableViewCell else {
            fatalError("The dequeued cell is not an instance of SavingsTableViewCell.")
        }
        
        if indexPath.row >= amountForSavings.count {
            cell.amountLabel.text = ""
            cell.typeLabel.text = ""
            return cell
        }
        
        let dictVal = amountForSavings[indexPath.row]
        let dict = Array(dictVal)[0].value
        cell.amountLabel.text = "$\(Array(dict)[0].value)"
        cell.typeLabel.text = Array(dict)[0].key
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let dictVal = amountForSavings[indexPath.row]
            let dict = Array(dictVal)[0].value
            Savings.delete(type: Array(dict)[0].key, context: managedContext) { (error) in
                if error == nil {
                    self.loadTableView()
                }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        savingsSelected = savings[indexPath.row]
        performSegue(withIdentifier: "EditSavingsSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! EditSavingsViewController
        
        if let savingsSelected = savingsSelected {
            destinationVC.amount = savingsSelected.amount
            destinationVC.id = savingsSelected.id
            destinationVC.month = today.monthWithMM
            destinationVC.type = savingsSelected.type
            destinationVC.year = today.yearWithYY
        }
    }
    
    @objc
    func backButtonTapped(notification: NSNotification) {
        today = Calendar.current.date(byAdding: .month, value: -1, to: today)!
        loadTableView()
    }
    
    @objc
    func loadTable(notification: NSNotification) {
        loadTableView()
    }
    
    @objc
    func nextButtonTapped(notification: NSNotification) {
        today = Calendar.current.date(byAdding: .month, value: 1, to: today)!
        loadTableView()
    }

    func loadSavings() {
        amountForSavings = [[Int:[String: Decimal]]]()
        savings = Savings.getSavings(forMonth: monthDisplayed, andYear: Int64(yearDisplayed), context: managedContext)
        for saving in savings {
            let amount = saving.amount
            let type = saving.type
            let id = saving.id
            amountForSavings.append([id:[type: amount]])
        }
    }
    
    func loadTableView() {
        monthDisplayed = today.month
        yearDisplayed = Int(today.year)
        loadSavings()
        self.tableView.reloadData()
    }
}
