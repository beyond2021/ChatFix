//
//  ApiService.swift
//  gameOfchats
//
//  Created by Kev1 on 5/9/17.
//  Copyright © 2017 Kev1. All rights reserved.
//

import Foundation
import Firebase

import UIKit
/*
class ApiService: NSObject {
    static let sharedInstance = ApiService()
    
    func checkIfUserIsLoggedIn(){
        
        if FIRAuth.auth()?.currentUser?.uid == nil {
            // handleLogout() // getting too many controllers error
////            perform(#selector(handleLogout), with: nil, afterDelay: 0)
        } else {
            
            fetchUserAndSetUpNavBarTitle()
        }
        
        
    }
//

    func fetchUserAndSetUpNavBarTitle(){
        
        guard let uid = FIRAuth.auth()?.currentUser?.uid else {
            // if for some reason uid is nil
            return
        }
        FIRDatabase.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
           
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                //  self.navigationItem.title = dictionary["name"] as? String
                let user = User()
                user.setValuesForKeys(dictionary)
////                self.setUpNavBarWithUser(user: user) // contains the name email and image of the user
                
            }
            
        }, withCancel: nil)
        
        
    }
    
    //
    
    //AN ARRAY TO HOLD ALL THE MESSAGES
    var messages = [Message]()
    //GROUPING THE MESSAGES
    var messagesDictionary = [String: Message]()
    
    //FAN-OUT
    //func fetchVideos(completion:@escaping ([Video]) -> ()){
    
    func  observeUserMessages(completion:@escaping ([Message]) -> ()){
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
////            self.attempTedReloadOfTable()
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
                //self.messages.append(message)
                //print(self.messages.count)
                
                //let chatCell = ChatCell()
                //self.chatCell?.messages?.append(message)
                //self.chatCell?.feedArray.append(message)
                feedArray.append(message)
                print("Filling up my array:",feedArray.count)
                
                
                
                
                
                //This will crash because of backgroung thread so lets call this on Dispatch_asyn
                //GROUPING THE MESSAGES.This block below of code pick up all the different messages. 1 per user
                if let toId = message.chatPartnerId() {
                    self.messagesDictionary[toId] = message
                }
                
////                self.attempTedReloadOfTable()
                
            }
            
            
        }, withCancel: nil)
        
        
    }
    
    
    

    
    

}
 */
