//
//  ViewController.swift
//  Chat App
//
//  Created by Marek Garczewski on 15/08/2019.
//  Copyright © 2019 Marek Garczewski. All rights reserved.
//

import UIKit
import FirebaseAuth
class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var newUsername: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.newUsername.delegate = self
        self.email.delegate = self
        self.password.delegate = self
    }

    @IBAction func loginButton_click(_ sender: UIButton) {
        
        if (email.text! != "") && (password.text! != "") {
            Auth.auth().signIn(withEmail: email.text!, password: password.text!) {
                (result, error) in
                if (error != nil) {
                    self.showAlert(withMessage: "Please check that you entered valid email and password")
                    print("Error with signing in")
                } else {
                    print("Logging on")
                    self.performSegue(withIdentifier: "showProfile", sender: self)
                }
            }
        }
        
        
    }
    
    @IBAction func createAccountButton_click(_ sender: UIButton) {
        
        if (email.text! != "") && (newUsername.text! != "") && (password.text! != "") {
            Auth.auth().createUser(withEmail: email.text!, password: password.text!) {
                (result, error) in
                if (error != nil) {
                    self.showAlert(withMessage: "Please check that you entered valid email")
                    print("Error with creating account")
                } else {
                    print("Account created!")
                }
            }
        } else {
            self.showAlert(withMessage: "Fill all required blanks")
            print("Fill all required blanks")
        }
    }
    
    func showAlert(withMessage message: String) {
        
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true)
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
       
        textField.resignFirstResponder()
        return true
        
    }
    
}
