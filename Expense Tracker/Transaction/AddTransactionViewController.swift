//
//  ViewController.swift
//  Expense Tracker
//
//  Created by madi on 3/21/19.
//  Copyright © 2019 com.madi.budget. All rights reserved.
//

import CoreData
import UIKit

class AddTransactionViewController: UIViewController {

    @IBOutlet weak var expenseNameTextField: UITextField!
    @IBOutlet weak var expenseAmountTextField: UITextField!
    @IBOutlet weak var expenseTypeTextField: UITextField!
    @IBOutlet weak var expenseDateTextField: UITextField!
    @IBOutlet weak var transactionTypePicker: UIPickerView!
    @IBOutlet weak var transactionDatePicker: UIDatePicker!
    @IBOutlet weak var addBarButton: UIBarButtonItem!
    
    fileprivate let dateFormatter = DateFormatter()
    fileprivate var managedContext: NSManagedObjectContext!
    
    var expenseTypes = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        managedContext = appDelegate.persistentContainer.viewContext
        
        dateFormatter.dateFormat = "dd MMM yyyy"
        
        hideTransactionPicker()
        
        expenseAmountTextField.delegate = self
        expenseDateTextField.delegate = self
        expenseNameTextField.delegate = self
        expenseTypeTextField.delegate = self
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(gesture:)))
        tapGesture.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapGesture)
        
        clearTransaction()
        transactionDatePicker.addTarget(self, action: #selector(handleDatePicker(sender:)), for: .valueChanged)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        loadExistingTypes()
        transactionTypePicker.delegate = self
        transactionTypePicker.dataSource = self
        
        if expenseTypes.count == 0 {
            expenseTypeTextField.text = ""
        }
    }
    
    @objc
    func handleDatePicker(sender: UIDatePicker) {
        expenseDateTextField.text = dateFormatter.string(from: sender.date)
    }
    
    @objc
    func handleTap(gesture: UITapGestureRecognizer) {
        self.view.endEditing(true)
        hideTransactionPicker()
    }
    
    @IBAction func pressAddButton(_ sender: Any) {
        if validExpense() {
            let transaction: NSDictionary = [
                TransactionAttributes.amount: Int(expenseAmountTextField!.text!) as Any,
                TransactionAttributes.date: dateFormatter.date(from: expenseDateTextField!.text!) as Any,
                TransactionAttributes.name: expenseNameTextField!.text!,
                TransactionAttributes.type: expenseTypeTextField!.text!
            ]
            Transaction.save(dict: transaction, context: managedContext)
            
            clearTransaction()
        } else {
            let alert = UIAlertController(title: "Oops!!", message: "Details are missing", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Let me fill again!", style: .default, handler: { _ in
                // do nothing
            }))
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    func clearTransaction() {
        expenseAmountTextField.text = ""
        expenseDateTextField.text = dateFormatter.string(from: Date())
        expenseNameTextField.text = ""
        expenseTypeTextField.text = ""
        
        hideKeyboard()
        hideTransactionPicker()
    }
    
    func displayTransactionDate() {
        transactionDatePicker.isHidden = false
        transactionTypePicker.isHidden = true
    }
    
    func displayTransactionType() {
        transactionDatePicker.isHidden = true
        transactionTypePicker.isHidden = false
    }
    
    func hideKeyboard() {
        expenseAmountTextField.resignFirstResponder()
        expenseNameTextField.resignFirstResponder()
    }
    
    func hideTransactionPicker() {
        transactionDatePicker.isHidden = true
        transactionTypePicker.isHidden = true
    }
    
    func loadExistingTypes() {
        expenseTypes = ExpenseType.fetch(context: managedContext)
    }
    
    func validExpense() -> Bool {
        if expenseAmountTextField.text != "", expenseNameTextField.text != "", expenseTypeTextField.text != "" {
            return true
        }
        return false
    }
    
    func ValidateExpenseType() -> Bool {
        if expenseTypes.count > 0 {
            transactionTypePicker.isHidden = false
            return true
        }
        
        transactionTypePicker.isHidden = true
        
        let alert = UIAlertController(title: "Oops!!", message: "No Expense Type found", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Let me add!", style: .default, handler: { _ in
            self.tabBarController?.selectedIndex = 1
        }))
        self.present(alert, animated: true, completion: nil)
        return false
    }
}

extension AddTransactionViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return expenseTypes.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return expenseTypes[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        expenseTypeTextField.text = expenseTypes[row]
    }
}

extension AddTransactionViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == expenseTypeTextField {
            hideKeyboard()
            displayTransactionType()
            
            if textField.text == "", ValidateExpenseType() {
                textField.text = expenseTypes[0]
            }
            
            return false
        }
        
        if textField == expenseDateTextField {
            hideKeyboard()
            displayTransactionDate()
            return false
        }
        
        hideTransactionPicker()
        return true
    }
}

