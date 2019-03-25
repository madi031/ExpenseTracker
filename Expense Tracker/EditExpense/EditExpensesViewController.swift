//
//  EditExpensesViewController.swift
//  Expense Tracker
//
//  Created by madi on 3/24/19.
//  Copyright © 2019 com.madi.budget. All rights reserved.
//

import CoreData
import UIKit

class EditExpensesViewController: UIViewController {
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var typeTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var typePicker: UIPickerView!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var name: String = ""
    var amount: Decimal = 0
    var type: String = ""
    var date: Date = Date()
    var id: Int = 0
    
    var expenseTypes = [String]()
    
    fileprivate let dateFormatter = DateFormatter()
    fileprivate var managedContext: NSManagedObjectContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        managedContext = appDelegate.persistentContainer.viewContext
        
        dateFormatter.dateFormat = "dd MMM yyyy"
        hideTransactionPicker()
        
        amountTextField.delegate = self
        dateTextField.delegate = self
        nameTextField.delegate = self
        typeTextField.delegate = self
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(gesture:)))
        tapGesture.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapGesture)
        
        datePicker.addTarget(self, action: #selector(handleDatePicker(sender:)), for: .valueChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        nameTextField.text = name
        amountTextField.text = "\(amount)"
        typeTextField.text = type
        dateTextField.text = date.toString()
        
        typePicker.delegate = self
        typePicker.dataSource = self
        
        loadExistingTypes()
        
        datePicker.date = date
        let index = expenseTypes.firstIndex(of: type) ?? 0
        typePicker.selectRow(index, inComponent: 0, animated: true)
    }
    
    @objc
    func handleDatePicker(sender: UIDatePicker) {
        dateTextField.text = dateFormatter.string(from: sender.date)
    }
    
    @objc
    func handleTap(gesture: UITapGestureRecognizer) {
        self.view.endEditing(true)
        hideTransactionPicker()
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        if validExpense() {
            let expense: NSDictionary = [
                TransactionAttributes.amount: amountTextField.text! as Any,
                TransactionAttributes.date: dateFormatter.date(from: dateTextField.text!) as Any,
                TransactionAttributes.name: nameTextField.text as Any,
                TransactionAttributes.type: typeTextField.text as Any
            ]
            
            Transaction.update(byId: id, dict: expense, context: managedContext) { (error) in
                if let error = error {
                    print("Error saving core data, \(error), \(error.description)")
                    let alert = UIAlertController(title: "Oops!!", message: "Error in saving", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Try again!", style: .default, handler: { _ in
                        // do nothing
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
                self.popVC()
            }
        } else {
            let alert = UIAlertController(title: "Oops!!", message: "Details are missing", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Let me fill again!", style: .default, handler: { _ in
                // do nothing
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func deleteButtonPressed(_ sender: Any) {
        Transaction.delete(byId: id, context: managedContext) { error in
            if error == nil {
                self.popVC()
            }
        }
    }
    
    func popVC() {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    func displayTransactionDate() {
        datePicker.isHidden = false
        typePicker.isHidden = true
    }
    
    func displayTransactionType() {
        datePicker.isHidden = true
        typePicker.isHidden = false
    }
    
    func hideKeyboard() {
        amountTextField.resignFirstResponder()
        nameTextField.resignFirstResponder()
    }
    
    func hideTransactionPicker() {
        datePicker.isHidden = true
        typePicker.isHidden = true
    }
    
    func loadExistingTypes() {
        expenseTypes = ExpenseType.fetch(context: managedContext)
    }
    
    func validExpense() -> Bool {
        if amountTextField.text != "", nameTextField.text != "", typeTextField.text != "" {
            return true
        }
        return false
    }
}

extension EditExpensesViewController: UIPickerViewDelegate, UIPickerViewDataSource {
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
        typeTextField.text = expenseTypes[row]
    }
}

extension EditExpensesViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == typeTextField {
            hideKeyboard()
            displayTransactionType()
            return false
        }
        
        if textField == dateTextField {
            hideKeyboard()
            displayTransactionDate()
            return false
        }
        
        hideTransactionPicker()
        return true
    }
}
