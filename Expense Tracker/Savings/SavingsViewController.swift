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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buttonView.layer.cornerRadius = 20
        
        buttonView.translatesAutoresizingMaskIntoConstraints = false
        let tabBarHeight = self.tabBarController?.tabBar.frame.size.height ?? 0
        let bottomConstraint = buttonView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -(tabBarHeight+20))
        NSLayoutConstraint.activate([bottomConstraint])
        view.addConstraint(bottomConstraint)
    }
    
    @IBAction func addSavingsTapped(_ sender: Any) {
        performSegue(withIdentifier: "newSavingsSegue", sender: self)
    }
}
