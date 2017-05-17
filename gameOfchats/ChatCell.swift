//
//  ChatCell.swift
//  gameOfchats
//
//  Created by Kev1 on 5/8/17.
//  Copyright © 2017 Kev1. All rights reserved.
//

import UIKit
import  Firebase
import AVFoundation

protocol ChatCellDelegate: class {
    //func openChatController(user: User)
    func openChatController(sender: ChatCell)
    
}





class ChatCell: UICollectionViewCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
   
    
    
    weak var delegate :ChatCellDelegate?
    //var userMessages : [Message] = []
    let cellId = "cellId"
    var deleteView: UIButton?
    var imageView: UIImageView?
    
   //
    
    lazy var collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.isUserInteractionEnabled = true
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.delegate = self
        cv.dataSource = self
        return cv
    }()
    
    
    func deleteCell(){
        print("Deleting the cell.")
        
    }
    
    
    let backgroundImageView : UIImageView = {
        let iv = UIImageView()
        iv.isUserInteractionEnabled = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "AdobeStock_132678227")
        iv.clipsToBounds = true
        iv.image = image
        iv.contentMode = .scaleAspectFill
        return iv
    }()


    let visualEffectView : UIVisualEffectView = {
     let view = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
        
    }()
   
    
   
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        checkIfUserIsLoggedIn() //Main Call
//observeUserMessages()
        addSubview(backgroundImageView)
        backgroundImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        backgroundImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        backgroundImageView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        backgroundImageView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        backgroundImageView.addSubview(visualEffectView)
        visualEffectView.leftAnchor.constraint(equalTo: backgroundImageView.leftAnchor).isActive = true
        visualEffectView.rightAnchor.constraint(equalTo: backgroundImageView.rightAnchor).isActive = true
        visualEffectView.widthAnchor.constraint(equalTo: backgroundImageView.widthAnchor).isActive = true
        visualEffectView.heightAnchor.constraint(equalTo: backgroundImageView.heightAnchor).isActive = true
    //    observeUserMessages()
        visualEffectView.alpha = 0

        
        setupCollectionView()
        collectionView.alpha = 0
        animateBackground()
        
//        collectionView.prefetchDataSource = self as? UICollectionViewDataSourcePrefetching
        
