//
//  CallingCell.swift
//  gameOfchats
//
//  Created by Kev1 on 5/11/17.
//  Copyright © 2017 Kev1. All rights reserved.
//

import UIKit

class CallingCell: BaseFeedCell {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    /*
    let bgView : UIView = {
        let vc = UIView()
        vc.backgroundColor = .white
        vc.translatesAutoresizingMaskIntoConstraints = false
      //  vc.canBecomeFirstResponder = true
        
        
       return vc
    }()
 */
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let image = UIImage(named: "20")
        backgroundImageView.image = image
        
//        addSubview(bgView)
//        bgView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
//        bgView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
//        bgView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
//        bgView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
    //    self.canBecomeFirstResponder = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK:- Motion
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
      print("I received a shake")
        
        
    }
    
    
    


}
