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

    override func viewDidLoad() {
        super.viewDidLoad()
        updateTitle()
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
        return 3
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

         cell.textLabel?.text = "test"

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
    
    @IBAction func goToConversation(_ sender: UIButton) {
        performSegue(withIdentifier: "showConversation", sender: self)
    }
    

}
