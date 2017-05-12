//
//  CallingCell.swift
//  gameOfchats
//
//  Created by Kev1 on 5/11/17.
//  Copyright © 2017 Kev1. All rights reserved.
//

import UIKit

class BaseFeedCell: UICollectionViewCell {
    
    let DescriptionLabel : UILabel = {
        let label = UILabel()
        label.text = "VOIP Calling coming soon."
        label.font = UIFont.boldSystemFont(ofSize: 25)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
       // label.textColor = UI
        
        
      return label
    }()
    
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.rgb(red: 200, green: 201, blue: 210)
        setupLabel()
        
        
    }
    
    func setupLabel(){
               addSubview(DescriptionLabel)
                DescriptionLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
                DescriptionLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
               DescriptionLabel.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
               DescriptionLabel.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true

        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}





