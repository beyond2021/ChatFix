//
//  MenuBar.swift
//  OnFleek
//
//  Created by Kev1 on 4/27/17.
//  Copyright © 2017 Kev1. All rights reserved.
//
//add this view inside Home controller ViewDidLoad
import UIKit

extension UIColor {
    //convenient method that returns a color for me.
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat)  -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
}



class MenuBar: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    let imageNames = ["Home Filled-50", "Phone Filled-50", "Screenshot Filled-50", "POS Terminal Filled-50"]
    
    var messageController : MessagesController?
////    var messageController : MessagesController2?
    
    //collectionView to hold buttons
    lazy var collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        //cv.backgroundColor = UIColor.rgb(red: 230, green: 32, blue: 31)
        cv.backgroundColor = UIColor(r: 61, g: 91, b: 151)
        cv.translatesAutoresizingMaskIntoConstraints = false
        //
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    let cellId = "cellId"
    
    //Override frame initializer
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        backgroundColor =  UIColor(r: 61, g: 91, b: 151)
//        //backgroundColor =  .red
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    //Override frame initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(collectionView)
        //backgroundColor =  UIColor.rgb(red: 230, green: 32, blue: 31)
        
        //x,y,width,height
        collectionView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        collectionView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        collectionView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        collectionView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        //
        collectionView.register(MenuCell.self, forCellWithReuseIdentifier: cellId)
        //selecxting the home button on start up
        let selectedIndexpath = NSIndexPath(row: 0, section: 0)
        collectionView.selectItem(at: selectedIndexpath as IndexPath, animated: false, scrollPosition: [])
        //
        setupHorizontalBar()
        
    }
    
    var horizontalBarLeftConstraint : NSLayoutConstraint?
    
    
    func setupHorizontalBar(){
        let horizontalBarView = UIView()
        //horizontalBarView.backgroundColor = UIColor(white: 0.9, alpha: 1) //whitish color
        //UIColor.rgb(red: 200, green: 201, blue: 210)
        horizontalBarView.backgroundColor = UIColor.rgb(red: 200, green: 201, blue: 210)
        horizontalBarView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(horizontalBarView)
        
        //New School
        horizontalBarLeftConstraint = horizontalBarView.leftAnchor.constraint(equalTo: self.leftAnchor)
        horizontalBarLeftConstraint?.isActive = true
        horizontalBarView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        horizontalBarView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1/4).isActive = true
        horizontalBarView.heightAnchor.constraint(equalToConstant: 4).isActive = true
        
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // 1/4
        return CGSize(width: frame.width / 4, height: frame.height)
        
    }
    
    // reduce the spacing
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! MenuCell
        //cell.backgroundColor = .blue
        cell.imageView.image = UIImage(named: imageNames[indexPath.item])?.withRenderingMode(.alwaysTemplate)//changes the tintcolr of the imageview
        
       // cell.tintColor = UIColor.rgb(red: 91, green: 14, blue: 13)
        //cell.tintColor = UIColor(r: 61, g: 91, b: 151)
        cell.tintColor = .blue
        
        return cell
    }
    
    //MARK:- animating
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //
        
        //print(indexPath.item)
        //1: find the x and modify everytime we click 
        let x = CGFloat(indexPath.item) * frame.width / 4 //calculates the left edge
        horizontalBarLeftConstraint?.constant = x
        
        UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.layoutIfNeeded() // animates bar when buttons are pressed
        }, completion: nil)
        //CALLING A FUNC FROM MESSAGESCONTROLLER FROM HERE. go back to messC and set a ref

        messageController?.scrollToMenuIndex(menuItem: indexPath.item)
        
        //messageController.scrollToMenuIndex(indexPath.item)
    }


  
    
    
    
    
    
}

