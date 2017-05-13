////
////  CleanUp.swift
////  gameOfchats
////
////  Created by Kev1 on 5/12/17.
////  Copyright © 2017 Kev1. All rights reserved.
////
//
//import Foundation
//
////
////  ViewController.swift
////  gameOfchats
////
////  Created by Kev1 on 4/2/17.
////  Copyright © 2017 Kev1. All rights reserved.
////
//
//import UIKit
//import Firebase
//
//
//class MessagesController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
//    
//    
//    
//    let chatCellId = "chatCellId"
//    let testCellId = "testCellId"
//    let CallingCellId = "callingCellId"
//    let CheckoutCellId = "CheckoutCellId"
//    let FixitCellId = "FixitCellId"
//    
//    var chatCell : ChatCell?
//    //AN ARRAY TO HOLD ALL THE MESSAGES
//    var messages = [Message]()
//    //GROUPING THE MESSAGES
//    var messagesDictionary = [String: Message]()
//    
//    
//    lazy var  menuBar : MenuBar = {
//        let mb = MenuBar()
//        mb.translatesAutoresizingMaskIntoConstraints = false
//        //reference
//        mb.messageController = self
//        
//        return mb
//    }()
//    
//    //lazy code only called once when settingsLauncher is nil
//    lazy var settingsLauncher: SettingsLauncher = {
//        let launcher = SettingsLauncher()
//        launcher.homeController = self
//        return launcher
//    }()
//    
//    func handleMore(){
//        settingsLauncher.showSettings()
//        
//    }
//    
//    //MARK:- VIEW LIFECYCLE
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        //darken the navbar
//        navigationController?.navigationBar.isTranslucent = false
//        // How to save Data into fireBase
//        // 1: allocate Reference
//        //    let reference = FIRDatabase.database().reference(fromURL: "https://peephole-6f487.firebaseio.com/")
//        //    reference.updateChildValues(["someValue":123123])
//        
//        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
//        navigationItem.leftBarButtonItem?.tintColor = UIColor.rgb(red: 200, green: 201, blue: 210)
//        navigationItem.rightBarButtonItem?.tintColor = UIColor.rgb(red: 200, green: 201, blue: 210)
//        setupCollectionView()
//        //MENUBAR
//        setupMenuBar()
//        //
//        setupNavBarButtonsOnRight()
//        
//    }
//    
//    func viewWillAppear() {
//        super.viewWillAppear(true)
//        collectionView?.reloadData()
//    }
//    
//    
//    //MARK:- SETUP
//    
//    func setupCollectionView(){
//        
//        if let flowLayout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
//            flowLayout.scrollDirection = .horizontal
//            flowLayout.minimumLineSpacing = 0
//        }
//        collectionView?.backgroundColor = .clear
//        //ChatCell
//        collectionView?.register(ChatCell.self, forCellWithReuseIdentifier: chatCellId)
//        collectionView?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: testCellId)
//        collectionView?.register(CallingCell.self, forCellWithReuseIdentifier: CallingCellId)
//        collectionView?.register(CheckoutCell.self, forCellWithReuseIdentifier: CheckoutCellId)
//        collectionView?.register(FixItCell.self, forCellWithReuseIdentifier: FixitCellId)
//        collectionView?.contentInset = UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0)
//        collectionView?.scrollIndicatorInsets = UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0)
//        //paging snap in place
//        collectionView?.isPagingEnabled = true
//        
//    }
//    
//    
//    func setupNavBarButtonsOnRight(){
//        let searchImage = UIImage(named: "Contacts-50-2")?.withRenderingMode(.alwaysOriginal)//makes the icon white
//        let newMessageBarButtonItem = UIBarButtonItem(image: searchImage, style: .plain, target: self, action: #selector(handleNewMessage))
//        let moreImage = UIImage(named: "Menu 2 Filled-50")?.withRenderingMode(.alwaysOriginal)
//        let moreBarButtonItem = UIBarButtonItem(image: moreImage , style: .plain, target: self, action: #selector(handleMore))
//        newMessageBarButtonItem.tintColor = .white
//        navigationItem.rightBarButtonItems = [ moreBarButtonItem, newMessageBarButtonItem]
//    }
//    
//    //Private because no other class need to access this
//    private func setupMenuBar(){
//        navigationController?.hidesBarsOnSwipe = true
//        let blueView = UIView()
//        blueView.backgroundColor = UIColor(r: 61, g: 91, b: 151)
//        view.addSubview(blueView)
//        view.addConstraintsWithFormat(format: "H:|[v0]|", views: blueView)
//        view.addConstraintsWithFormat(format: "V:[v0(50)]", views: blueView)
//        self.view.addSubview(menuBar)
//        view.addSubview(menuBar)
//        view.addConstraintsWithFormat(format: "H:|[v0]|", views: menuBar)
//        view.addConstraintsWithFormat(format: "V:[v0(50)]", views: menuBar)
//        menuBar.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor).isActive = true
//    }
//    
//    
//    
//    func handleSearch(){
//        scrollToMenuIndex(menuItem: 2)
//    }
//    
//    
//    //MARK:- SCROLL RELATED
//    
//    //AUTOMATIC SCROLL TO MENUITEM POSITION. THIS FUNC IS USED INSIDE OF MENUBAR-EVERYTIME WE TAP ON THE ICON
//    func scrollToMenuIndex(menuItem:Int){
//        let indexPath = NSIndexPath(item: menuItem, section: 0)
//        collectionView?.scrollToItem(at: indexPath as IndexPath, at: [], animated: true)
//        
//    }
//    //THIS IS HOW WE FIND OUT WHERE WE SCROLLED TO
//    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        //print(scrollView.contentOffset.x) //
//        //moving the menubar with the pages
//        menuBar.horizontalBarLeftConstraint?.constant = scrollView.contentOffset.x / 4
//    }
//    //HILIGHTING THE BUTTONS WITH SCROLL
//    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
//        //targetContentOffset.pointee.x = view.frame.width
//        //print(targetContentOffset.pointee.x / view.frame.width) //1.0, 2.0, 3.0, 4.0 //positions
//        //now that we have the index
//        let index = targetContentOffset.pointee.x / view.frame.width
//        let indexPath = NSIndexPath(item:Int(index) , section: 0)
//        menuBar.collectionView.selectItem(at: indexPath as IndexPath, animated: true, scrollPosition: [])
//    }
//    
//    
//    //MARK:- IMPLEMENTATION SECTION
//    func showControllerForSetting(setting: Setting){
//        let dummySettingsViewController = UIViewController()
//        dummySettingsViewController.navigationItem.title = setting.name.rawValue
//        dummySettingsViewController.view.backgroundColor = .white
//        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white] //CHANGING
//        navigationController?.navigationBar.tintColor = .white //setting the back button color
//        navigationController?.pushViewController(dummySettingsViewController, animated: true)
//        
//    }
//    
//    //MARK:- COLLECTIONVIEW DATASOURCE
//    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return 4
//    }
//    
//    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        
//        if indexPath.item == 0 {
//            //identifier = chatCellId
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: chatCellId, for: indexPath) as! ChatCell
//            cell.messagesController = self
//            return cell
//            
//        } else if indexPath.item == 1 {
//            
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CallingCellId, for: indexPath) as! CallingCell
//            return cell
//            
//        } else if indexPath.item == 2 {
//            
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FixitCellId, for: indexPath) as! FixItCell
//            return cell
//            
//        }else if indexPath.item == 3 {
//            
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CheckoutCellId, for: indexPath) as! CheckoutCell
//            return cell
//            
//        }
//            
//            
//        else {
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: testCellId, for: indexPath) as UICollectionViewCell
//            return cell
//        }
//        
//    }
//    // Size of Cell
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: view.frame.width, height: view.frame.height)
//    }
//    
//    
//    //MARK:- COLLECTIONVIEW DELEGATE METHODS
//    private func attempTedReloadOfTable() {
//        
//        self.timer?.invalidate()
//        //print("We just cancelled the timer")
//        self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.handleReloadTable), userInfo: nil, repeats: false) //ADD A DELEAY OF 1 SEC TO THE FUNCTION TO FIRE
//        // print("schedule a table reload in 0.1 seconds")
//        
//        
//    }
//    
//    
//    
//    
//    //TIMER
//    var timer : Timer?
//    
//    //TableView reload work around
//    func handleReloadTable() {
//        //USING A HASH OR DICTIONARY TO FILL OUT A TABLEVIEW
//        self.messages = Array(self.messagesDictionary.values) //MESSAGES IS NOW FILLED WITH ONE OF EACH
//        
//        self.messages.sort(by: { (message1, message2) -> Bool in
//            return (message1.timeStamp?.intValue)! > (message2.timeStamp?.intValue)!
//        }) // sorting the timestamp in decending order
//        //
//        DispatchQueue.main.async(execute: {
//            //  print("WE reloaded the table") // this was called 10 times thats wyhy the images were false
//            // self.tableView.reloadData() //refresh our tableview
//            self.collectionView?.reloadData()
//        })
//        
//        
//    }
//    
//    
//    
//    func swipeLeft(){
//        
//        
//    }
//    
//    /*
//     
//     //swipe to delete 2
//     func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
//     return true
//     }
//     
//     //swipe to delete 3
//     func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//     //print(indexPath.row)
//     //handle delete
//     
//     guard let uid = FIRAuth.auth()?.currentUser?.uid else {
//     return
//     
//     }
//     let message = self.messages[indexPath.row] // Get the message
//     
//     if let chatPartnerId = message.chatPartnerId() {
//     FIRDatabase.database().reference().child("user-messages").child(uid).child(chatPartnerId).removeValue(completionBlock: { (error, reference) in
//     if error != nil {
//     print("Failed to delete message", error ?? "")
//     return
//     }
//     //SUCCESS
//     //We need to update the entire table
//     //First the WRONG WAY!! NOT SAFE
//     //self.messages.remove(at: indexPath.row)
//     //self.tableView.deleteRows(at: [indexPath], with: .automatic)
//     
//     //THE CORRECT WAY!!
//     self.messagesDictionary.removeValue(forKey: chatPartnerId)
//     self.attempTedReloadOfTable()
//     
//     })
//     
//     }
//     
//     
//     //get the message
//     
//     
//     
//     }
//     */
//    
//    /*
//     //FAN-OUT
//     func  observeUserMessages(){
//     //get the user id
//     guard let uid = FIRAuth.auth()?.currentUser?.uid else {
//     return
//     }
//     // get ref  to user- messages
//     //HERE WE OBSERVE WHEN CHILD IS ADDED
//     let ref = FIRDatabase.database().reference().child("user-messages").child(uid)
//     ref.observe(.childAdded, with: { (snapshot) in
//     //print(snapshot)
//     let userId = snapshot.key
//     FIRDatabase.database().reference().child("user-messages").child(uid).child(userId).observe(.childAdded, with: { (snapshot) in
//     // print(snapshot)
//     let messageId = snapshot.key
//     
//     self.fetchMessageWithMessageId(messageId: messageId)
//     //
//     }, withCancel: nil)
//     
//     
//     }, withCancel: nil)
//     //OBSERVE WHEN CHILD IS REMOVED
//     ref.observe(.childRemoved, with: { (snapshot) in
//     // print(snapshot.key)
//     // print(self.messagesDictionary)
//     self.messagesDictionary.removeValue(forKey: snapshot.key)
//     self.attempTedReloadOfTable()
//     }, withCancel: nil)
//     
//     }
//     */
//    /*
//     private func fetchMessageWithMessageId(messageId: String){
//     
//     let messageReference = FIRDatabase.database().reference().child("messages").child(messageId)
//     
//     messageReference.observeSingleEvent(of: .value, with: { (snapshot) in
//     //print(snapshot)
//     //now fill the table with the snapshot
//     
//     if let dictionary = snapshot.value as? [ String: Any] {
//     //we will create a message object nwith the snapshot values
//     let message = Message(dictionary: dictionary as [String : AnyObject])
//     //Fill the message
//     //message.setValuesForKeys(dictionary)
//     //test messages
//     // print(message.text ?? "No message")
//     self.messages.append(message)
//     //print(self.messages.count)
//     
//     
//     //This will crash because of backgroung thread so lets call this on Dispatch_asyn
//     //GROUPING THE MESSAGES.This block below of code pick up all the different messages. 1 per user
//     if let toId = message.chatPartnerId() {
//     self.messagesDictionary[toId] = message
//     }
//     
//     self.attempTedReloadOfTable()
//     
//     }
//     
//     
//     }, withCancel: nil)
//     
//     
//     }
//     */
//    
//    
//    
//    
//    
//    
//    
//    /*
//     //GET MESSAGES
//     func observeMessages(){
//     //observe the messages inside the message node on firebase
//     let reference = FIRDatabase.database().reference().child("messages")
//     reference.observe(.childAdded, with: { (snapshot) in
//     
//     // print(snapshot)
//     
//     if let dictionary = snapshot.value as? [ String: Any] {
//     //we will create a message object nwith the snapshot values
//     let message = Message()
//     //Fill the message
//     message.setValuesForKeys(dictionary)
//     //test messages
//     //print(message.text ?? "No message")
//     //              //  self.messages.append(message)
//     //This will crash because of backgroung thread so lets call this on Dispatch_asyn
//     //GROUPING THE MESSAGES.This block below of code pick up all the different messages. 1 per user
//     if let chatPartnerId = message.chatPartnerId() {
//     self.messagesDictionary[chatPartnerId] = message
//     //USING A HASH OR DICTIONARY TO FILL OUT A TABLEVIEW
//     self.messages = Array(self.messagesDictionary.values) //MESSAGES IS NOW FILLED WITH ONE OF EACH
//     
//     self.messages.sort(by: { (message1, message2) -> Bool in
//     return (message1.timeStamp?.intValue)! > (message2.timeStamp?.intValue)!
//     }) // sorting the timestamp in decending order
//     
//     }
//     DispatchQueue.main.async(execute: {
//     self.tableView.reloadData() //refresh our tableview
//     })
//     }
//     
//     }, withCancel: nil)
//     
//     /*
//     reference.observe(.childAdded, with: { (snapshot) in
//     //
//     print(snapshot)
//     
//     }, withCancel: nil)
//     */
//     }
//     
//     */
//    //cell height
//    
//    
//    
//    //TV
//    
//    /*
//     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//     return 72
//     }
//     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//     let message = messages[indexPath.row]
//     // print(message.text, message.toId, message.fromId)
//     // to get the correct id use the usercell logic
//     //lets figure out the chatPartnerId
//     guard let chatPartnerId = message.chatPartnerId() else {
//     return
//     }
//     
//     let ref = FIRDatabase.database().reference().child("users").child(chatPartnerId)
//     
//     ref.observeSingleEvent(of: .value, with: { (snapshot) in
//     // print(snapshot)
//     guard let dictionary = snapshot.value as? [String : AnyObject] else {
//     return // return if its not a valid dictionary
//     }
//     let user = User() //create user
//     //let user = User(dictionary: <#[String : AnyObject]#>) //create user
//     
//     user.id = chatPartnerId
//     user.setValuesForKeys(dictionary) // set user from snapshot
//     self.showChatControllerForUser(user: user) // use user
//     
//     }, withCancel: nil)
//     
//     
//     }
//     */
//    //
//    /*
//     
//     //MARK: - set up the number of cells
//     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//     return messages.count    }
//     
//     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//     // Create a dummy cell
//     // let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "messageCellId")
//     //remove hack
//     
//     //we need to deque our cell from the tableview instead
//     //let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! UserCell
//     //let cell = dequeueReusableCellWithIdentifier:forIndexPath:.
//     //let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! UserCell
//     let cell: UserCell = self.tableView.dequeueReusableCell(withIdentifier: "cellId") as! UserCell
//     //let cell = tableView.dequeueReusableCellWithIdentifier("customcell", forIndexPath: indexPath) as! UITableViewCell
//     
//     
//     ////
//     let message = messages[indexPath.row]//get the message for the proper row
//     
//     cell.message = message //THIS IS WHERE THE MESSAGE VAR IN USERCELL IS SET
//     
//     if message.imageUrl != nil {
//     cell.textLabel?.text = "Smiley \u{1F603}"
//     } else if message.videoUrl != nil {
//     cell.textLabel?.text = "Smiley \u{1F603}"
//     } else {
//     cell.textLabel?.text = message.toId //Put the name instead og the toId
//     
//     }
//     
//     
//     
//     //cell.textLabel?.text = message.toId //Put the name instead og the toId
//     
//     /*
//     if let toId = message.toId {
//     let ref = FIRDatabase.database().reference().child("users").child(toId) //get the ref to the toId
//     ref.observe(.value, with: { (snapshot) in
//     // print(snapShot)
//     // Put the snapshot value in a dictionary
//     if  let dictionary = snapshot.value as? [String : AnyObject] {
//     cell.textLabel?.text = dictionary["name"] as? String
//     //
//     //lets get the profile image view.Get the profile image url from snapshot
//     if let profileImageUrl = dictionary["profileImageUrl"] as? String {
//     cell.proileImageView.loadImageUsingCacheWithUrlString(urlString: profileImageUrl)
//     }
//     
//     
//     //
//     }
//     
//     }, withCancel: nil)
//     }
//     cell.detailTextLabel?.text = message.text
//     
//     */
//     ////
//     return cell
//     }
//     
//     */
//    //MARK: - checkIfUserIsLoggedIn
//    
//    
//    //    func checkIfUserIsLoggedIn(){
//    //
//    //        if FIRAuth.auth()?.currentUser?.uid == nil {
//    //            // handleLogout() // getting too many controllers error
//    //            perform(#selector(handleLogout), with: nil, afterDelay: 0)
//    //        } else {
//    //
//    //  //          fetchUserAndSetUpNavBarTitle()
//    //        }
//    //
//    //    }
//    //
//    
//    //MARK:- this method is called from login controller
//    func fetchUserAndSetUpNavBarTitle(){
//        // Fetch a single value
//        //1: get a reference to the firebase databse main - child(users) - > child (uid)
//        guard let uid = FIRAuth.auth()?.currentUser?.uid else {
//            // if for some reason uid is nil
//            return
//        }
//        FIRDatabase.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
//            // print(snapshot) // console will print out the name and email
//            //get the dictionary out of the snapshot
//            if let dictionary = snapshot.value as? [String: AnyObject] {
//                //  self.navigationItem.title = dictionary["name"] as? String
//                let user = User()
//                user.setValuesForKeys(dictionary) //user is set here from login/signup
//                self.setUpNavBarWithUser(user: user) // contains the name email and image of the user
//                
//            }
//            
//        }, withCancel: nil)
//    }
//    
//    
//    
//    // setting up navbar with image and text centered
//    func setUpNavBarWithUser(user:User) {
//        
//        let titleView = UIView() //This is our container
//        //Set a fram for our titleView
//        titleView.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
//        
//        let containerView = UIView()
//        containerView.translatesAutoresizingMaskIntoConstraints = false
//        // containerView.backgroundColor = UIColor.yellow
//        containerView.backgroundColor = UIColor(r: 61, g: 91, b: 151)
//        // add profilImageView and label into this view
//        titleView.addSubview(containerView)
//        
//        //lets put an imageview and a label in this container
//        let profileImageView = UIImageView()
//        profileImageView.layer.borderWidth = 1
//        //profileImageView.layer.borderColor = UIColor.white.cgColor
//        profileImageView.layer.borderColor = UIColor(r: 61, g: 91, b: 151).cgColor
//        
//        profileImageView.translatesAutoresizingMaskIntoConstraints = false
//        //set aspect ratio
//        profileImageView.contentMode = .scaleAspectFill
//        //round the image
//        profileImageView.layer.cornerRadius = 20
//        //set clips to bounds to true
//        profileImageView.clipsToBounds = true
//        //get the profile image url
//        if let profileImageUrl = user.profileImageUrl {
//            //load up the imageview from our cached image
//            profileImageView.loadImageUsingCacheWithUrlString(urlString: profileImageUrl) //setting the image from what u get from the network
//            
//        }
//        //add the profile Image view to the titl view as a subview
//        containerView.addSubview(profileImageView)
//        
//        //ios 10 constraints
//        //x, y, width, height
//        // x left anchor to left anchor
//        profileImageView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
//        // y set to the middle
//        profileImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
//        // width will be 40
//        profileImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
//        // height will be 40
//        profileImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
//        
//        //////
//        //lets put the labe 8 pixels to the right of the imageview
//        let nameLabel = UILabel()
//        //MUST ADD IN THE VIEW AFTER YOU CREATE IT!!!! OR YOU WILL GET A VIEW HIARCHY CRASH
//        containerView.addSubview(nameLabel)
//        nameLabel.textColor = UIColor.rgb(red: 200, green: 201, blue: 210)
//        nameLabel.font = UIFont.boldSystemFont(ofSize: 16)
//        nameLabel.text = (user.name)?.uppercased()
//        //nameLabel.text = "oin  i iiririiiimfg"
//        
//        nameLabel.translatesAutoresizingMaskIntoConstraints = false
//        // label constraints
//        //x, y, width, height
//        // 8 pixels from the right of the imageview
//        nameLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 8) .isActive = true
//        //y center of the container
//        nameLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor) .isActive = true
//        // width right anchor to titlview's right anchor
//        nameLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor) .isActive = true
//        //make the height the same as the profile imageview
//        nameLabel.heightAnchor.constraint(equalTo: profileImageView.heightAnchor) .isActive = true
//        
//        //Finally center the container
//        containerView.centerXAnchor.constraint(equalTo: titleView.centerXAnchor) .isActive = true
//        containerView.centerYAnchor.constraint(equalTo: titleView.centerYAnchor) .isActive = true
//        
//        self.navigationItem.titleView = titleView
//        
//    }
//    
//    
//    //MARK:- CHAT CONTROLLER
//    
//    func showChatControllerForUser(user:User){
//        //print(123)
//        // get ref to controller
//        //    let chatLogController = ChatLogController() //this will give a non nil crash
//        let chatLogController = ChatLogController(collectionViewLayout: UICollectionViewFlowLayout())
//        
//        //get the user
//        chatLogController.user = user
//        
//        // use nav controller to push chatlogcontroller on the view
//        navigationController?.pushViewController(chatLogController, animated: true) // we dont need segues from storyboards :)
//        
//        
//        
//    }
//    
//    
//    
//    
//    
//    //MARK: - LAUNCH NEW MESSAGE CONTROLLER
//    //SETTING THE MESSAGECONTROLLER
//    
//    func handleNewMessage(){
//        // here we weant to launch the new message controller
//        let newMessageController = NewMessageController() // get it
//        
//        newMessageController.messagesController = self // setting the message controller
//        
//        let navControler = UINavigationController(rootViewController:newMessageController)  // this is how yiou add the navbar to the new controller.
//        
//        //navControler.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white] //CHANGING THE TITLE COLOR
//        
//        present(navControler, animated: true, completion: nil) // completion nil because we dont need to know when it completes.
//        
//        
//    }
//    func handleLogout(){
//        // log out of the database
//        //when something throws errorswe have to catch it. do,try,catch // FIRAuth.auth()?.signOut()
//        
//        do {
//            try FIRAuth.auth()?.signOut()
//        } catch let logoutError {
//            print(logoutError)
//        }
//        
//        
//        // Here I want launch a viewcontroller when logout is pressed
//        
//        let loginController = LoginController()
//        loginController.messagesController = self //
//        present(loginController, animated: true, completion: nil)
//        
//    }
//    
//    
//    
//    
//}
//
////Extension
//
//
