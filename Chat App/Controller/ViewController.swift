//
//  ViewController.swift
//  Chat App
//
//  Created by Marek Garczewski on 15/08/2019.
//  Copyright © 2019 Marek Garczewski. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func loginButton_click(_ sender: UIButton) {
        
        self.performSegue(withIdentifier: "showProfile", sender: sender)
    }
    
}
