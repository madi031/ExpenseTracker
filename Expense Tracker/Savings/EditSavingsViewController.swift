//
//  EditSavingsViewController.swift
//  Expense Tracker
//
//  Created by madi on 3/26/19.
//  Copyright © 2019 com.madi.budget. All rights reserved.
//

import CoreData
import UIKit

class EditSavingsViewController: UIViewController {
    
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var repeatSwitch: UISwitch!
    @IBOutlet weak var savingsTextField: UITextField!
    
    fileprivate var managedContext: NSManagedObjectContext!
    
    var amount: Decimal = 0
    var id: Int = 0
    var month: String = ""
    var isRepeatEnabled = true
    var type: String = ""
    var year: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        managedContext = appDelegate.persistentContainer.viewContext
        
        dateTextField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        amountTextField.text = "\(amount)"
        savingsTextField.text = type
        dateTextField.text = "\(month)/\(year)"
        
        if isRepeatEnabled {
            repeatSwitch.setOn(true, animated: true)
        } else {
            repeatSwitch.setOn(false, animated: true)
        }
        
        savingsTextField.becomeFirstResponder()
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        resignResponders()
        popVC()
    }
    
    @IBAction func deleteButtonTapped(_ sender: Any) {
        resignResponders()
        if savingsTextField.text != "" {
            Savings.delete(type: type, context: managedContext) { (error) in
                if let error = error {
                    print("Error deleting, \(error.description)")
                } else {
                    RepeatSavings.delete(type: self.type, context: self.managedContext)
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
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        resignResponders()
        if validSavings() {
            let dateVal: String = dateTextField.text!
            let monthWithMM = Int(String(dateVal.prefix(2)))!
            let monthVal = monthWithMM - 1
            let yearVal = Int64(String(dateVal.suffix(2)))! + 2000
            month = DateFormatter().monthSymbols[monthVal]
            
            if id == -1 {
                Savings.save(type: savingsTextField.text!, amount: amountTextField.text!, month: month, year: yearVal, context: managedContext) { (error) in
                    if let error = error {
                        print("Some error occured while saving, \(error.description)")
                        
                        let alert = UIAlertController(title: "Oops!!", message: "Error in saving", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Try again!", style: .default, handler: { _ in
                            // do nothing
                        }))
                        self.present(alert, animated: true, completion: nil)
                    } else {
                        if self.repeatSwitch.isOn {
                            RepeatSavings.save(type: self.savingsTextField.text!, month: Int64(monthWithMM), year: Int64(yearVal), context: self.managedContext)
                        }
                        self.popVC()
                    }
                }
            } else {
                Savings.update(byId: id, type: savingsTextField.text!, amount: amountTextField.text!, month: month, year: yearVal, context: managedContext) { (error) in
                    if let error = error {
                        print("Error saving core data, \(error), \(error.description)")
                        let alert = UIAlertController(title: "Oops!!", message: "Error in saving", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Try again!", style: .default, handler: { _ in
                            // do nothing
                        }))
                        self.present(alert, animated: true, completion: nil)
                    } else {
                        if self.repeatSwitch.isOn {
                            RepeatSavings.save(type: self.savingsTextField.text!, month: Int64(monthWithMM), year: yearVal, context: self.managedContext)
                        } else {
                            RepeatSavings.delete(type: self.savingsTextField.text!, context: self.managedContext)
                            
                        }
                        self.popVC()
                    }
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
    
    func popVC() {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    func resignResponders() {
        amountTextField.resignFirstResponder()
        dateTextField.resignFirstResponder()
        savingsTextField.resignFirstResponder()
    }
    
    func validSavings() -> Bool {
        if amountTextField.text != "", dateTextField.text != "", savingsTextField.text != "" {
            return true
        }
        return false
    }
}

extension EditSavingsViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == dateTextField {
            let  char = string.cString(using: String.Encoding.utf8)!
            let isBackSpace = strcmp(char, "\\b")
            
            if isBackSpace == -92 {
                return true
            }
            
            if textField.text?.count == 2 {
                textField.text?.append("/")
            }
        }
        return true
    }
}
