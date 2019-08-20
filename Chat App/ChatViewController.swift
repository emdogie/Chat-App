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
    @IBOutlet weak var messageText: UITextField!
    
    var messages = [[String : String]]()
    var chatWithUsername: String = ""
    var chatWithUid: String = ""
    var conversationID: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchForConversationBetween(firstID: Auth.auth().currentUser!.uid, secondID: chatWithUid)
        Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(lookForNewData), userInfo: nil, repeats: true)
        self.messageText.delegate = self
        tableView.separatorStyle = .none
        // Do any additional setup after loading the view.
    }
    
    func searchForConversationBetween(firstID: String, secondID: String) {
        
        var conversations = [String]()
        var ref: DatabaseReference!
        ref = Database.database().reference()
        let firstOption = firstID + secondID
        let secondOption = secondID + firstID
        ref.child("messages").observe(.value) { (snapshot) in
            if (snapshot.value != nil) {
                for i in snapshot.children {
                    let convIds = i as! DataSnapshot
                    let convID = convIds.key
                    if conversations.contains(convID) != true {
                        conversations.append(convID)
                    }
                    
                }
            }
            if conversations.contains(firstOption){
                self.conversationID = firstOption
            }
            else if conversations.contains(secondOption) {
                self.conversationID = secondOption
            }
            else {
                ref.child("messages").child(firstOption).setValue("")
            }
        }
        
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
            cell.backgroundColor = UIColor(red: 0/255, green: 122/255, blue: 255/255, alpha: 1)
            cell.textLabel?.textColor = UIColor.white
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
        
        ref.child("messages").child(conversationID).observe(.value){ (snapshot) in
            
            if (snapshot.value != nil) {
                for i in snapshot.children {
                    let messageSnapshot = i as! DataSnapshot
                    let message = messageSnapshot.value! as! [String : String]
                    if self.messages.contains(message) != true {
                        self.messages.append(message)
                    }
                    
                }
            }
        }
        tableView.reloadData()
    }
    
    
    @IBAction func sendButton_click(_ sender: UIButton) {
        var ref: DatabaseReference!
        ref = Database.database().reference()
        
        let userID = Auth.auth().currentUser?.uid
        
        if messageText.text?.isEmpty != true {
            ref.child("messages").child(self.conversationID).childByAutoId().setValue([self.messageText.text! : userID])
        }
        
    }
    

}
