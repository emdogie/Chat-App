//
//  ProfileTableViewController.swift
//  Chat App
//
//  Created by Marek Garczewski on 16/08/2019.
//  Copyright © 2019 Marek Garczewski. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
class ProfileTableViewController: UITableViewController {

    var users = [[String : String]]()
    var chatDestinationUsername: String?
    var chatDestinationUid: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateTitle()
        updateUsers()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return users.count
    }

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let usernameAndId = users[indexPath.row]
        chatDestinationUsername = usernameAndId.first?.key
        chatDestinationUid = usernameAndId.first?.value
        performSegue(withIdentifier: "showConversation", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is ChatViewController{
            let vc = segue.destination as! ChatViewController
            vc.chatWithUsername = chatDestinationUsername!
            vc.chatWithUid = chatDestinationUid!
        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

         let usernameAndId = users[indexPath.row]
         cell.textLabel?.text = usernameAndId.first?.key

        return cell
    }
    
    func updateTitle() {
        
        var ref: DatabaseReference!
        ref = Database.database().reference()
        
        let userID = Auth.auth().currentUser!.uid
        
        ref.child("users").child(userID).child("username").observe(.value) { (snapshot) in
            
            if let userName = snapshot.value as? String {
                self.title = "Hello \(userName)!"
            }
        }
    }

    @IBAction func logoutButton_click(_ sender: UIBarButtonItem) {
        
        do {
            try Auth.auth().signOut()
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            // vc is the Storyboard ID that you added
            // as! ... Add your ViewController class name that you want to navigate to
            let controller = storyboard.instantiateViewController(withIdentifier: "vc") as! ViewController
            self.present(controller, animated: true, completion: { () -> Void in
            })
            print("Logout!")
        }
        catch {
            print("Error with loggin out")
            let alert = UIAlertController(title: "Error", message: "Error with logging out", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Try again", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
    }
    

    func updateUsers() {
        var ref: DatabaseReference!
        ref = Database.database().reference()
        
        ref.child("users").observe(.value) { (snapshot) in
            
            for child in snapshot.children {
                let snap = child as! DataSnapshot
                let usernames = snap.value as! [String : String]
                let username = usernames.values.first!
                let userID = snap.key
                self.users.append([username : userID])
            }
            self.tableView.reloadData()
        }
        
        
       
    }

}
