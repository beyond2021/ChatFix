//
//  DateConversion.swift
//  gameOfchats
//
//  Created by Kev1 on 5/1/17.
//  Copyright © 2017 Kev1. All rights reserved.
//

import Foundation
import UIKit



    extension Date {
        
        var timeAgoString: String {
            let interval = Calendar.current.dateComponents([.year, .month, .day, .hour], from: self, to: Date())
            if let year = interval.year, year > 0 {
                return year == 1 ? "\(year) year ago" : "\(year) years ago"
            } else if let month = interval.month, month > 0 {
                return month == 1 ? "\(month) month ago" : "\(month) months ago"
            } else if let day = interval.day, day > 0 {
                return day == 1 ? "\(day) day ago" : "\(day) days ago"
            } else if let hour = interval.hour, hour > 0 {
                return hour == 1 ? "\(hour) hour ago" : "\(hour) hours ago"
            } else {
//                let dateFormatter = DateFormatter()
//                dateFormatter.dateFormat = "hh:mm:ss a" // google the format
//                //             timeLabel.text = dateFormatter.string(from: timeStampDate as Date)
//                //return "a moment ago"
//                
                
                return "a moment ago"
            }
        }
        
    }
    




