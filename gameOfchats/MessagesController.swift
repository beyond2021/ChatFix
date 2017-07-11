//
//  ViewController.swift
//  gameOfchats
//
//  Created by Kev1 on 4/2/17.
//  Copyright © 2017 Kev1. All rights reserved.
//

import UIKit
import Firebase
let aquaBlueChatfixColor = UIColor.rgb(red: 0, green: 142, blue: 253)

/*
extension Collection where Generator.Element: Hashable {
    // Returns the index paths of the elements which still exist after the subtraction
    func differenceWith(collectionToSubtract:[Self.Generator.Element]) -> [NSIndexPath] {
        return Set<<#Element: Hashable#>>(self).subtract(Set(collectionToSubtract))
            .flatMap { self.indexOf($0) as? Int }
            .map { NSIndexPath(forItem: $0, inSection: 0) }
    }
}
 */



class MessagesController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    
    
    let chatCellId = "chatCellId"
    let testCellId = "testCellId"
    let CallingCellId = "callingCellId"
    let CheckoutCellId = "CheckoutCellId"
    let FixitCellId = "FixitCellId"
    
    
    //AN ARRAY TO HOLD ALL THE MESSAGES
    var messages = [Message]()
    //GROUPING THE MESSAGES
    var messagesDictionary = [String: Message]()
    
    var chatCell : ChatCell? // links
    lazy var  menuBar : MenuBar = {
        let mb = MenuBar()
        mb.translatesAutoresizingMaskIntoConstraints = false
        //reference
        mb.messageController = self
       mb.dropShadow() // my extension
        
        return mb
    }()
    
    //lazy code only called once when settingsLauncher is nil
    lazy var settingsLauncher: SettingsLauncher = {
        let launcher = SettingsLauncher()
        launcher.homeController = self
        return launcher
    }()
    
    func handleMore(){
        settingsLauncher.showSettings()
        
    }
    
    //MARK:- VIEW LIFECYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        listenForNotifications()
        
      fadeInMenubar()
        //darken the navbar
       navigationController?.navigationBar.isTranslucent = true
        navigationController?.hidesBarsOnSwipe = false
        navigationController?.navigationBar.backgroundColor = .clear      // navigationController?.navigationBar.barTintColor = .clear
        
        // navigationController?.extendedLayoutIncludesOpaqueBars = true//
        
        // How to save Data into fireBase
        // 1: allocate Reference
        //    let reference = FIRDatabase.database().reference(fromURL: "https://peephole-6f487.firebaseio.com/")
        //    reference.updateChildValues(["someValue":123123])
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        //        navigationItem.leftBarButtonItem?.tintColor = UIColor.rgb(red: 200, green: 201, blue: 210)
        //        navigationItem.rightBarButtonItem?.tintColor = UIColor.rgb(red: 200, green: 201, blue: 210)
        
        navigationItem.leftBarButtonItem?.tintColor = .white
        navigationItem.rightBarButtonItem?.tintColor = .white
        
       setupCollectionView()
        setupNavBarButtonsOnRight()
        //  perform(#selector(handleLogout), with: nil, afterDelay: 0)
        checkIfUserIsLoggedIn()
        
    }
    
    
    func listenForNotifications(){
        NotificationCenter.default.addObserver(self, selector: #selector(workViewUp), name: WORK_VIEW_UP_NOTIFICATION, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(workViewDown), name: WORK_VIEW_DOWN_NOTIFICATION, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showControllerForQuote), name: MENUBAR_PRESS_QUOTE_NOTIFICATION, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(cameraDismissed), name: CAMERA_DISMISS_NOTIFICATION, object: nil)
        
    }
    
    
    
    deinit {
        removeNotifications()
    }
    
    func removeNotifications() {
        NotificationCenter.removeObserver(self, forKeyPath: WORK_VIEW_UP_NOTIFICATION.rawValue)
        NotificationCenter.removeObserver(self, forKeyPath: WORK_VIEW_DOWN_NOTIFICATION.rawValue)
        NotificationCenter.removeObserver(self, forKeyPath: MENUBAR_PRESS_QUOTE_NOTIFICATION.rawValue)
        NotificationCenter.removeObserver(self, forKeyPath: CAMERA_DISMISS_NOTIFICATION.rawValue)
        
    }
    
    
    
    func checkIfUserIsLoggedIn(){
        
        if FIRAuth.auth()?.currentUser?.uid == nil {
            // handleLogout() // getting too many controllers error
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
            //FIRAuth.auth()?.currentUser?.uid  // this is the userid of the person with the phones
            
        } else {
            
            fetchUserAndSetUpNavBarTitle()
        }
        
        
    }
    
    
    
    func viewWillAppear() {
        super.viewWillAppear(true)
      //  fadeInMenubar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
//        let img = UIImage()
//        self.navigationController?.navigationBar.shadowImage = img
//        self.navigationController?.navigationBar.setBackgroundImage(img, for: UIBarMetrics.default)
//        fadeInMenubar()
    }
    
    var workUpFlag : Bool?
    
    func workViewUp() {
        print("Work view up")
        if workUpFlag == false {
            workUpFlag = true
        }
        
    }
    
    func workViewDown(){
        print("Work view down")
        collectionView?.isScrollEnabled = true
        if workUpFlag == true {
            workUpFlag = false
        }
        
    }
    
    
    
    //MARK:- SETUP
    
    func fadeInMenubar(){
        // menuBar.alpha = 0
        /*
        UIView.animate(withDuration: 1.0, delay: 0.5, usingSpringWithDamping: 1, initialSpringVelocity: 2, options: .curveEaseOut, animations: {
            //  self.menuBar.alpha = 1
            self.setupMenuBar()
        }) { (true) in
  // self.setupCollectionView()
        }
        */
        UIView.animate(withDuration: 0.1, delay: 0.5, usingSpringWithDamping: 1, initialSpringVelocity: 2, options: .curveEaseOut, animations: {
            //  self.menuBar.alpha = 1
            self.setupMenuBar()
        }) { (true) in
            // self.setupCollectionView()
        }
        
        
        
    }
    
    
    
    
    
    func setupCollectionView(){
        collectionView?.delegate = self
        
        if let flowLayout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .horizontal
            flowLayout.minimumLineSpacing = 0
            flowLayout.itemSize = (self.collectionView?.frame.size)!;
            
        }
        collectionView?.backgroundColor = .clear
        //ChatCell
        collectionView?.register(ChatCell.self, forCellWithReuseIdentifier: chatCellId)
        collectionView?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: testCellId)
        collectionView?.register(CallingCell.self, forCellWithReuseIdentifier: CallingCellId)
        collectionView?.register(CheckoutCell.self, forCellWithReuseIdentifier: CheckoutCellId)
        collectionView?.register(FixItCell.self, forCellWithReuseIdentifier: FixitCellId)
        collectionView?.contentInset = UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0)
        //collectionView?.scrollIndicatorInsets = UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0)
        //paging snap in place
        collectionView?.isPagingEnabled = true
        
    }
    
    
    func setupNavBarButtonsOnRight(){
        let searchImage = UIImage(named: "Contacts-50-2")?.withRenderingMode(.alwaysOriginal)//makes the icon white
        let newMessageBarButtonItem = UIBarButtonItem(image: searchImage, style: .plain, target: self, action: #selector(handleNewMessage))
        let moreImage = UIImage(named: "Menu 2 Filled-50")?.withRenderingMode(.alwaysOriginal)
        let moreBarButtonItem = UIBarButtonItem(image: moreImage , style: .plain, target: self, action: #selector(handleMore))
        newMessageBarButtonItem.tintColor = .white
        navigationItem.rightBarButtonItems = [ moreBarButtonItem, newMessageBarButtonItem]
    }
    
    let blueView : UIView = {
        let view = UIView()
        //        view.backgroundColor = aquaBlueChatfixColor
        view.backgroundColor = aquaBlueChatfixColor
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    
    //Private because no other class need to access this
    func setupMenuBar(){
//        navigationController?.hidesBarsOnSwipe = true
//        navigationController?.hidesBarsOnTap = true
        navigationController?.navigationBar.backgroundColor = aquaBlueChatfixColor
        // let blueView = UIView()
        // blueView.backgroundColor = UIColor(r: 61, g: 91, b: 151)
        // blueView.backgroundColor = aquaBlueChatfixColor
                view.addSubview(blueView)
                view.addConstraintsWithFormat(format: "H:|[v0]|", views: blueView)
                view.addConstraintsWithFormat(format: "V:[v0(50)]", views: blueView)
//        blueView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
//         blueView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
//        blueView.topAnchor.constraint(equalTo: view.topAnchor, constant: -125).isActive = true
//        blueView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        self.view.addSubview(menuBar)
        view.addSubview(menuBar)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: menuBar)
        view.addConstraintsWithFormat(format: "V:[v0(50)]", views: menuBar)
        menuBar.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor).isActive = true
        
    
        menuBar.alpha = 0
        UIView.animate(withDuration: 0.5, delay: 1.5, usingSpringWithDamping: 1, initialSpringVelocity: 3, options: .curveEaseOut, animations: {
            //  self.menuBar.alpha = 1
            self.menuBar.alpha = 1
        }) { (true) in
            // self.setupCollectionView()
        }

 
        
    }
    
    
    
    
    
    //MARK:- IMPLEMENTATION SECTION
    func showControllerForSetting(setting: Setting){
        let dummySettingsViewController = UIViewController()
        dummySettingsViewController.navigationItem.title = setting.name.rawValue
        dummySettingsViewController.view.backgroundColor = .white
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white] //CHANGING
        navigationController?.navigationBar.tintColor = .white //setting the back button color
        navigationController?.pushViewController(dummySettingsViewController, animated: true)
        
    }
    
    //MARK:- COLLECTIONVIEW DATASOURCE
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.item == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: chatCellId, for: indexPath) as! ChatCell
           // fadeInMenubar()
            
            cell.messagesController = self
            
            cell.observeUserMessages()
            
            return cell
            
        } else if indexPath.item == 1 {
            print("Work")
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CallingCellId, for: indexPath) as! CallingCell
            cell.messagesController = self
            
            return cell
            
        } else if indexPath.item == 2 {
            //   resetNav()
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FixitCellId, for: indexPath) as! FixItCell
            cell.messagesController = self
            return cell
            
        }else if indexPath.item == 3{
            //  resetNav()
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CheckoutCellId, for: indexPath) as! CheckoutCell
            
            return cell
            
        }
            
            
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: testCellId, for: indexPath) as UICollectionViewCell
            return cell
        }
        
    }
    
    
    
    
    // Size of Cell
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height)
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        print("will display indexpath", indexPath.item)
        if indexPath.item == 0 {
            navigationController?.navigationBar.isHidden = false
         //   checkIfUserIsLoggedIn()
           // navigationController?.navigationBar.isHidden = false
           // setupMenuBar()
            print("Path : 0")
            menuBar.isHidden = false
            blueView.isHidden = false
            
        } else
        
        
        if indexPath.item == 1 {
          navigationController?.navigationBar.isHidden = true
         //  navigationController?.navigationBar.isTranslucent = true
            self.navigationController!.navigationBar.backgroundColor = UIColor.clear
            navigationController?.setNavigationBarHidden(true, animated: true)
            menuBar.isHidden = true
            blueView.isHidden = true
        }
        
        else {
            navigationController?.navigationBar.isTranslucent = false
            navigationController?.navigationBar.isHidden = false
            menuBar.isHidden = false
            blueView.isHidden = false
            
        }
    }
    
        
    
    
    func cameraDismissed(){
 //       navigationController?.navigationBar.isTranslucent = false
//        navigationController?.navigationBar.isHidden = false
//        menuBar.isHidden = false
//        blueView.isHidden = false
        checkIfUserIsLoggedIn()
        
    }
    
   
    func deleteRow(){
        collectionView?.performBatchUpdates({ 
            //
        }, completion: { (true) in
            //
        })
        
    }
    
    /*
     
     //swipe to delete 2
     func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     return true
     }
     
     //swipe to delete 3
     func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
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
     */
    
    
    //MARK:- this method is called from login controller
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
                user.setValuesForKeys(dictionary) //user is set here from login/signup
                self.setUpNavBarWithUser(user: user) // contains the name email and image of the user
                //TODO
                //NEED TO SETUP THIS USER IN CHATCELL
                
                DispatchQueue.main.async(execute: {
                    //  print("WE reloaded the table") // this was called 10 times thats wyhy the images were false
                    // self.tableView.reloadData() //refresh our tableview
                    self.collectionView?.reloadData()
                    // self.attempTedReloadOfTable()
                })
                
                
                
            }
            
        }, withCancel: nil)
    }
    
    
    
    // setting up navbar with image and text centered
    func setUpNavBarWithUser(user:User) {
        let indexPath = IndexPath(item: 0, section: 0 )
        collectionView?.reloadItems(at: [indexPath])
        // self.collectionView?.reloadData()
        
        let titleView = UIView() //This is our container
        //Set a fram for our titleView
        titleView.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
        
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
       //  containerView.backgroundColor = UIColor.yellow
       //  containerView.backgroundColor = .clear
 //       containerView.backgroundColor = UIColor(r: 61, g: 91, b: 151)
        // add profilImageView and label into this view
        titleView.addSubview(containerView)
        
        //lets put an imageview and a label in this container
        let profileImageView = UIImageView()
        profileImageView.layer.borderWidth = 1
        //profileImageView.layer.borderColor = UIColor.white.cgColor
        //        profileImageView.layer.borderColor = UIColor(r: 61, g: 91, b: 151).cgColor
        profileImageView.layer.borderColor = aquaBlueChatfixColor.cgColor
        
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
        
        containerView.addSubview(profileImageView)
        profileImageView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        
        profileImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        
        profileImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        // height will be 40
        profileImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        let nameLabel = UILabel()
        
        containerView.addSubview(nameLabel)
        nameLabel.textColor = .white
        
        nameLabel.font = UIFont.boldSystemFont(ofSize: 16)
        
        //print("The user is:", user.name ?? "")
        
        nameLabel.text = (user.name)?.uppercased()
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 8) .isActive = true
        nameLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor) .isActive = true
        
        nameLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor) .isActive = true
        
        nameLabel.heightAnchor.constraint(equalTo: profileImageView.heightAnchor) .isActive = true
        
        
        containerView.centerXAnchor.constraint(equalTo: titleView.centerXAnchor) .isActive = true
        containerView.centerYAnchor.constraint(equalTo: titleView.centerYAnchor) .isActive = true
        
        self.navigationItem.titleView = titleView
        
        
    }
    
    
    //MARK:- CHAT CONTROLLER
    
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
        
        //navControler.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white] //CHANGING THE TITLE COLOR
        
        present(navControler, animated: true, completion: nil) // completion nil because we dont need to know when it completes.
        
        
    }
    
    //MARK:- LOGOUT
    func handleLogout(){
        // log out of the database
        //when something throws errorswe have to catch it. do,try,catch // FIRAuth.auth()?.signOut()
        
        print("Gonna try to open logout from messages")
      //  chatCell?.messages.isEmpty
        
        do {
            try FIRAuth.auth()?.signOut()
        } catch let logoutError {
            print(logoutError)
        }
                
        let loginController = LoginController()
        loginController.messagesController = self //
        present(loginController, animated: true, completion: nil)
        
    }
    
   
    //MARK:- Motion
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        //
       // showShake()
        if workUpFlag == true {
            let indexPath = IndexPath(item: 2, section: 0 )
            NotificationCenter.default.post(name: MENUBAR_PRESS_QUOTE_NOTIFICATION, object: nil)            
            collectionView?.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            
            
            
        }
        
        
        
    }
    
    func showShake() {
        let alert = UIAlertController(title: "I was shaked", message: "I will call now", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: { (action) in
            self.dismiss(animated: true, completion: nil)
        }))
        present(alert, animated: true, completion: nil)
        
    }

    
    func callingBeyond2021(){
        guard let number = URL(string: "telprompt://" + "19173495126") else { return }
        UIApplication.shared.open(number, options: [:], completionHandler: nil)
        
    }
    
    
    func removeNav() {
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.setNavigationBarHidden(true, animated: true)
        menuBar.isHidden = true
        
        
    }
    
    func showControllerForQuote(){
        let dummySettingsViewController = QuoteViewController()
        
        self.present(dummySettingsViewController, animated: true, completion: nil)
        
        
//        dummySettingsViewController.navigationItem.title = "QUOTE"
//        
//        
//        
//        
//       // dummySettingsViewController.view.backgroundColor = .white
//        dummySettingsViewController.view.backgroundColor = .clear
//        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white] //CHANGING
//        navigationController?.navigationBar.tintColor = .white //setting the back button color
        
   //     menuBar.isHidden = true
        
        
        
   //     navigationController?.pushViewController(dummySettingsViewController, animated: true)
        
    }
    
    
    
    
}

