//
//  MenuCell.swift
//  gameOfchats
//
//  Created by Kev1 on 5/1/17.
//  Copyright © 2017 Kev1. All rights reserved.
//

import UIKit

//Stop redundancy create a superclass
class BaseCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    func setupViews() {
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}



class MenuCell: BaseCell {
    //adding the imageViews to the cells
    let imageView : UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.image = UIImage(named: "Home Filled-50")?.withRenderingMode(.alwaysTemplate)//changes the tintcolr of the imageview
        //iv.tintColor = UIColor.rgb(red: 91, green: 14, blue: 13)
        iv.tintColor = .black
        //set the tinit color
        return iv
    }()
    
    //This happens when a cell is selected
    override var isHighlighted: Bool {
        didSet{
            //  print(123)
            //imageView.tintColor = isHighlighted ? .white : UIColor.rgb(red: 91, green: 14, blue: 13)//tenary statement / short cut if else statement
            imageView.tintColor = isHighlighted ? .white : .black
            
        }
        
    }
    
    override var isSelected:  Bool {
        didSet{
            //print(123)
            //imageView.tintColor = isSelected ? .white : UIColor.rgb(red: 91, green: 14, blue: 13)//tenary statement / short cut if else statement
            imageView.tintColor = isSelected ? .white : .black
        }
        
    }
    
    
    
    
    override func setupViews(){
        super.setupViews()
        // backgroundColor = .yellow
        addSubview(imageView)
        
        //x,y,width,height
        imageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 28).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 28).isActive = true
        
    }
    
}



