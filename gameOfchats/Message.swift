//
//  Message.swift
//  gameOfchats
//
//  Created by Kev1 on 4/7/17.
//  Copyright © 2017 Kev1. All rights reserved.
//

import UIKit
import Firebase

class Message: NSObject {
    var fromId : String?
    var text : String?
    var timeStamp : NSNumber?
    var toId : String?
    var imageUrl : String?
    var imageHeight : NSNumber?
    var imageWidth : NSNumber?
    var videoUrl : String?
    var isVisited : Bool?

    //FILLED UP IN MESSAGES CONTROLLER
    //toid fromId logic
    // figuring out the chat partner logic
    func chatPartnerId() -> String? {
        return fromId == FIRAuth.auth()?.currentUser?.uid ? toId : fromId // same as below
        /*
                if fromId == FIRAuth.auth()?.currentUser?.uid {
            //if the from id is the current logged in user
            return toId
        } else {
           return fromId
        }
 */
        
        
    }
    //Dictionary Constructor for message
    init(dictionary: [String : AnyObject]) {
        super.init()
        fromId = dictionary["fromId"] as? String
        text = dictionary["text"] as? String
        timeStamp = dictionary["timeStamp"] as? NSNumber
        toId = dictionary["toId"] as? String
        imageUrl = dictionary["imageUrl"] as? String
        imageHeight = dictionary["imageHeight"] as? NSNumber
        imageWidth = dictionary["imageWidth"] as? NSNumber
        videoUrl = dictionary["videoUrl"] as? String
        isVisited = false
        
        
    }
    
    

}
