//
//  RegisterViewController.swift
//  Coco
//
//  Created by Hugo Prinsloo on 2018/04/02.
//  Copyright © 2018 Over. All rights reserved.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController {

    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var email: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func handleRegisterTapped(_ sender: UIButton) {
        guard let username = userName.text else { return }
        guard let password = password.text else { return }
        guard let email = email.text else { return }
        
//        Auth.auth().createUser(withEmail: email, password: password) { user, error in
//            if error == nil && user != nil {
//                
//            }
//        }
    }
}
