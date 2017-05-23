//
//  Work.swift
//  ChatFix
//
//  Created by Kev1 on 5/20/17.
//  Copyright © 2017 Kev1. All rights reserved.
//

import Foundation

class Work: SafeJsonObject {
    // inside here "User" we will hold reference to email and name. These are the values inside the snapshots
    var workId : NSNumber?
//    var customerId :String?
    var name : String?
    var workDescription : String?
    var imageName : String?

    
}

