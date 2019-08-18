//
//  ChatViewController.swift
//  Chat App
//
//  Created by Marek Garczewski on 18/08/2019.
//  Copyright © 2019 Marek Garczewski. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class ChatViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var messages = [[String : String]]()
    @IBOutlet weak var messageText: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(lookForNewData), userInfo: nil, repeats: true)
        self.messageText.delegate = self
        tableView.separatorStyle = .none
        // Do any additional setup after loading the view.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return messages.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let double = messages[indexPath.row]
        if double.first?.value == Auth.auth().currentUser?.uid {
            cell.textLabel!.text = double.first?.key
            cell.textLabel!.textAlignment = .right
        } else {
            cell.textLabel!.textAlignment = .left
            cell.textLabel!.text = double.first?.key
        }
        
        return cell
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
        
    }
    
    @objc func lookForNewData() {
        
        var ref: DatabaseReference!
        ref = Database.database().reference()
        
        ref.child("users").child("messages").observe(.value){ (snapshot) in
            
            if (snapshot.value != nil) {
                for i in snapshot.children {
                    let messageSnapshot = i as! DataSnapshot
                    let newMessages = messageSnapshot.value as! [String : String]
                    if (self.messages.contains(newMessages) != true) {
                        self.messages.append(newMessages)
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
    
    
    @IBAction func sendButton_click(_ sender: UIButton) {
        var ref: DatabaseReference!
        ref = Database.database().reference()
        
        let userID = Auth.auth().currentUser!.uid
        
        if messageText.text?.isEmpty != true {
            ref.child("users").child("messages").childByAutoId().setValue([messageText.text : userID])
            
            
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
