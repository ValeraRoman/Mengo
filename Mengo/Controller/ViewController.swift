//
//  ViewController.swift
//  Mengo
//
//  Created by Macbook Air 13 on 23.03.2021.
//

import UIKit

class ViewController: UIViewController {

    private let biometricIDAuth = BiometricIDAuth()

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }



    @IBAction func tap(_ sender: UIButton) {
        callBio()

    }
    
    func callBio(){
        biometricIDAuth.canEvaluate { (canEvaluate, _, canEvaluateError) in
            guard canEvaluate else {
                let alert = UIAlertController(title: "Failed", message: "Please try again.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)

                return
            }
            
            biometricIDAuth.evaluate { [weak self] (success, error) in
                guard success else {
                    // Face ID/Touch ID may not be configured
                    return
                }
         
                if success {
                    let vc = UIViewController()
                    vc.title = "welcome"
                    vc.view.backgroundColor = .blue
                    self?.present(vc, animated: true, completion: nil)
                    print("success")
                }
            }
        }
    }
}


