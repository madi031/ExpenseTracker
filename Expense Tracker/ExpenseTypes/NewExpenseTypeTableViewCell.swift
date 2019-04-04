//
//  NewExpenseTypeTableViewCell.swift
//  Expense Tracker
//
//  Created by madi on 3/21/19.
//  Copyright © 2019 com.madi.budget. All rights reserved.
//

import CoreData
import UIKit

class NewExpenseTypeTableViewCell: UITableViewCell {
    
    fileprivate var managedContext: NSManagedObjectContext!

    @IBOutlet weak var expenseTypeTextField: UITextField!
    @IBOutlet weak var expenseTypeLimitTextField: UITextField!
    
    weak var delegate: ExpenseTypesUpdater?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        managedContext = appDelegate.persistentContainer.viewContext
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        if let type = expenseTypeTextField.text, type != "" {
            ExpenseType.save(type: type.trim(), limit: Decimal(string: expenseTypeLimitTextField?.text ?? ""), context: managedContext) { (error) in
                if error == nil {
                    self.delegate?.updateTableView()
                    self.expenseTypeTextField.text = ""
                    self.expenseTypeLimitTextField.text = ""
                    self.expenseTypeTextField.resignFirstResponder()
                    self.expenseTypeLimitTextField.resignFirstResponder()
                }
            }
        }
    }
}
