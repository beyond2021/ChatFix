//
//  ViewController.swift
//  gameOfchats
//
//  Created by Kev1 on 4/2/17.
//  Copyright © 2017 Kev1. All rights reserved.
//

import UIKit
import Firebase

class MessagesController: UITableViewController {
    
    let cellId = "cellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isTranslucent = true
        
        self.navigationController!.navigationBar.barTintColor = UIColor(r: 61, g: 91, b: 151)
        
        
        // How to save Data into fireBase
        // 1: allocate Reference
        //    let reference = FIRDatabase.database().reference(fromURL: "https://peephole-6f487.firebaseio.com/")
        //    reference.updateChildValues(["someValue":123123])
        
        // left nav button
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        navigationItem.leftBarButtonItem?.tintColor = .white
        // checking and forcing the user to log in if they are not.
        // When user is not logged in
        
        // Right navbar button
        let image = UIImage(named: "Contacts-50")
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(handleNewMessage))
        navigationItem.rightBarButtonItem?.tintColor = .white
        checkIfUserIsLoggedIn()
        //
        //REGISTERING THE CUSTOM CELL
        tableView.register(UserCell.self, forCellReuseIdentifier: cellId)// register user cell
        //FETCHING FROM THE DATABASE
        // 2 TYPES OF FETCH  SINGLE FETCH AND FETCH ALL
        // SINGLE FETCH FOR NAVIGATION BAR TITLE
        // FETCH ALL TO FILL THE TABLEVIEW
        
        //GET The Messages
        //observeMessages()
        
        // observeUserMessages() // moved to setupnavbarwithuser
        
        tableView.allowsMultipleSelectionDuringEditing = true //swipe to delete 1
        
        // [START get_iid_token]
       // let token = FIRInstanceID.instanceID().token()!
       // print("The token is:", token)
        
        FIRMessaging.messaging().subscribe(toTopic: "/topics/news")
        
       // NSString *token = [[FIRInstanceID instanceID] token];
        
        //MENUBAR
        //setupMenuBar()
        
    }
    
    
    let menuBar : MenuBar = {
        let mb = MenuBar()
        
        return mb
         }()
    
    //Private because no other class need to access this
    private func setupMenuBar(){
        view.addSubview(menuBar)
        view.addContraintsWithFormat(format: "H:|[v0]|", views: menuBar) //horizontal constraints
        view.addContraintsWithFormat(format: "V:|[v0(50)]|", views: menuBar) //Vertical constraints
        
        
        
    }
    
    
    
    //swipe to delete 2
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    //swipe to delete 3
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        //print(indexPath.row)
        //handle delete
        
        guard let uid = FIRAuth.auth()?.currentUser?.uid else {
            return
            
        }
        let message = self.messages[indexPath.row] // Get the message
        
        if let chatPartnerId = message.chatPartnerId() {
           FIRDatabase.database().reference().child("user-messages").child(uid).child(chatPartnerId).removeValue(completionBlock: { (error, reference) in
            if error != nil {
                print("Failed to delete message", error ?? "")
                return
            }
            //SUCCESS
            //We need to update the entire table
            //First the WRONG WAY!! NOT SAFE
            //self.messages.remove(at: indexPath.row)
            //self.tableView.deleteRows(at: [indexPath], with: .automatic)
            
            //THE CORRECT WAY!!
            self.messagesDictionary.removeValue(forKey: chatPartnerId)
            self.attempTedReloadOfTable()
            
           })
            
        }
       
        
        //get the message
        
        
        
    }
    
    //AN ARRAY TO HOLD ALL THE MESSAGES
    var messages = [Message]()
    //GROUPING THE MESSAGES
    var messagesDictionary = [String: Message]()
    
    //FAN-OUT
    func  observeUserMessages(){
        //get the user id
        guard let uid = FIRAuth.auth()?.currentUser?.uid else {
            return
        }
        // get ref  to user- messages
        //HERE WE OBSERVE WHEN CHILD IS ADDED
        let ref = FIRDatabase.database().reference().child("user-messages").child(uid)
        ref.observe(.childAdded, with: { (snapshot) in
            //print(snapshot)
            let userId = snapshot.key
            FIRDatabase.database().reference().child("user-messages").child(uid).child(userId).observe(.childAdded, with: { (snapshot) in
               // print(snapshot)
                let messageId = snapshot.key
                
                self.fetchMessageWithMessageId(messageId: messageId)
                                 //
            }, withCancel: nil)
            
            
        }, withCancel: nil)
        //OBSERVE WHEN CHILD IS REMOVED
            ref.observe(.childRemoved, with: { (snapshot) in
               // print(snapshot.key)
               // print(self.messagesDictionary)
                self.messagesDictionary.removeValue(forKey: snapshot.key)
                self.attempTedReloadOfTable()
            }, withCancel: nil)
        
    }
    
    private func fetchMessageWithMessageId(messageId: String){
        
        let messageReference = FIRDatabase.database().reference().child("messages").child(messageId)
        
        messageReference.observeSingleEvent(of: .value, with: { (snapshot) in
            //print(snapshot)
            //now fill the table with the snapshot
            
            if let dictionary = snapshot.value as? [ String: Any] {
                //we will create a message object nwith the snapshot values
                let message = Message(dictionary: dictionary as [String : AnyObject])
                //Fill the message
                //message.setValuesForKeys(dictionary)
                //test messages
               // print(message.text ?? "No message")
                self.messages.append(message)
                //This will crash because of backgroung thread so lets call this on Dispatch_asyn
                //GROUPING THE MESSAGES.This block below of code pick up all the different messages. 1 per user
                if let toId = message.chatPartnerId() {
                    self.messagesDictionary[toId] = message
                }
                
                self.attempTedReloadOfTable()
                
            }
            
            
        }, withCancel: nil)

        
    }
    
    
   private func attempTedReloadOfTable() {
    
    self.timer?.invalidate()
    //print("We just cancelled the timer")
    self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.handleReloadTable), userInfo: nil, repeats: false) //ADD A DELEAY OF 1 SEC TO THE FUNCTION TO FIRE
    // print("schedule a table reload in 0.1 seconds")

    
    }
    
    
    
    
    //TIMER
    var timer : Timer?
    
    //TableView reload work around
    func handleReloadTable() {
        //USING A HASH OR DICTIONARY TO FILL OUT A TABLEVIEW
        self.messages = Array(self.messagesDictionary.values) //MESSAGES IS NOW FILLED WITH ONE OF EACH
        
        self.messages.sort(by: { (message1, message2) -> Bool in
            return (message1.timeStamp?.intValue)! > (message2.timeStamp?.intValue)!
        }) // sorting the timestamp in decending order
        
        
        
        
        //
        DispatchQueue.main.async(execute: {
            //  print("WE reloaded the table") // this was called 10 times thats wyhy the images were false
            self.tableView.reloadData() //refresh our tableview
        })
        
        
    }
    
    /*
     //GET MESSAGES
     func observeMessages(){
     //observe the messages inside the message node on firebase
     let reference = FIRDatabase.database().reference().child("messages")
     reference.observe(.childAdded, with: { (snapshot) in
     
     // print(snapshot)
     
     if let dictionary = snapshot.value as? [ String: Any] {
     //we will create a message object nwith the snapshot values
     let message = Message()
     //Fill the message
     message.setValuesForKeys(dictionary)
     //test messages
     //print(message.text ?? "No message")
     //              //  self.messages.append(message)
     //This will crash because of backgroung thread so lets call this on Dispatch_asyn
     //GROUPING THE MESSAGES.This block below of code pick up all the different messages. 1 per user
     if let chatPartnerId = message.chatPartnerId() {
     self.messagesDictionary[chatPartnerId] = message
     //USING A HASH OR DICTIONARY TO FILL OUT A TABLEVIEW
     self.messages = Array(self.messagesDictionary.values) //MESSAGES IS NOW FILLED WITH ONE OF EACH
     
     self.messages.sort(by: { (message1, message2) -> Bool in
     return (message1.timeStamp?.intValue)! > (message2.timeStamp?.intValue)!
     }) // sorting the timestamp in decending order
     
     }
     DispatchQueue.main.async(execute: {
     self.tableView.reloadData() //refresh our tableview
     })
     }
     
     }, withCancel: nil)
     
     /*
     reference.observe(.childAdded, with: { (snapshot) in
     //
     print(snapshot)
     
     }, withCancel: nil)
     */
     }
     
     */
    //cell height
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let message = messages[indexPath.row]
        // print(message.text, message.toId, message.fromId)
        // to get the correct id use the usercell logic
        //lets figure out the chatPartnerId
        guard let chatPartnerId = message.chatPartnerId() else {
            return
        }
        
        let ref = FIRDatabase.database().reference().child("users").child(chatPartnerId)
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            // print(snapshot)
            guard let dictionary = snapshot.value as? [String : AnyObject] else {
                return // return if its not a valid dictionary
            }
            let user = User() //create user
            //let user = User(dictionary: <#[String : AnyObject]#>) //create user
            
            user.id = chatPartnerId
            user.setValuesForKeys(dictionary) // set user from snapshot
            self.showChatControllerForUser(user: user) // use user
            
        }, withCancel: nil)
        
        
    }
    //
    
    //MARK: - set up the number of cells
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Create a dummy cell
        //  let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "messageCellId") remove hack
        
        //we need to deque our cell from the tableview instead
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! UserCell
        ////
        let message = messages[indexPath.row]//get the message for the proper row
        
        cell.message = message //THIS IS WHERE THE MESSAGE VAR IN USERCELL IS SET
        
        
        
        cell.textLabel?.text = message.toId //Put the name instead og the toId
        
        /*
         if let toId = message.toId {
         let ref = FIRDatabase.database().reference().child("users").child(toId) //get the ref to the toId
         ref.observe(.value, with: { (snapshot) in
         // print(snapShot)
         // Put the snapshot value in a dictionary
         if  let dictionary = snapshot.value as? [String : AnyObject] {
         cell.textLabel?.text = dictionary["name"] as? String
         //
         //lets get the profile image view.Get the profile image url from snapshot
         if let profileImageUrl = dictionary["profileImageUrl"] as? String {
         cell.proileImageView.loadImageUsingCacheWithUrlString(urlString: profileImageUrl)
         }
         
         
         //
         }
         
         }, withCancel: nil)
         }
         cell.detailTextLabel?.text = message.text
         
         */
        ////
        return cell
    }
    
    
    //MARK: - checkIfUserIsLoggedIn
    func checkIfUserIsLoggedIn(){
        
        if FIRAuth.auth()?.currentUser?.uid == nil {
            // handleLogout() // getting too many controllers error
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
        } else {
            
            fetchUserAndSetUpNavBarTitle()
        }
        
        
    }
    
    func fetchUserAndSetUpNavBarTitle(){
        // Fetch a single value
        //1: get a reference to the firebase databse main - child(users) - > child (uid)
        guard let uid = FIRAuth.auth()?.currentUser?.uid else {
            // if for some reason uid is nil
            return
        }
        FIRDatabase.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
           // print(snapshot) // console will print out the name and email
            
            
            //get the dictionary out of the snapshot
            if let dictionary = snapshot.value as? [String: AnyObject] {
                //  self.navigationItem.title = dictionary["name"] as? String
                let user = User()
                user.setValuesForKeys(dictionary)
                self.setUpNavBarWithUser(user: user) // contains the name email and image of the user
                
            }
            
        }, withCancel: nil)
        
        
    }
    // setting up navbar with image and text centered
    func setUpNavBarWithUser(user:User) {
        //remove all the messages in here
        messages.removeAll()
        messagesDictionary.removeAll()
        tableView.reloadData()
        
        //u
        //listen call listen to logged in user. logged in messages
        observeUserMessages()
        
        //  self.navigationItem.title = user.name
        // set up a container with 2 views
        let titleView = UIView() //This is our container
        //Set a fram for our titleView
        titleView.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
        // check the title view
        //titleView.backgroundColor = UIColor.red
        
        //to make the label stretch out.
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
       // containerView.backgroundColor = UIColor.yellow
        containerView.backgroundColor = UIColor(r: 61, g: 91, b: 151)
        // add profilImageView and label into this view
        titleView.addSubview(containerView)
        
        
        
        
        
        
        
        //lets put an imageview and a label in this container
        let profileImageView = UIImageView()
        profileImageView.layer.borderWidth = 1
        profileImageView.layer.borderColor = UIColor.white.cgColor
        
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        //set aspect ratio
        profileImageView.contentMode = .scaleAspectFill
        //round the image
        profileImageView.layer.cornerRadius = 20
        //set clips to bounds to true
        profileImageView.clipsToBounds = true
        //get the profile image url
        if let profileImageUrl = user.profileImageUrl {
            //load up the imageview from our cached image
            profileImageView.loadImageUsingCacheWithUrlString(urlString: profileImageUrl) //setting the image from what u get from the network
            
        }
        //add the profile Image view to the titl view as a subview
        containerView.addSubview(profileImageView)
        
        //ios 10 constraints
        //x, y, width, height
        // x left anchor to left anchor
        profileImageView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        // y set to the middle
        profileImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        // width will be 40
        profileImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        // height will be 40
        profileImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        //////
        //lets put the labe 8 pixels to the right of the imageview
        let nameLabel = UILabel()
        //MUST ADD IN THE VIEW AFTER YOU CREATE IT!!!! OR YOU WILL GET A VIEW HIARCHY CRASH
        containerView.addSubview(nameLabel)
        nameLabel.textColor = .white
        nameLabel.text = user.name
        //nameLabel.text = "oin  i iiririiiimfg"
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        // label constraints
        //x, y, width, height
        // 8 pixels from the right of the imageview
        nameLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 8) .isActive = true
        //y center of the container
        nameLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor) .isActive = true
        // width right anchor to titlview's right anchor
        nameLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor) .isActive = true
        //make the height the same as the profile imageview
        nameLabel.heightAnchor.constraint(equalTo: profileImageView.heightAnchor) .isActive = true
        
        
        //titleView.addSubview(nameLabel)
        // set the navItemTitleView to that view
        
        
        //Finally center the container
        containerView.centerXAnchor.constraint(equalTo: titleView.centerXAnchor) .isActive = true
        containerView.centerYAnchor.constraint(equalTo: titleView.centerYAnchor) .isActive = true
        
        
        
        self.navigationItem.titleView = titleView
        
        //ADDING AN ACTION TO THE TITLEVIEW
        //        titleView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showChatController)))
        //we do not need to tap on tileview anymore
        
        
        
    }
    
    //MARK: - Loading the showChatController by clicking the nav
    
    func showChatControllerForUser(user:User){
        //print(123)
        // get ref to controller
        //    let chatLogController = ChatLogController() //this will give a non nil crash
        let chatLogController = ChatLogController(collectionViewLayout: UICollectionViewFlowLayout())
        
        //get the user
        chatLogController.user = user
        
        // use nav controller to push chatlogcontroller on the view
        navigationController?.pushViewController(chatLogController, animated: true) // we dont need segues from storyboards :)
        
        
        
    }
    
    
    
    
    //MARK: - LAUNCH NEW MESSAGE CONTROLLER
    //SETTING THE MESSAGECONTROLLER
    
    func handleNewMessage(){
        // here we weant to launch the new message controller
        let newMessageController = NewMessageController() // get it
        
        newMessageController.messagesController = self // setting the message controller
        
        let navControler = UINavigationController(rootViewController:newMessageController)  // this is how yiou add the navbar to the new controller.
        present(navControler, animated: true, completion: nil) // completion nil because we dont need to know when it completes.
        
        
    }
    func handleLogout(){
        // log out of the database
        //when something throws errorswe have to catch it. do,try,catch // FIRAuth.auth()?.signOut()
        
        do {
            try FIRAuth.auth()?.signOut()
        } catch let logoutError {
            print(logoutError)
        }
        
        
        // Here I want launch a viewcontroller when logout is pressed
        
        let loginController = LoginController()
        loginController.messagesController = self //
        present(loginController, animated: true, completion: nil)
        
    }
    
    
    
    
}

//Extension

