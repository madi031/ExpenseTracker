//
//  EditExpenseTypeViewController.swift
//  Expense Tracker
//
//  Created by madi on 4/4/19.
//  Copyright © 2019 com.madi.budget. All rights reserved.
//

import CoreData
import UIKit

class EditExpenseTypeViewController: UIViewController {
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var typeTextField: UITextField!
    @IBOutlet weak var limitTextField: UITextField!
    
    fileprivate var managedContext: NSManagedObjectContext!
    
    lazy var backdropView: UIView = {
        let bdView = UIView(frame: self.view.bounds)
        bdView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        return bdView
    }()
    
    var typeText: String = ""
    var limitText:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        managedContext = appDelegate.persistentContainer.viewContext
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        view.addSubview(backdropView)
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        let heightConstraint = contentView.heightAnchor.constraint(equalToConstant: view.frame.size.height / 2 + 30)
        let topConstraint = contentView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.size.height/2 - 30)
        NSLayoutConstraint.activate([heightConstraint, topConstraint])
        view.addConstraints([heightConstraint, topConstraint])
        
        view.backgroundColor = .clear
        view.isOpaque = false
        contentView.layer.cornerRadius = 15
        view.addSubview(contentView)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(gesture:)))
        view.addGestureRecognizer(tap)
        
        typeTextField.becomeFirstResponder()
    }
    
    @objc
    func handleTap(gesture: UITapGestureRecognizer) {
        let targetArea = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height/2 - 30)
        
        let tap = gesture.location(in: view)
        
        if targetArea.contains(tap) {
            closeView()
        }
    }
    
    @IBAction func addButtonTapped(_ sender: Any) {
    }
    
    func closeView() {
        backdropView.backgroundColor = .clear
        
        view.endEditing(true)
        
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
}
