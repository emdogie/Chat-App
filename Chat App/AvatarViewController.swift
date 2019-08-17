//
//  AvatarViewController.swift
//  Chat App
//
//  Created by Marek Garczewski on 17/08/2019.
//  Copyright © 2019 Marek Garczewski. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
class AvatarViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func firstAvatar_click(_ sender: UIButton) {
        updatePhoto(numberOfPhoto: "1")
    }
    
    @IBAction func secondAvatar_click(_ sender: UIButton) {
        updatePhoto(numberOfPhoto: "2")
    }
    @IBAction func thirdAvatar_click(_ sender: UIButton) {
        updatePhoto(numberOfPhoto: "3")
    }
    
    func updatePhoto(numberOfPhoto: String) {
        var ref: DatabaseReference!
        ref = Database.database().reference()
        
        let userID = Auth.auth().currentUser!.uid
        
        ref.child("users").child(userID).child("photo").setValue(numberOfPhoto)
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
