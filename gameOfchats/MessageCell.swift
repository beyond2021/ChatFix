//
//  MessageCell.swift
//  gameOfchats
//
//  Created by Kev1 on 5/9/17.
//  Copyright © 2017 Kev1. All rights reserved.
//

import UIKit
import Firebase

class MessageCell: UICollectionViewCell {
    
    var isVisited : Bool?
    
    var chatCell : ChatCell?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //self.isVisited = false
        //newMessageView.backgroundColor = UIColor.rgb(red: 51, green: 2, blue: 129)
        //UIColor.rgb(red: 53, green: 81, blue: 140)
        newMessageView.backgroundColor = UIColor.rgb(red: 53, green: 81, blue: 140)
        
        self.layer.borderColor = UIColor.rgb(red: 51, green: 2, blue: 129).cgColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 8
        self.clipsToBounds = false
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.layer.shadowOpacity = 1
        layer.shadowRadius = 2.0
        layer.masksToBounds = false
        
        setupViews()
    }
    
    func setupViews() {
        backgroundColor = UIColor.rgb(red: 200, green: 201, blue: 210)
        //backgroundColor = UIColor(red: 89/255, green: 89/255, blue: 94/255, alpha: 0.3)
        
        addSubview(proileImageView)
        addSubview(textLabel)
        addSubview(detailTextLabel)
        addSubview(timeLabel)
        addSubview(separatorView)
        addSubview(newMessageView)
        setUpProfileImageView()
//        let swipe = UISwipeGestureRecognizer()
//        swipe.direction = .left
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(deleteItem))
        //swipeLeft.direction = .left

        
        addGestureRecognizer(swipeLeft)
        
    }
    
    func deleteItem(){
      // messagesController?.swipeLeft()
        chatCell?.swipeLeft()
    }
    
    
    let textLabel : UILabel = {
        let label = UILabel()
       // label.textColor = UIColor.rgb(red: 200, green: 201, blue: 210)
       // label.font = UIFont.boldSystemFont(ofSize: 20)
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .darkGray
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "textLabel textLabel"
        
        return label
    }()
    
    //var newMessageViewBackgroundColor : UIColor?
    let detailTextLabel : UILabel = {
        let label = UILabel()
        //label.textColor = .white
        //label.textColor = UIColor.rgb(red: 200, green: 201, blue: 210)
        //label.textColor = .darkGray
        //label.font = UIFont.boldSystemFont(ofSize: 16)
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "detailTextLabel"
        return label
    }()
    
    lazy var newMessageView : UIView = {
        //let frame = CGR
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        //view.backgroundColor = UIColor.rgb(red: 53, green: 81, blue: 140)
        //view.backgroundColor = .blue
        
        view.layer.cornerRadius = 8 // 24 comes from half of the constraint
        view.layer.masksToBounds = true
        
        
        return view
    }()
    
    let separatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.rgb(red: 89, green: 89, blue: 94)
        return view
        
    }()
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //
    
    var message : Message? {
        
        //came from cellForRow in MessagesController
        didSet{
            
            setupNameAndAvatar()
            
            if ((message?.videoUrl) != nil) {
               detailTextLabel.text = "Video>>🎞" //"🎞"
            } else if ((message?.imageUrl) != nil){
                detailTextLabel.text = "IPhoto>>📸"//"📸"
                
            } else if ((message?.text) != nil) {
                detailTextLabel.text = message?.text
                
            } else {
                detailTextLabel.text = "??"
                
            }
            
            
            // textLabel?.text = message.toId //Put the name instead og the toId
           // detailTextLabel.text = message?.text
            
            //coverting timestamp to date
            if let seconds = message?.timeStamp?.doubleValue {
                print(seconds)
                //                let ds = Date()
                //               let dss =  ds.timeAgoString
                
                
                //let timeStampDate = NSDate(timeIntervalSince1970: seconds)
                let timeStampDate = Date(timeIntervalSince1970: seconds)
                
                
                let dss =  timeStampDate.timeAgoString
                // formatting the date
                //print(dss)
                
                //                let dateFormatter = DateFormatter()
                //                dateFormatter.dateFormat = "hh:mm:ss a" // google the format
                //             timeLabel.text = dateFormatter.string(from: timeStampDate as Date)
                
                timeLabel.text = dss
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
                    self.textLabel.text = (dictionary["name"] as? String)?.uppercased()
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
    
    var messagesController : MessagesController?    
    //Create an imageView
    let proileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Contacts-51")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        //Make it round by modifing the corner erasius
        imageView.layer.cornerRadius = 24 // 24 comes from half of the constraint
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.white.cgColor
        //UIColor(white: 0.9, alpha: 1)
        imageView.layer.borderColor = UIColor.rgb(red: 200, green: 201, blue: 210).cgColor
        
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    //MARK:- Grouping messages according to time stamp
    
    let timeLabel : UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .darkGray
        
        label.text = "HH:MM:SS"
        label.font = UIFont.systemFont(ofSize: 16)
       // label.textColor = UIColor.rgb(red: 200, green: 201, blue: 210)
        return label
        
    }()
    
    /*
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        self.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        
        //
        textLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        detailTextLabel?.textColor = .gray
        detailTextLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        //Add the imageView as a SubView
        addSubview(proileImageView)
        addSubview(timeLabel)
        setUpProfileImageView()
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
 */
    
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
        
        //
        textLabel.leftAnchor.constraint(equalTo: proileImageView.rightAnchor, constant: 8).isActive = true
        //y
        textLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -136).isActive = true
        //width
        textLabel.topAnchor.constraint(equalTo: self.topAnchor, constant:8) .isActive = true
        //Height
        textLabel.heightAnchor.constraint(equalToConstant: 25) .isActive = true
        
        ///
        /////
        // x, y, width and height
        timeLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -28) .isActive = true
        //y is centered with textLabel
        timeLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 8).isActive = true
        // Width 100
        timeLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        //height same as textlabel
        timeLabel.heightAnchor.constraint(equalTo: (textLabel.heightAnchor)).isActive = true
        // timeLabel.heightAnchor.constraint(equalTo: self.heightAnchor, constant:-8).isActive = true

        
       
        separatorView.leftAnchor.constraint(equalTo: proileImageView.rightAnchor, constant: 8) .isActive = true
        //y is centered with textLabel
        separatorView.topAnchor.constraint(equalTo: textLabel.bottomAnchor, constant: 0).isActive = true
        // Width 100
        separatorView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20).isActive = true
        //height same as textlabel
       separatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
      
        
        
        
        /////
        
        detailTextLabel.leftAnchor.constraint(equalTo: proileImageView.rightAnchor, constant: 8).isActive = true
        //y
        detailTextLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -136).isActive = true
        //width
        detailTextLabel.topAnchor.constraint(equalTo: textLabel.bottomAnchor, constant:1) .isActive = true
        //Height
        detailTextLabel.heightAnchor.constraint(equalToConstant: 30) .isActive = true
        
        
        
        
        
        
        
        //
        
        newMessageView.centerXAnchor.constraint(equalTo: timeLabel.centerXAnchor).isActive = true
        //y
        newMessageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20).isActive = true
        //width
        newMessageView.widthAnchor.constraint(equalToConstant: 16) .isActive = true
        //Height
        newMessageView.heightAnchor.constraint(equalToConstant: 16) .isActive = true

        
        
        
    }
    
   
    // change position of the labels
    override func layoutSubviews() {
        super.layoutSubviews()
        
        /*
        // change the frame of textlabel
        textLabel.frame = CGRect(x: 64, y:textLabel.frame.origin.y - 2, width: textLabel.frame.width, height: textLabel.frame.height) // move the textlabel to the right
        
        detailTextLabel.frame = CGRect(x: 64, y:detailTextLabel.frame.origin.y + 2, width: detailTextLabel.frame.width, height: detailTextLabel.frame.height) // move the textlabel to the right
 */
        
    }
 
    

    

    
    
}
