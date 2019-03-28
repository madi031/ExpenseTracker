//
//  BiometricIDAuthentication.swift
//  Expense Tracker
//
//  Created by madi on 3/28/19.
//  Copyright © 2019 com.madi.budget. All rights reserved.
//

import LocalAuthentication

class BiometricIDAuthentication {
    let context = LAContext()
    var loginReason = "Prove it is you!!"
    
    enum BiometricType {
        case none
        case faceID
        case touchID
    }
    
    func canEvaluateBiometricPolicy()-> Bool {
        return context.canEvaluatePolicy(.deviceOwnerAuthentication, error: nil)
    }
    
    func autheticateUser(completion: @escaping(String?) -> Void) {
        guard canEvaluateBiometricPolicy() else {
            completion("Touch/Face ID not available")
            return
        }
        
        context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: loginReason) { (success, evaluateError) in
            if success {
                DispatchQueue.main.async {
                    completion(nil)
                }
            } else {
                let message: String
                
                switch evaluateError {
                case LAError.authenticationFailed?:
                    message = "There was a problem verifying your identity."
                case LAError.userCancel?:
                    message = "You pressed cancel."
                case LAError.biometryNotAvailable?:
                    message = "Face ID/Touch ID is not available."
                case LAError.biometryNotEnrolled?:
                    message = "Face ID/Touch ID is not set up."
                case LAError.biometryLockout?:
                    message = "Face ID/Touch ID is locked."
                default:
                    message = "Face ID/Touch ID may not be configured"
                }
                
                completion(message)
            }
        }
    }
    
    func biometricType() -> BiometricType {
        let _ = canEvaluateBiometricPolicy()
        switch context.biometryType {
        case .none:
            return .none
        case .faceID:
            return .faceID
        case .touchID:
            return .touchID
        default:
            return .none
        }
    }
}
