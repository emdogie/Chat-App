//
//  ViewController.swift
//  Chat App
//
//  Created by Marek Garczewski on 15/08/2019.
//  Copyright © 2019 Marek Garczewski. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
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
                    self.showAlert(withMessage: "Please check that you entered valid email and password", withTitle: "Error")
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
                    self.showAlert(withMessage: "Please check that you entered valid email", withTitle: "Error")
                    print("Error with creating account")
                } else {
                    self.showAlert(withMessage: "Account created!", withTitle: "Good job!")
                    print("Account created!")
                    self.addUsernameToBase(username: self.newUsername.text!)
                }
            }
        } else {
            self.showAlert(withMessage: "Fill all required blanks", withTitle: "Error")
            print("Fill all required blanks")
        }
    }
    
    func showAlert(withMessage message: String, withTitle title: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true)
        
    }
    
    func addUsernameToBase(username: String) {
        var ref: DatabaseReference!
        ref = Database.database().reference()
        
        let userID = Auth.auth().currentUser!.uid
        
        ref.child("users").child(userID).child("username").setValue(username)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
       
        textField.resignFirstResponder()
        return true
        
    }
    
}
