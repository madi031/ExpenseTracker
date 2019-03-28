//
//  SavingsViewController.swift
//  Expense Tracker
//
//  Created by madi on 3/25/19.
//  Copyright © 2019 com.madi.budget. All rights reserved.
//

import UIKit

class SavingsViewController: UIViewController {
    
    @IBOutlet weak var buttonView: UIView!
    
    var today = Date()
    var monthDisplayed: String = ""
    var yearDisplayed: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buttonView.layer.cornerRadius = 20
        
        buttonView.translatesAutoresizingMaskIntoConstraints = false
        let tabBarHeight = self.tabBarController?.tabBar.frame.size.height ?? 0
        let bottomConstraint = buttonView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -(tabBarHeight+20))
        NSLayoutConstraint.activate([bottomConstraint])
        view.addConstraint(bottomConstraint)
        
        today = Date()
        
        monthDisplayed = today.month
        yearDisplayed = Int(today.year)
        
        navigationItem.title = "\(monthDisplayed), \(yearDisplayed)"
    }
    
    @IBAction func addSavingsTapped(_ sender: Any) {
        performSegue(withIdentifier: "newSavingsSegue", sender: self)
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        today = Calendar.current.date(byAdding: .month, value: -1, to: today)!
        
        monthDisplayed = today.month
        yearDisplayed = Int(today.year)
        
        navigationItem.title = "\(monthDisplayed), \(yearDisplayed)"
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "backButtonTapped"), object: nil)
    }
    
    @IBAction func nextButtonTapped(_ sender: Any) {
        today = Calendar.current.date(byAdding: .month, value: 1, to: today)!
        
        monthDisplayed = today.month
        yearDisplayed = Int(today.year)
        
        navigationItem.title = "\(monthDisplayed), \(yearDisplayed)"
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "nextButtonTapped"), object: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? SavingsTableViewController, segue.identifier == "SavingsTableViewSegue" {
            destinationVC.today = today
        }
    }
}
