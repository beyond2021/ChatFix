//
//  FixItCell.swift
//  gameOfchats
//
//  Created by Kev1 on 5/11/17.
//  Copyright © 2017 Kev1. All rights reserved.
//

import UIKit

class FixItCell: BaseFeedCell {
    
    let fixitVC : UIViewController = {
        let vc = UIViewController()
        vc.view.backgroundColor = .black
       return vc
    }()
    var messageController : MessagesController?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        DescriptionLabel.text = "Video Fixing Comimg Soon"
        let image = UIImage(named: "kaboompics_Man using a tablet")
        backgroundImageView.image = image
        
        
        
        
        
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(showQuoteController))
        swipeUp.direction = .up
        
        
        self.addGestureRecognizer(swipeUp)
        

       
    }
    
    
    override func prepareForReuse() {
     //   showQuoteController()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var messagesController : MessagesController?
    func showQuoteController(){
       NotificationCenter.default.post(name: MENUBAR_PRESS_QUOTE_NOTIFICATION, object: nil)  
    }
    
}
