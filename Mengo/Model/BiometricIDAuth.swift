//
//  BiometricIDAuth.swift
//  Mengo
//
//  Created by Macbook Air 13 on 23.03.2021.
//

import Foundation
import LocalAuthentication

class BiometricIDAuth {
    
    private let context = LAContext()
    private let policy: LAPolicy
    private let localizedReason: String
    
    private var error: NSError?
    
    init(policy: LAPolicy = .deviceOwnerAuthenticationWithBiometrics,
         localizedReason: String = "Verity your Identity " ,
         localizedFallCallBack: String = "Enter App Password",
         localizedCanceTitle: String = "Touch me not") {
        self.policy = policy
        self.localizedReason = localizedReason
        context.localizedCancelTitle = localizedCanceTitle
        context.localizedFallbackTitle = localizedFallCallBack
    }
    
    private func biometricType(for type: LABiometryType) -> BiometricType {
        switch type {
        case .none:
            return .none
        case.faceID:
            return .faceID
        case .touchID:
            return .touchID
        @unknown default:
            return .unknown
        }
    }
    
    private func biometricError(from nsError: NSError) -> BiometricError {
        let error: BiometricError
        
        switch nsError {
        case LAError.appCancel:
            error = .userCancel
        case LAError.authenticationFailed :
            error = .authenticationError
        case LAError.biometryLockout:
            error = .biometryLockout
        case LAError.biometryNotAvailable:
            error = .biometryNotAvailable
        case LAError.biometryNotEnrolled:
            error = .biometryNotEnrolled
        case LAError.userFallback:
            error = .userFallCall
        default:
            error = .unknown
            
        }
        return error
    }
    
    func canEvaluate(completion: (Bool, BiometricType, BiometricError?) -> Void) {
        // Asks Context if it can evaluate a Policy
        // Passes an Error pointer to get error code in case of failure
        guard context.canEvaluatePolicy(policy, error: &error) else {
            // Extracts the LABiometryType from Context
            // Maps it to our BiometryType
            let type = biometricType(for: context.biometryType)
            
            // Unwraps Error
            // If not available, sends false for Success & nil in BiometricError
            guard let error = error else {
                return completion(false, type, nil)
            }
            
            // Maps error to our BiometricError
            return completion(false, type, biometricError(from: error))
        }
        
        // Context can evaluate the Policy
        completion(true, biometricType(for: context.biometryType), nil)
    }
    
    func evaluate(completion: @escaping (Bool, BiometricError?) -> Void) {
        // Asks Context to evaluate a Policy with a LocalizedReason
        context.evaluatePolicy(policy, localizedReason: localizedReason) { [weak self] success, error in
            // Moves to the main thread because completion triggers UI changes
            DispatchQueue.main.async {
                if success {
                    // Context successfully evaluated the Policy
                    completion(true, nil)
                } else {
                    // Unwraps Error
                    // If not available, sends false for Success & nil for BiometricError
                    guard let error = error else { return completion(false, nil) }
                    
                    // Maps error to our BiometricError
                    completion(false, self?.biometricError(from: error as NSError))
                }
            }
        }
    }
    
}

enum BiometricType {
    case none
    case touchID
    case faceID
    case unknown
}

enum BiometricError: LocalizedError  {
    case authenticationError
    case userCancel
    case userFallCall
    case biometryNotAvailable
    case biometryNotEnrolled
    case biometryLockout
    case unknown
    
    var errorDescription: String? {
        switch self {
        
        case .authenticationError:
            return "There was a problem verifying your identity."
        case .userCancel:
            return "You pressed cancel."
        case .userFallCall:
            return "You pressed password."
        case .biometryNotAvailable:
            return "Face ID/ Touch ID is not available."
        case .biometryNotEnrolled:
            return "Face ID/ Touch ID is not set up."
        case .biometryLockout:
            return "Face Id/ Touch Id is locked."
        case .unknown:
            return "Face ID/Touch ID may not be configured"
        }
    }
    
}
