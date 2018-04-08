//
//  LoginViewController.swift
//  Coco
//
//  Created by Hugo Prinsloo on 2018/04/03.
//  Copyright © 2018 Over. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func handleLoginButtonTapped(_ sender: UIButton) {
        guard let email = emailTextField.text else { return }
        guard let pass = passwordTextField.text else { return }
        
        Auth.auth().signIn(withEmail: email, password: pass) { (user, error) in
            if error == nil && user != nil {
                DispatchQueue.main.async {
                    self.navigationController?.dismiss(animated: true, completion: nil)
                }
            } else {
                print("Failed to login with error: \(String(describing: error))")
            }
        }
    }
    
}
