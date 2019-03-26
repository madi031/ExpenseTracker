//
//  NewSavingsViewController.swift
//  Expense Tracker
//
//  Created by madi on 3/25/19.
//  Copyright © 2019 com.madi.budget. All rights reserved.
//

import UIKit

class NewSavingsViewController: UIViewController {
    
    @IBOutlet weak var contentView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        let heightConstraint = contentView.heightAnchor.constraint(equalToConstant: view.frame.size.height / 2)
        let bottomConstraint = contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        let topConstraint = contentView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.size.height/2)
        NSLayoutConstraint.activate([heightConstraint, bottomConstraint, topConstraint])
        view.addConstraints([heightConstraint, bottomConstraint, topConstraint])
        
        view.backgroundColor = .clear
        view.isOpaque = false
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(gesture:)))
        view.addGestureRecognizer(tap)
    }
    
    @objc
    func handleTap(gesture: UITapGestureRecognizer) {
        let targetArea = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height/2)
        
        let tap = gesture.location(in: view)
        
        if targetArea.contains(tap) {
            navigationController?.popViewController(animated: true)
            dismiss(animated: true, completion: nil)
        }
    }
}
