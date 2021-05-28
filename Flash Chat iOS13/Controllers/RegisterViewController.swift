//
//  RegisterViewController.swift
//  Flash Chat iOS13
//
//  Created by Dusan Savic on 14/3/21.
//  Copyright © 2021 Dusan Savic. All rights reserved.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController {

    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    
    @IBAction func registerPressed(_ sender: UIButton) {
		if let email = emailTextfield.text, let password = passwordTextfield.text {
		
		Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
			if let e = error {
				print(e.localizedDescription)
			} else {
				self.performSegue(withIdentifier: K.registerSegue, sender: self)
			
			}
		}
    }
    
}
}
