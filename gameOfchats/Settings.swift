//
//  Settings.swift
//  OnFleek
//
//  Created by Kev1 on 4/30/17.
//  Copyright © 2017 Kev1. All rights reserved.
//

import Foundation

class Setting: NSObject {
    //
    var name : String
    var imageName : String
    //initializers is a must with nsobject
    
    init(name : String, imageName : String) {
        self.name = name
        self.imageName = imageName
    }
}
