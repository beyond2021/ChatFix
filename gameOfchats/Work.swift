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
    var workId : NSNumber?
//    var customerId :String?
    var name : String?
    var workDescription : String?

//    override func setValue(_ value: Any?, forKey key: String) {
//        //
//    }
    
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
