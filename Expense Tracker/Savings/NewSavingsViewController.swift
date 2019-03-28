//
//  NewSavingsViewController.swift
//  Expense Tracker
//
//  Created by madi on 3/25/19.
//  Copyright © 2019 com.madi.budget. All rights reserved.
//

import CoreData
import UIKit

class NewSavingsViewController: UIViewController {
    
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var calendarButton: UIButton!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var repeatLabel: UILabel!
    @IBOutlet weak var repeatSwitch: UISwitch!
    @IBOutlet weak var savingsTextField: UITextField!
    
    fileprivate var managedContext: NSManagedObjectContext!
    
    lazy var backdropView: UIView = {
        let bdView = UIView(frame: self.view.bounds)
        bdView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        return bdView
    }()
    
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
        
        dateTextField.isHidden = true
        calendarButton.isHidden = false
        
        view.addSubview(backdropView)
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        let heightConstraint = contentView.heightAnchor.constraint(equalToConstant: view.frame.size.height / 2 + 50)
        let topConstraint = contentView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.size.height/2 - 50)
        NSLayoutConstraint.activate([heightConstraint, topConstraint])
        view.addConstraints([heightConstraint, topConstraint])
        
        view.backgroundColor = .clear
        view.isOpaque = false
        contentView.layer.cornerRadius = 15
        view.addSubview(contentView)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(gesture:)))
        view.addGestureRecognizer(tap)
        
        savingsTextField.becomeFirstResponder()
    }
    
    @objc
    func handleTap(gesture: UITapGestureRecognizer) {
        let targetArea = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height/2 - 50)
        
        let tap = gesture.location(in: view)
        
        if targetArea.contains(tap) {
            closeView()
        }
    }
    
    @IBAction func calendarButtonTapped(_ sender: Any) {
        calendarButton.isHidden = true
        dateTextField.isHidden = false
        
        dateTextField.becomeFirstResponder()
    }
    
    @IBAction func repeatSwitchTapped(_ sender: Any) {
        if repeatSwitch.isOn {
            repeatLabel.isHidden = false
        } else {
            repeatLabel.isHidden = true
        }
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        if validSavings() {
            var month = Date().month
            var year = Date().year
            var monthWithMM = Int(Date().monthWithMM)
            
            if calendarButton.isHidden {
                let dateVal: String = dateTextField.text!
                monthWithMM = Int(String(dateVal.prefix(2)))
                let monthVal = monthWithMM! - 1
                year = Int64(String(dateVal.suffix(2)))! + 2000
                month = DateFormatter().monthSymbols[monthVal]
            }
            
            Savings.save(type: savingsTextField.text!, amount: amountTextField.text!, month: month, year: year, context: managedContext) { (error) in
                if let error = error {
                    print("Some error occured while saving, \(error.description)")
                } else {
                    if self.repeatSwitch.isOn {
                        RepeatSavings.save(type: self.savingsTextField.text!, month: Int64(monthWithMM!), year: Int64(year), context: self.managedContext)
                    }
                }
                
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loadSavings"), object: nil)
                self.closeView()
            }
        } else {
            closeView()
        }
        
    }
    
    func closeView() {
        backdropView.backgroundColor = .clear
        
        view.endEditing(true)
        
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    func validSavings() -> Bool {
        let isSavingsHasText = savingsTextField.text != ""
        let isAmountHasText = amountTextField.text != ""
        let calendarHasText = calendarButton.isHidden == true ? dateTextField.text != "" : true
        
        return isSavingsHasText && isAmountHasText && calendarHasText
    }
}

extension NewSavingsViewController: UITextFieldDelegate {
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
