//
//  SettingCell.swift
//  OnFleek
//
//  Created by Kev1 on 4/30/17.
//  Copyright © 2017 Kev1. All rights reserved.
//

import UIKit

class SettingCell: BaseCell {
    
    override var isHighlighted: Bool {
        didSet {
            //print(isHighlighted)// will toggle true / false
            backgroundColor = isHighlighted ? .darkGray : .white
            nameLabel.textColor = isHighlighted ? .white : .black
            iconImageView.tintColor = isHighlighted ? .white : .darkGray
        }
        
    }
    var setting : Setting? {
        didSet {
            //INFO MUST BE SET IN HERE IN ORDER TO SHOW
            nameLabel.text = setting?.name
            //SAFELY
            if let imageName = setting?.imageName {
              iconImageView.image = UIImage(named: imageName)?.withRenderingMode(.alwaysTemplate) //SWIFT3 TO CHANGE IMAGE TINT
                //change to dark gray
                iconImageView.tintColor = .darkGray
                
            }
            //iconImageView.image = UIImage(named: (setting?.imageName)!)
        }
        
    }
    
    let nameLabel: UILabel = {
        let nl = UILabel()
        nl.translatesAutoresizingMaskIntoConstraints = false
        nl.font = UIFont.systemFont(ofSize: 13)
        nl.text = "Settings Filled-50"
       return nl
    }()
    
    let iconImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.image = UIImage(named: "Settings Filled-50")
        return iv
    }()
    
    
    override func setupViews() {
        super.setupViews()
        //backgroundColor = .blue
        
        addSubview(nameLabel)
        addSubview(iconImageView)
        //x,y,width,height
        nameLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant : 54).isActive = true
        nameLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant : 8).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
            
            
        
        
        iconImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant : 8).isActive = true
        iconImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        iconImageView.widthAnchor.constraint(equalToConstant: 30).isActive = true
        iconImageView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
    }
    
}
