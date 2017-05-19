//
//  FixItCell.swift
//  gameOfchats
//
//  Created by Kev1 on 5/11/17.
//  Copyright © 2017 Kev1. All rights reserved.
//

import UIKit

class FixItCell: BaseFeedCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        DescriptionLabel.text = "Video Fixing Comimg Soon"
        let image = UIImage(named: "kaboompics_Man using a tablet")
        backgroundImageView.image = image

       
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
