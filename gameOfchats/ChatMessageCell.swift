//
//  ChatMessageCell.swift
//  gameOfchats
//
//  Created by Kev1 on 4/9/17.
//  Copyright © 2017 Kev1. All rights reserved.
//

import UIKit
import AVFoundation

class ChatMessageCell: UICollectionViewCell {
    var message : Message?
    var chatLogController : ChatLogController? // now cell has a ref to chatlogcontroller
    
    
    //Create programatically
    var spinner: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        aiv.translatesAutoresizingMaskIntoConstraints = false
        aiv.hidesWhenStopped = true
        
        return aiv
        
    }()
    
    lazy var playButton : UIButton = {
        let button = UIButton(type:.system)
        //button.setTitle("Play Video", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "Play-26")
        button.setImage(image, for: .normal)
        button.tintColor = .white
        // add functionality
        button.addTarget(self, action: #selector(handlePlay), for: .touchUpInside)
        return button
        
    }()
    var playerLayer: AVPlayerLayer?
    var player: AVPlayer?
    
    func handlePlay(){
       // print("Play video")
        //Create a av player
        
        if let videoUrlString = message?.videoUrl, let url = NSURL(string: videoUrlString) {
            player = AVPlayer(url: url as URL) //weneed the URL from our message
            //add player as a layer
            playerLayer = AVPlayerLayer(player: player)
            playerLayer?.frame = bubbleView.bounds // need this for video to show
            
            bubbleView.layer.addSublayer(playerLayer!) // plays but does not show
            
            player?.play()
            //start the spinner
            spinner.startAnimating()
            
            //hide the play button
            playButton.isHidden = true
            
            //https://www.youtube.com/watch?v=4ISMTG-E3Po&list=PL0dzCUj1L5JEfHqwjBV0XFb9qx9cGXwkq&index=21
            //19:06
            
            print("Attempting to play video......???")
            
        }
        
         }
    
    //RESET THE CELL
    override func prepareForReuse() {
        super.prepareForReuse()
        playerLayer?.removeFromSuperlayer()
        player?.pause()
        spinner.stopAnimating()
        
    }
    
    
    
    let textView : UITextView = {
        let tv = UITextView()
        tv.text = "SOME TEXT FOR NOW"
        tv.font = UIFont.systemFont(ofSize: 16)
        tv.translatesAutoresizingMaskIntoConstraints = false
        //set the text view background color to clear
        tv.backgroundColor = UIColor.clear
        tv.textColor = UIColor.white
        tv.isEditable = false
        //tv.dataDetectorTypes = UIDataDetectorTypes.link
        //tv.backgroundColor = UIColor.yellow
        return tv
        
    }()
    
    //BUBBLE COLORS
    static let blueBubbleColor = UIColor(r: 0, g: 137, b: 249) // class property
    static let grayBubbleColor = UIColor(r: 240, g: 240, b: 240)
    //BLUE BUBBLES
    var bubbleViewWidthAnchor : NSLayoutConstraint?
    var bubbleViewRightAnchor : NSLayoutConstraint? // to stick the profile image view
    var bubbleViewLeftAnchor : NSLayoutConstraint?
    
    
    let bubbleView : UIView = {
        //This will be the background view for the text view
        let view = UIView()
        view.backgroundColor = blueBubbleColor
        view.translatesAutoresizingMaskIntoConstraints = false
        // round the corner
        view.layer.cornerRadius = 16 //needed
        view.layer.masksToBounds = true //needed
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.black.cgColor

        
        return view
        
    }()
    
    //INTRODUCING THE IMAGE ICON
    let profileImageView : UIImageView = {
        let imageView = UIImageView()
        //imageView.image = UIImage(named: "compass")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 16
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.black.cgColor

        
        imageView.contentMode = .scaleAspectFill //makes sure that the aspect ratio is maintained whenever we render the image
        
        return imageView
    }()
    
    lazy var messageImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 16
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleZoomTap)))
       // imageView.backgroundColor = UIColor.brown
        
        return imageView
    }()
    
    func handleZoomTap(tapGesture: UITapGestureRecognizer){
       // print("handling zoom tap")
        //PRO TIP - DO NOT PERFORM A LOT OF CUSTOM LOGIC INSIDE OF A VIEW CLASS - LIKE THIS C ELL CLASS.
        //OURS WILL BE DONE IN CHATLOGCONTROLLER...we will delegate the zooming logic to the chatcontroller class
        //1: get reference to chatlogcontroller
        //get the imageview I tapped on
        
        if message?.videoUrl != nil {
            return //leave this function
        }
        
        if let imageView = tapGesture.view as? UIImageView {
            self.chatLogController?.performZoomInForStartingImageView(startingImageView: imageView)
   
            
        }
        
        
    }
    // to mput this textview in we need to override some methods
    override init(frame: CGRect) {
        super.init(frame: frame)
        // add the bubble view
        addSubview(bubbleView) //text
        addSubview(textView)
        addSubview(profileImageView)
        
        bubbleView.addSubview(messageImageView) //image
        //x, y, width, height
        messageImageView.leftAnchor.constraint(equalTo: bubbleView.leftAnchor).isActive = true
        //y
        messageImageView.topAnchor.constraint(equalTo: bubbleView.topAnchor).isActive = true
        //width
        messageImageView.widthAnchor.constraint(equalTo: bubbleView.widthAnchor).isActive = true
        //height
        messageImageView.heightAnchor.constraint(equalTo: bubbleView.heightAnchor).isActive = true
        
        
        //add the play button after the () on top of the messageImageView in the bubble view
        bubbleView.addSubview(playButton)
        //x, y, width, height
        //Center X
        playButton.centerXAnchor.constraint(equalTo: bubbleView.centerXAnchor).isActive = true
        //center Y
        playButton.centerYAnchor.constraint(equalTo: bubbleView.centerYAnchor).isActive = true
        //width
        playButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        //height
        playButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        
        //put the spinner on top of the play button
        bubbleView.addSubview(spinner)
        
        //x, y, width, height
        //Center X
        spinner.centerXAnchor.constraint(equalTo: bubbleView.centerXAnchor).isActive = true
        //center Y
        spinner.centerYAnchor.constraint(equalTo: bubbleView.centerYAnchor).isActive = true
        //width
        spinner.widthAnchor.constraint(equalToConstant: 50).isActive = true
        //height
        spinner.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        //
        
        //x, y, width, height
        //x left side of cell
        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        //y bottom of the cell
        profileImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        //width
        profileImageView.widthAnchor.constraint(equalToConstant: 32).isActive = true
        //height
        profileImageView.heightAnchor.constraint(equalToConstant: 32).isActive = true
        
        
        
        
        
        
        
        
        //ios 10 constraints
        //x, y, width, height
        //x pin to the right
        
        bubbleViewRightAnchor = bubbleView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8)
        bubbleViewRightAnchor?.isActive = true
        // left
        bubbleViewLeftAnchor = bubbleView.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 8)
        bubbleViewLeftAnchor?.isActive = false
        
        //y pin top top
        bubbleView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        //width = 200
        bubbleViewWidthAnchor = bubbleView.widthAnchor.constraint(equalToConstant: 200)
        bubbleViewWidthAnchor?.isActive = true
        //height of cell
        bubbleView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true

        
        
        
        //backgroundColor = UIColor.red
        
        //ios 10 constraints
        //x, y, width, height
        //x pin to the right
       // textView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        textView.leftAnchor.constraint(equalTo: bubbleView.leftAnchor, constant: 8).isActive = true // spacing
        //y pin top top
        textView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        //width = 200
        //textView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        //height of cell
        
        textView.rightAnchor.constraint(equalTo: bubbleView.rightAnchor).isActive = true // this will give me the width
        textView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
        //////
        //We want to add the bubble view in the entire cell
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
