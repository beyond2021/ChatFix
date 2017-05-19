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
        label.textColor = UIColor.rgb(red: 200, green: 201, blue: 210)
        label.textAlignment = .center
        
        return label
    }()
    
    let backgroundImageView : UIImageView = {
        let iv = UIImageView()
        iv.isUserInteractionEnabled = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "AdobeStock_44190609")
        iv.clipsToBounds = true
       // iv.image = image
        iv.contentMode = .scaleAspectFill
        return iv
    }()

    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //backgroundColor = UIColor.rgb(red: 200, green: 201, blue: 210)
        let image = UIImage(named: "AdobeStock_44190609")
        backgroundImageView.image = image
        
        
        
        backgroundColor = UIColor.rgb(red: 20, green: 23, blue: 33)
        setupLabel()
        addSubview(backgroundImageView)
        backgroundImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        backgroundImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        backgroundImageView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        backgroundImageView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
       
        
        
        
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





