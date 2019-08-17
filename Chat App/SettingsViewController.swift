//
//  SettingsViewController.swift
//  Chat App
//
//  Created by Marek Garczewski on 16/08/2019.
//  Copyright © 2019 Marek Garczewski. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
class SettingsViewController: UIViewController {

    @IBOutlet weak var avatarImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        updateAvatar()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateAvatar()
    }
    
    func updateAvatar() {
        var ref: DatabaseReference!
        ref = Database.database().reference()
        
        let userID = Auth.auth().currentUser!.uid
        
        ref.child("users").child(userID).child("photo").observe(.value) { (snapshot) in
            
            if let avatarNumber = snapshot.value as? String {
                self.chooseAvatar(number: avatarNumber)
            }
        }
    }
    
    func chooseAvatar(number: String) {
        switch number {
        case "1":
            avatarImageView.image = UIImage(named: "1avatar")
        case "2":
            avatarImageView.image = UIImage(named: "2avatar")
        case "3":
            avatarImageView.image = UIImage(named: "3avatar")
        default:
            return
        }
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
