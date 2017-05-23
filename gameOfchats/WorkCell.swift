//
//  WorkCell.swift
//  ChatFix
//
//  Created by Kev1 on 5/20/17.
//  Copyright © 2017 Kev1. All rights reserved.
//

import UIKit

class WorkCell: UICollectionViewCell {
    var callingCell : CallingCell?
    
    let workCellNameLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
       // label.font = UIFont.systemFont(ofSize: 16)
        label.font = UIFont.boldSystemFont(ofSize: 18)
        
        
//        label.textColor = UIColor.rgb(red: 200, green: 201, blue: 210)
//        label.textColor = aquaBlueChatfixColor
        label.textColor = .white
        
        label.numberOfLines = 0
        label.textAlignment = .center
        
        return label
    }()
    
    
    
    var work : Work? {
        didSet{
            workCellNameLabel.text = work?.name
            
        }
        
    }
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
      //  self.layer.borderColor = UIColor.rgb(red: 51, green: 2, blue: 129).cgColor
        self.layer.borderColor = aquaBlueChatfixColor.cgColor
        
        self.layer.borderWidth = 1
//        self.layer.cornerRadius = 8
        self.layer.cornerRadius = 75
        
        self.clipsToBounds = false
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.layer.shadowOpacity = 1
        layer.shadowRadius = 2.0
        layer.masksToBounds = false
        addSubview(workCellNameLabel)
        
        workCellNameLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        workCellNameLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        workCellNameLabel.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -40).isActive = true
        workCellNameLabel.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
        workCellNameLabel.text = "Mobile App Development"
    
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

