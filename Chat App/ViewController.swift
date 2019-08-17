//
//  ViewController.swift
//  Chat App
//
//  Created by Marek Garczewski on 15/08/2019.
//  Copyright © 2019 Marek Garczewski. All rights reserved.
//

import UIKit
import FirebaseAuth
class ViewController: UIViewController {

    @IBOutlet weak var newUsername: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func loginButton_click(_ sender: UIButton) {
        
        let email: String = "test1@gmail.com"
        let password: String = "testowanie"
        
        
    }
    
    @IBAction func createAccountButton_click(_ sender: UIButton) {
        
        if (email.text! != "") && (newUsername.text! != "") && (password.text! != "") {
            Auth.auth().createUser(withEmail: email.text!, password: password.text!) {
                (result, error) in
                if (error != nil) {
                    print("Error with creating acc")
                } else {
                    print("Acc created!")
                }
            }
        } else {
            print("Fill all required blanks")
        }
    }
}
