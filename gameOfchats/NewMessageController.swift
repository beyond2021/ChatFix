//
//  NewMessageController.swift
//  gameOfchats
//
//  Created by Kev1 on 4/4/17.
//  Copyright © 2017 Kev1. All rights reserved.
//

import UIKit
import Firebase

class NewMessageController: UITableViewController {
    let cellId = "cellId"
    var users = [User]() // create the model. any emptyy array of type users

    override func viewDidLoad() {
        super.viewDidLoad()
        //adding the cancel button
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        //REGISTERING THE CUSTOM CELL
        tableView.register(UserCell.self, forCellReuseIdentifier: cellId)
        // I wann get all the users
        fetchUser()
        
        
        
        
    }
    
   
    func handleCancel(){
        self.dismiss(animated: true, completion: nil)
    }
    
    func fetchUser() {
        //observe all the users
        FIRDatabase.database().reference().child("users").observe(.childAdded, with: { (snapshot) in
            // This fetches all of the users
         //   print("User Found")
            // lets add all of these users into an array
        //    print(snapshot)
            // there is a dictionay value of every snapshot
            //Break point hre to get the list of snapshots
            if let dictionary = snapshot.value as? [String : AnyObject] {
                
                //here we loa d the list of users
               
                
                let user = User() // a brand new user
                
                //lets set the id for the user here
                user.id = snapshot.key //SET
                user.setValuesForKeys(dictionary)// creating a user from the snapshot dictionary.
                // IF U USE THE SETTER ABOVE YOUR APP WILL CRASH IF YOUR CLASS PROPERTIES DONT EXACTLY MATCHUP WITH THE FIREBASE DICTIONARY KEYS
                
                //ALTERNATE
        //        user.name = dictionary["name"] as? String
         //       user.email = dictionary["email"] as? String
             
                //NOW WE HAVE USER WE CAN ADD IT TO THE ARRAY
                self.users.append(user)
                
                
                // this will crash because we are access the tableview from a backgropund thread, so lets use dispatch_async to fix
                DispatchQueue.main.async(execute: { 
                    self.tableView.reloadData() // here we get themain thread and reload the tableview. now we can use users.count
                })
                
                
                
                
                print(user.name ?? "There is no name", user.email ?? "there is no email")
                
            }
        }, withCancel: nil)
        
    }
    
    
    //MARK:- table View life cycle
    //give the cell some space
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // lets use a hack for now
    //    let cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellId)
       // let cell = UserCell(style: .subtitle, reuseIdentifier: cellId) as UserCell
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! UserCell
        
        // this is a hack because we need to deque our cells for maximum efficiency
        // get the labels
        
        // get reference to user
        let user =  users[indexPath.row]
        cell.textLabel?.text = user.name
        cell.detailTextLabel?.text = user.email
        
  //      cell.imageView?.image = UIImage(named: "AdobeStock_85371460") // placeholder
        // fixing the squished images
  //      cell.imageView?.contentMode = .scaleAspectFill
        
        //How do  we get and download images from our users
        //1: get the imageUrl
        if let profileImageUrl = user.profileImageUrl {
            
            cell.proileImageView.loadImageUsingCacheWithUrlString(urlString: profileImageUrl)
           // this will safely unwrap
            //2: start up an NSURL session
            //let config = URLSessionConfiguration.default
            //let session = URLSession(configuration: config)
            //SWIFT3
            
                       
            
        }
        
        //Get The default imageView For The Cell
       // cell.imageView?.image = UIImage(named: "AdobeStock_85371460")
        
        
        return cell
    }
    //slide Down the controller when cell is selected
    
    var messagesController : MessagesController?
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dismiss(animated: true) { 
            print("Dismiss Completed")
            // after we are dismissed now we want to push chatcontroller on to navigation stack.
            
            //  //Let find the user that was tapped
            let user = self.users[indexPath.row]
            
            
            self.messagesController?.showChatControllerForUser(user: user) // mes contrl is nil so nothing will happen
            //so we want to set mess contrl everytime we hit the button.  MESSAGE CONTROLLER HAD TO SET IT IN handleNewMessage:
            
           
            
            
            
            
        }
    }
}
