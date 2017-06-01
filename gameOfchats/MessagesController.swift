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
        NotificationCenter.default.addObserver(self, selector: #selector(workViewUp), name: WORK_VIEW_UP_NOTIFICATION, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(workViewDown), name: WORK_VIEW_DOWN_NOTIFICATION, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showControllerForQuote), name: MENUBAR_PRESS_QUOTE_NOTIFICATION, object: nil)
        
        
        fadeInMenubar()
        //darken the navbar
        navigationController?.navigationBar.isTranslucent = false
        
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
        //MENUBAR
//        setupMenuBar()
        //
        setupNavBarButtonsOnRight()
      //  perform(#selector(handleLogout), with: nil, afterDelay: 0)
        checkIfUserIsLoggedIn()
        
    }
    
    deinit {
//        NotificationCenter.default.rem(self, selector: #selector(workViewUp), name: WORK_VIEW_UP_NOTIFICATION, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(workViewDown), name: WORK_VIEW_DOWN_NOTIFICATION, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(showControllerForQuote), name: MENUBAR_PRESS_QUOTE_NOTIFICATION, object: nil)
        NotificationCenter.removeObserver(self, forKeyPath: WORK_VIEW_UP_NOTIFICATION.rawValue)
        NotificationCenter.removeObserver(self, forKeyPath: WORK_VIEW_DOWN_NOTIFICATION.rawValue)
        NotificationCenter.removeObserver(self, forKeyPath: MENUBAR_PRESS_QUOTE_NOTIFICATION.rawValue)
    }
    
    func checkIfUserIsLoggedIn(){
        
        if FIRAuth.auth()?.currentUser?.uid == nil {
            // handleLogout() // getting too many controllers error
              perform(#selector(handleLogout), with: nil, afterDelay: 0)
            //FIRAuth.auth()?.currentUser?.uid  // this is the userid of the person with the phones
            
        } else {
            
            fetchUserAndSetUpNavBarTitle()
            /*
            // here we fetch a single value for the
            let uid = FIRAuth.auth()?.currentUser?.uid
            
            FIRDatabase.database().reference().child("users").child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
                //
              //  print("SINGLE SNAPSHOT IS:",snapshot)
                /*
                 SINGLE SNAPSHOT IS: Snap (F2J7xibI2fY8wItqk5IUoi5rwX52) {
                 email = "Bk@gmail.com";
                 name = "Brudda  Keev";
                 profileImageUrl = "https://firebasestorage.googleapis.com/v0/b/peephole-6f487.appspot.com/o/profile_images%2FC69FF9E5-FF06-4C34-8BB8-23BDD20F3125.jpg?alt=media&token=aabc0213-9b77-44f0-8249-f4b3347e0dce";
                 }
                 //
 */
                //when we get this value, we are not longer listening
          //      self.navigationItem.title = ???
                // get the name out of the snapshot dictionary
                if let dictionary = snapshot.value as? [String:AnyObject]{
                 // self.navigationItem.title = dictionary["name"] as? String
                    print("Navigation title is:",dictionary["name"] as? String ?? "No Name" )
                }
                
                
                
            }, withCancel: nil)
            //return
 */
        }
 
        
    }

    
    
    
    
    func viewWillAppear() {
        super.viewWillAppear(true)
//        collectionView?.reloadData()
////        setupCollectionView()
        fadeInMenubar()
    }
 
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
       // fadeInMenubar()
        workUpFlag = false
        
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
    
    override func motionBegan(_ motion: UIEventSubtype, with event: UIEvent?) {
     //   print("Device was shaken!")
        if(event?.subtype == UIEventSubtype.motionShake) {
            if workUpFlag == true {
                print("You shook me, now what")
                //scrollToMenuIndex(menuItem: 2)
//                self.collectionView.scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:NO
//                let indexPath = NSIndexPath(item: 2, section: 0)
//                self.collectionView?.scrollToItem(at: indexPath as IndexPath, at: .centeredHorizontally, animated: true)
                
            }
            
            
        }
    }
    
    
    //MARK:- ShakeGesture
     func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent?) {
        if(event?.subtype == UIEventSubtype.motionShake) {
            print("You shook me, now what")
        }
    }
    
    
    //MARK:- SETUP
    
    func fadeInMenubar(){
       // menuBar.alpha = 0
        UIView.animate(withDuration: 1.0, delay: 1.5, usingSpringWithDamping: 1, initialSpringVelocity: 2, options: .curveEaseOut, animations: {
          //  self.menuBar.alpha = 1
            self.setupMenuBar()
        }) { (true) in
            self.setupCollectionView()
        }
        
    }
    
    
    
    
    
    func setupCollectionView(){
        
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
        collectionView?.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
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
        view.backgroundColor = aquaBlueChatfixColor
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
 
    
    //Private because no other class need to access this
     func setupMenuBar(){
        navigationController?.hidesBarsOnSwipe = false
       // let blueView = UIView()
       // blueView.backgroundColor = UIColor(r: 61, g: 91, b: 151)
       // blueView.backgroundColor = aquaBlueChatfixColor
        view.addSubview(blueView)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: blueView)
        view.addConstraintsWithFormat(format: "V:[v0(50)]", views: blueView)
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
    
    
    
    func handleSearch(){
  //      scrollToMenuIndex(menuItem: 2)
    }
    
    
    //MARK:- SCROLL RELATED
    
    //AUTOMATIC SCROLL TO MENUITEM POSITION. THIS FUNC IS USED INSIDE OF MENUBAR-EVERYTIME WE TAP ON THE ICON
    func scrollToMenuIndex(menuItem:Int){
        let indexPath = NSIndexPath(item: menuItem, section: 0)
        collectionView?.scrollToItem(at: indexPath as IndexPath, at: [], animated: true)
        
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
            
            resetNav()
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: chatCellId, for: indexPath) as! ChatCell
            
            cell.messagesController = self
           
          cell.observeUserMessages()
            
            
            navigationController?.navigationBar.isHidden = false
           
            
            return cell
            
        } else if indexPath.item == 1 {
          //  removeNav()
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CallingCellId, for: indexPath) as! CallingCell
            cell.messagesController = self
            navigationController?.navigationBar.isHidden = false
           // fadeInMenubar()
            
            return cell
            
        } else if indexPath.item == 2 {
            resetNav()
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FixitCellId, for: indexPath) as! FixItCell
            cell.messagesController = self
          // cell.showQuoteController()
            navigationController?.navigationBar.isHidden = true
           print("Quote")
            
            
            return cell
            
        }else if indexPath.item == 3{
            resetNav()
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CheckoutCellId, for: indexPath) as! CheckoutCell
           navigationController?.navigationBar.isHidden = false
           // fadeInMenubar()
            
            
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
    
   /*(
    //MARK:- COLLECTIONVIEW DELEGATE METHODS
    private func attempTedReloadOfTable() {
        
        self.timer?.invalidate()
        //print("We just cancelled the timer")
        self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.handleReloadTable), userInfo: nil, repeats: false) //ADD A DELEAY OF 1 SEC TO THE FUNCTION TO FIRE
        // print("schedule a table reload in 0.1 seconds")
        
        
    }
 */
    
    
