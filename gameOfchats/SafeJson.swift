//
//  SafeJson.swift
//  ChatFix
//
//  Created by Kev1 on 5/21/17.
//  Copyright © 2017 Kev1. All rights reserved.
//

import Foundation
class SafeJsonObject: NSObject {
    
    override func setValue(_ value: Any?, forKey key: String) {
        let selectorString = "set\(key.uppercased().characters.first!)\(String(key.characters.dropFirst())):"
        let selector = Selector(selectorString)
        if responds(to: selector) {
            super.setValue(value, forKey: key)
        }
    }
    
}
