//
//  LoginTableViewController.swift
//  Mengo
//
//  Created by Macbook Air 13 on 23.03.2021.
//

import UIKit

class LoginTableViewController: UITableViewController {


    @IBOutlet var loginTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()


    }

    @IBAction func closeAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func loginAction(_ sender: UIButton) {
    }
    
    @IBAction func registerAction(_ sender: UIButton) {
    }
    
}
