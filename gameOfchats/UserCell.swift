//
//  UserCell.swift
//  gameOfchats
//
//  Created by Kev1 on 4/4/17.
//  Copyright © 2017 Kev1. All rights reserved.
//

import UIKit
import Firebase

class UserCell: UITableViewCell {
    var message : Message? {
        
        //came from cellForRow in MessagesController
        didSet{
            
            setupNameAndAvatar()
           // textLabel?.text = message.toId //Put the name instead og the toId
                       detailTextLabel?.text = message?.text
            
            //coverting timestamp to date
            if let seconds = message?.timeStamp?.doubleValue {
             let timeStampDate = NSDate(timeIntervalSince1970: seconds)
                // formatting the date
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "hh:mm:ss a" // google the format
             timeLabel.text = dateFormatter.string(from: timeStampDate as Date)
                
            }
                      
        }
    }
    private func setupNameAndAvatar(){
            
        if let id = message?.chatPartnerId() {
            let ref = FIRDatabase.database().reference().child("users").child(id) //get the ref to the toId
            ref.observe(.value, with: { (snapshot) in
                // print(snapShot)
                // Put the snapshot value in a dictionary
                if  let dictionary = snapshot.value as? [String : AnyObject] {
                    self.textLabel?.text = dictionary["name"] as? String
                    //
                    //lets get the profile image view.Get the profile image url from snapshot
                    if let profileImageUrl = dictionary["profileImageUrl"] as? String {
                        self.proileImageView.loadImageUsingCacheWithUrlString(urlString: profileImageUrl)
                    }
                    
                    
                    //
                }
                
            }, withCancel: nil)
        }
 
        
    }
    
    //Create an imageView
    let proileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "compass")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        //Make it round by modifing the corner erasius
        imageView.layer.cornerRadius = 24 // 24 comes from half of the constraint
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    //MARK:- Grouping messages according to time stamp
    
    let timeLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
      //  label.text = "HH:MM:SS"
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = UIColor.darkGray
        return label
        
    }()

  
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        //Add the imageView as a SubView
        addSubview(proileImageView)
        addSubview(timeLabel)
        setUpProfileImageView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpProfileImageView() {
        // We need 4 constraints
        // x, y, width and height
        //x
        proileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        //y
        proileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        //width
        proileImageView.widthAnchor.constraint(equalToConstant: 48) .isActive = true
        //Height
        proileImageView.heightAnchor.constraint(equalToConstant: 48) .isActive = true
        
        
        /////
       // x, y, width and height
        timeLabel.rightAnchor.constraint(equalTo: self.rightAnchor) .isActive = true
        //y is centered with textLabel
        timeLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 18).isActive = true
        // Width 100
        timeLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        //height same as textlabel
        timeLabel.heightAnchor.constraint(equalTo: (textLabel?.heightAnchor)!).isActive = true
        
    }
    // change position of the labels
    override func layoutSubviews() {
        super.layoutSubviews()
        // change the frame of textlabel
        textLabel?.frame = CGRect(x: 64, y:textLabel!.frame.origin.y - 2, width: textLabel!.frame.width, height: textLabel!.frame.height) // move the textlabel to the right
        
        detailTextLabel?.frame = CGRect(x: 64, y:detailTextLabel!.frame.origin.y + 2, width: detailTextLabel!.frame.width, height: detailTextLabel!.frame.height) // move the textlabel to the right
        
    }
    

}