//        collectionView.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.old, context: nil)
        
        //collectionView.reloadData()
     // resetCollectionViewAndEmptyData()
       // getUserMessages()
    }
    
    func animateBackground(){
        self.visualEffectView.alpha = 0
        
        
        UIView.animate(withDuration: 3.5, delay: 1.5, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
            //
            self.collectionView.alpha = 1
            self.visualEffectView.alpha = 1
            
            
        }) { (true) in
            // 
          //  self.setupCollectionView()
            self.collectionView.prefetchDataSource = self as? UICollectionViewDataSourcePrefetching
        }
        
    }
    
    
    func getUserMessages() {
      let loginController = LoginController()
        loginController.chatCell = self
        
    }
    
    //MARK:- DATA AREA
    
    //AN ARRAY TO HOLD ALL THE MESSAGES
    var messages = [Message]()
    //GROUPING THE MESSAGES
    var messagesDictionary = [String: Message]()
    
    //FAN-OUT
    func  observeUserMessages(){
       //self.attempTedReloadOfTable()
        messages.removeAll()
        messagesDictionary.removeAll()
        
     //  collectionView.reloadData()
        
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
                // print("Message Id:",snapshot.key)
                let messageId = snapshot.key
                print("New messgaeId is:", messageId)
                self.fetchMessageWithMessageId(messageId: messageId)
                //
            }, withCancel: nil)
            
        }, withCancel: nil)
        //OBSERVE WHEN CHILD IS REMOVED
        ref.observe(.childRemoved, with: { (snapshot) in
            // print(snapshot.key)
            // print(self.messagesDictionary)
            self.messagesDictionary.removeValue(forKey: snapshot.key) //empty the dictionary
            self.attempTedReloadOfTable() //reload the collectionview
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
             //  print(self.messages.count)
                
                
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
            //self.tableView.reloadData() //refresh our tableview
            self.collectionView.reloadData()
        })
        
        
    }
    
    
    
    
    //MARK: - checkIfUserIsLoggedIn
    func checkIfUserIsLoggedIn(){
        
        if FIRAuth.auth()?.currentUser?.uid == nil {
            // handleLogout() // getting too many controllers error
//*            perform(#selector(handleLogout), with: nil, afterDelay: 0)
            
          // self.messagesController?.handleLogout()
            
          //  perform(#selector(self.messagesController?.handleLogout), with: nil, afterDelay: 0)
            
          
            
            
        } else {
            
            fetchUserAndSetUpNavBarTitle()
           
        }
        
        
    }
    
    /*
    func performLogout(){
        if let aClass = NSClassFromString("MessagesController") {
            let sel = #selector(MessagesController.handleLogout)
           // let num = NSNumber(value: 1337)
            
            if let myClass = aClass as? NSObjectProtocol {
                if myClass.responds(to: sel) {
                  //  myClass.perform(sel)
                    print("Gonna try to open logout from Chatcell")
                }
            }
        }
        
        
        
        
        
    }
 */
    
    
    
    
    
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
                
               // print("The user is:", user)
                
                
                user.setValuesForKeys(dictionary)
              // self.setUpNavBarWithUser(user: user)
                
                
                
               self.resetCollectionViewAndEmptyData()
                
                // contains the name email and image of the user
                self.messagesController?.setUpNavBarWithUser(user: user)
                
                   self.resetAndLoad()
                
                //self.observeUserMessages()
            }
            
        }, withCancel: nil)
        
     // observeUserMessages()
    }
    
    
   func  resetAndLoad() {
    messages.removeAll()
    messagesDictionary.removeAll()
    collectionView.reloadData()
  //  observeUserMessages()
    
    
    }
    
    
    
    
    func resetCollectionViewAndEmptyData() {
        //remove all the messages in here
        messages.removeAll()
        messagesDictionary.removeAll()
        //*        tableView.reloadData()
        collectionView.reloadData()
        
        //u
        //listen call listen to logged in user. logged in messages
     //   observeUserMessages()

        
        
    }
    
   
 
 
    //MARK: - Loading the showChatController by clicking the nav
    
  /*
     -(void)remove:(int)i {
     
     [self.collectionObj performBatchUpdates:^{
     [array removeObjectAtIndex:i];
     NSIndexPath *indexPath =[NSIndexPath indexPathForRow:i inSection:0];
     [self.collectionObj deleteItemsAtIndexPaths:[NSArray arrayWithObject:indexPath]];
     
     } completion:^(BOOL finished) {
     
     }];
     }
 
 */
    
    /*
     [self.collectionView performBatchUpdates:^{
     
     NSArray *selectedItemsIndexPaths = [self.collectionView indexPathsForSelectedItems];
     
     // Delete the items from the data source.
     [self deleteItemsFromDataSourceAtIndexPaths:selectedItemsIndexPaths];
     
     // Now delete the items from the collection view.
     [self.collectionView deleteItemsAtIndexPaths:selectedItemsIndexPaths];
     
     } completion:nil];
     
     
     
     // This method is for deleting the selected images from the data source array
     -(void)deleteItemsFromDataSourceAtIndexPaths:(NSArray  *)itemPaths
     {
     NSMutableIndexSet *indexSet = [NSMutableIndexSet indexSet];
     for (NSIndexPath *itemPath  in itemPaths) {
     [indexSet addIndex:itemPath.row];
     }
     [self.images removeObjectsAtIndexes:indexSet]; // self.images is my data source
     
     }
 
 */
    
    
    
    
    
   /////////
    func setupCollectionView() {
//        backgroundImageView.addSubview(collectionView)
        addSubview(collectionView)
        
        
        
//        collectionView.centerXAnchor.constraint(equalTo: backgroundImageView.centerXAnchor).isActive = true
//        collectionView.centerYAnchor.constraint(equalTo: backgroundImageView.centerYAnchor).isActive = true
//        collectionView.widthAnchor.constraint(equalTo: backgroundImageView.widthAnchor).isActive = true
//        collectionView.heightAnchor.constraint(equalTo: backgroundImageView.heightAnchor).isActive = true
        
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        
        collectionView.centerXAnchor.constraint(equalTo: visualEffectView.centerXAnchor).isActive = true
        collectionView.centerYAnchor.constraint(equalTo: visualEffectView.centerYAnchor).isActive = true
        collectionView.widthAnchor.constraint(equalTo: visualEffectView.widthAnchor, constant: -20).isActive = true
        collectionView.heightAnchor.constraint(equalTo: visualEffectView.heightAnchor).isActive = true

        
        
        
        
        collectionView.contentInset = UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0)
        collectionView.scrollIndicatorInsets = UIEdgeInsets(top:50, left: 0, bottom: 0, right: 0)
        
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .vertical
            //flowLayout.scrollDirection = .horizontal
            flowLayout.minimumLineSpacing = 10 //Decrease the gap
            
        }

        
        collectionView.backgroundColor = .clear
        //ChatCell
        collectionView.register(MessageCell.self, forCellWithReuseIdentifier: cellId)
        
        //
        
        
        
        //resetCollectionViewAndEmptyData()
        
        collectionView.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.old, context: nil)
        
       collectionView.reloadData()
        
        
    }
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        print("Collection view is reloaded")
    }
    
    deinit {
        collectionView.removeObserver(self, forKeyPath: "contentSize")
        print("removing SOUND")
    }
    
    
    
    
    //DataSource Methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      
       // print(messages.count)
        return messages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? MessageCell
        cell?.chatCell = self
        //cell.backgroundColor = .white
        //cell?.backgroundColor = UIColor.rgb(red: 89, green: 89, blue: 94)
        //print("Feed array messages are:",messages.count)
        
        let message = messages[indexPath.row]//get the message for the proper row
        cell?.proileImageView.image = nil
        
        cell?.message = message //THIS IS WHERE THE MESSAGE VAR IN USERCELL IS SET
        //print("Message is:", message)
        
        
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        //
       //print("about to display :", indexPath.item)
        
    }
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        //
      //  print( "\(indexPath.item) is about to leave")
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
               
        
        return CGSize(width: self.frame.width - 20, height: 80)
    }
    
    weak var messagesController : MessagesController?
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //print("I am pressing:", indexPath.item)
        
        let cell : MessageCell = collectionView.cellForItem(at: indexPath) as! MessageCell
       // print("Print cell is:", cell.message ?? "")
        
        if cell.message?.isVisited == false {
            cell.newMessageView.backgroundColor = .clear
        }
        
        
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
           // self.showChatControllerForUser(user: user) // use user
            self.messagesController?.showChatControllerForUser(user: user)
           
            
//            self.delegate?.openChatController(user: user)
            
            //self.delegate?.openChatController(sender: self)
            
        }, withCancel: nil)
         }
    
    
    
 
   func swipeLeft() {
        print("Swiping left")
        
    }
    
    
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

extension ChatCell : UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
      //  ImagePreloader.preloadImagesForIndexPaths(indexPaths) // happens on a background queue
    }
    
    func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
      //  ImagePreloader.cancelPreloadImagesForIndexPaths(indexPaths) // again, happens on a background queue
    }
}