extension MessagesController {
    override func motionBegan(_ motion: UIEventSubtype, with event: UIEvent?) {
        //   print("Device was shaken!")
        if(event?.subtype == UIEventSubtype.motionShake) {
            if workUpFlag == true {
                print("You shook me, now what")
            }
            
            
        }
    }
    
    
    //MARK:- ShakeGesture
    func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent?) {
        if(event?.subtype == UIEventSubtype.motionShake) {
            print("You shook me, now what")
        }
    }
    
}

extension MessagesController {
    //MARK:- SCROLL RELATED
    
    //AUTOMATIC SCROLL TO MENUITEM POSITION. THIS FUNC IS USED INSIDE OF MENUBAR-EVERYTIME WE TAP ON THE ICON
    func scrollToMenuIndex(menuItem:Int){
        let indexPath = NSIndexPath(item: menuItem, section: 0)
        collectionView?.scrollToItem(at: indexPath as IndexPath, at: [], animated: true)
        if menuItem == 2 {
            print("Clear out")
        }
        
    }
    //THIS IS HOW WE FIND OUT WHERE WE SCROLLED TO
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //print(scrollView.contentOffset.x) //
        //moving the menubar with the pages
        menuBar.horizontalBarLeftConstraint?.constant = scrollView.contentOffset.x / 4
    }
    //HILIGHTING THE BUTTONS WITH SCROLL
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        //targetContentOffset.pointee.x = view.frame.width
        //print(targetContentOffset.pointee.x / view.frame.width) //1.0, 2.0, 3.0, 4.0 //positions
        //now that we have the index
        let index = targetContentOffset.pointee.x / view.frame.width
        let indexPath = NSIndexPath(item:Int(index) , section: 0)
        menuBar.collectionView.selectItem(at: indexPath as IndexPath, animated: true, scrollPosition: [])
    }
    
    func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        if targetContentOffset.pointee.y < scrollView.contentOffset.y {
            // UP
        } else {
            // DOWN
        }
    }
    
    
    

}
