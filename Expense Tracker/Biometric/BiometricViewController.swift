//
//  BiometricViewController.swift
//  Expense Tracker
//
//  Created by madi on 3/27/19.
//  Copyright © 2019 com.madi.budget. All rights reserved.
//

import UIKit

class BiometricViewController: UIViewController {
    
    @IBOutlet weak var authenticateButton: UIButton!
    
    let touchMe = BiometricIDAuthentication()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        switch touchMe.biometricType() {
        case .faceID:
            authenticateButton.setImage(UIImage(named: "FaceID"), for: .normal)
        default:
            authenticateButton.setImage(UIImage(named: "TouchID"), for: .normal)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        loginAction()
    }
    
    func loginAction() {
        touchMe.autheticateUser { [weak self] message in
            if let message = message {
                DispatchQueue.main.async {
                    let alertView = UIAlertController(title: "Oops!!", message: message, preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "Darn!", style: .default)
                    alertView.addAction(okAction)
                    self?.present(alertView, animated: true, completion: nil)
                }
            } else {
                self?.performSegue(withIdentifier: "authenticateUserSegue", sender: self)
            }
        }
    }
    
    @IBAction func authenticateButtonTapped(_ sender: Any) {
        loginAction()
    }
}