/*
    
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
            // self.tableView.reloadData() //refresh our tableview
            self.collectionView?.reloadData()
        })
        
        
    }
    
    
    
    func swipeLeft(){
        
        
    }
 */
    
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
        // containerView.backgroundColor = UIColor.yellow
        containerView.backgroundColor = UIColor(r: 61, g: 91, b: 151)
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
//        nameLabel.textColor = UIColor.rgb(red: 200, green: 201, blue: 210)
        nameLabel.textColor = .white
        
        nameLabel.font = UIFont.boldSystemFont(ofSize: 16)
        
        //print("The user is:", user.name ?? "")
        
        nameLabel.text = (user.name)?.uppercased()
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
        
        //Finally center the container
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
    
    func resetNav(){
        navigationController?.navigationBar.isHidden = false
        navigationController?.setNavigationBarHidden(false, animated: true)
        //self.messagesController?.menuBar.removeFromSuperview()
        navigationController?.navigationBar.isTranslucent = false
        //    self.messagesController?.menuBar.isHidden = false
        blueView.alpha = 1            //
       // setupMenuBar()
        
        //            self.messagesController?.menuBar.alpha = 1
        
        menuBar.isHidden = false
        menuBar.alpha = 1
        
        
    }
    
    func removeNav() {
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.setNavigationBarHidden(true, animated: true)
        menuBar.isHidden = true
        
        
    }
    
    func showControllerForQuote(){
        let dummySettingsViewController = QuoteViewController()
        
//        self.present(dummySettingsViewController, animated: true, completion: nil)
        
        
        dummySettingsViewController.navigationItem.title = "QUOTE"
        
        
        
        
       // dummySettingsViewController.view.backgroundColor = .white
        dummySettingsViewController.view.backgroundColor = .clear
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white] //CHANGING
        navigationController?.navigationBar.tintColor = .white //setting the back button color
        
        menuBar.isHidden = true
        
        
        
        navigationController?.pushViewController(dummySettingsViewController, animated: true)
        
    }
    
    
    
    
}

//Extension


