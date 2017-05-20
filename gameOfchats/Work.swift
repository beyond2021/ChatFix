//
//  Work.swift
//  ChatFix
//
//  Created by Kev1 on 5/20/17.
//  Copyright © 2017 Kev1. All rights reserved.
//

import Foundation

class Work: NSObject {
    // inside here "User" we will hold reference to email and name. These are the values inside the snapshots
    var workId :String?
//    var customerId :String?
    var name : String?
    var workDescription : String?
 //   var workEstimate : NSNumber?
//    var profileImageUrl: String?
//    var workSchedule : NSDate?
   // TODO
        init(dictionary: [String : AnyObject]) {
            
           
            self.workId = dictionary["workId"] as? String
            self.name = dictionary["title"] as? String
//            self.customerId = dictionary["customerId"] as? String
            self.workDescription = dictionary["workDescription"] as? String
            
        }
    
    
}

/*
extension Work {
    convenience init?(json: [String: Any]) {
        guard let name = json["title"] as? String,
            let customerId = json["customerId"] ,
            let workDescription = json["workDescription"],
            let workId = json["workId"]
            else {
                return nil
        }
        
        
        self.name = name
        self.customerId = customerId as! String
        self.workDescription = workDescription as! String
    }
}
 */
