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
    
    @IBOutlet weak var saveButton: UIButton!
    fileprivate let dateFormatter = DateFormatter()
    fileprivate var managedContext: NSManagedObjectContext!
    
    var expenseTypeFromSegue: String = ""
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadExistingTypes()
        transactionTypePicker.delegate = self
        transactionTypePicker.dataSource = self
        
        transactionTypePicker.selectRow(0, inComponent: 0, animated: true)
        
        if expenseTypes.count == 0 {
            expenseTypeTextField.text = ""
        }
        
        if expenseTypeFromSegue != "" {
            expenseTypeTextField.text = expenseTypeFromSegue
            expenseTypeTextField.isUserInteractionEnabled = false
        }
        
        expenseNameTextField.becomeFirstResponder()
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
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        if validExpense() {
            let transaction: NSDictionary = [
                TransactionAttributes.amount: expenseAmountTextField.text! as Any,
                TransactionAttributes.date: dateFormatter.date(from: expenseDateTextField.text!) as Any,
                TransactionAttributes.name: expenseNameTextField.text!,
                TransactionAttributes.type: expenseTypeTextField.text!
            ]
            
            Transaction.save(dict: transaction, context: managedContext) { (error) in
                if let error = error {
                    print("Error saving core data, \(error), \(error.description)")
                    let alert = UIAlertController(title: "Oops!!", message: "Error in saving", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Try again!", style: .default, handler: { _ in
                        // do nothing
                    }))
                    self.present(alert, animated: true, completion: nil)
                    return
                }
                self.clearTransaction()
                if self.expenseTypeFromSegue == "" {
                    self.tabBarController?.selectedIndex = 1
                } else {
                    self.hideKeyboard()
                    self.navigationController?.popViewController(animated: true)
                    self.dismiss(animated: true, completion: nil)
                }
            }
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
        
        transactionTypePicker.selectRow(0, inComponent: 0, animated: true)
        transactionDatePicker.date = Date()
        
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
            self.tabBarController?.selectedIndex = 0
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

