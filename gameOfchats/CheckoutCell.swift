//
//  CheckoutCell.swift
//  gameOfchats
//
//  Created by Kev1 on 5/11/17.
//  Copyright © 2017 Kev1. All rights reserved.
//

import UIKit

class CheckoutCell: BaseFeedCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        DescriptionLabel.text = "One Touch Billing Coming Soon"
        let image = UIImage(named: "working-on-macbook-and-iphone-in-a-bed-picjumbo-com")
        backgroundImageView.image = image

        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    
}
