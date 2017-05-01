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
    var name : SettingName
    var imageName : String
    //initializers is a must with nsobject
    
    init(name : SettingName, imageName : String) {
        self.name = name
        self.imageName = imageName
    }
}
