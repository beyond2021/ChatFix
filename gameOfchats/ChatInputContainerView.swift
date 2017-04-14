//
//  ChatInputContainerView.swift
//  gameOfchats
//
//  Created by Kev1 on 4/14/17.
//  Copyright © 2017 Kev1. All rights reserved.
//

import UIKit
import Firebase //
import MobileCoreServices //images
import AVFoundation


class ChatInputContainerView: UIView, UITextFieldDelegate {
    var chatLogController : ChatLogController? {
        didSet {
            sendButton.addTarget(chatLogController, action: #selector(ChatLogController.handleSend), for: .touchUpInside)
            uploadImageView.addGestureRecognizer(UITapGestureRecognizer(target: chatLogController, action: #selector(ChatLogController.handleUploadTap)))
            
        }
    }//SET UP WORK FOR ChatLogController?
    
    //SET UP WORK FOR THIS FILE
    let sendButton = UIButton(type: .system) // gives u button flas when pressed
    let uploadImageView : UIImageView = {
        let uiv  = UIImageView()
        uiv.isUserInteractionEnabled = true
        uiv.image = UIImage(named: "Picture-50-2")
        uiv.translatesAutoresizingMaskIntoConstraints = false
      return uiv
    }()
    
    //SET UP WORK FOR THIS FILE
    lazy var inputTextField : UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter Message"
        textField.translatesAutoresizingMaskIntoConstraints = false
        //TEXT FIELD ENTER KEY
        textField.delegate = self
        return textField
    }()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    backgroundColor = .white
     
    addSubview(uploadImageView)
    
    //x,y,width,height
    uploadImageView.leftAnchor.constraint(equalTo: self.leftAnchor) .isActive = true
    //y center of container
    uploadImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor) .isActive = true
    //width 80
    uploadImageView.widthAnchor.constraint(equalToConstant: 44).isActive = true
    //height
    uploadImageView.heightAnchor.constraint(equalToConstant: 44).isActive = true
    
    
    
    // Add a textfield to the containerView
    let textField = UITextField()
    textField.placeholder = "ENTER SOME TEXT"
    //containerView.addSubview(textField)
    textField.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: 50)
    
    
    // send Button
    //let sendButton = UIButton(type: .system) // gives u button flas when pressed
    sendButton.setTitle("Send", for: .normal)
    sendButton.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(sendButton)
    
    // Send Button Constraints
    //x,y,width,height
    sendButton.rightAnchor.constraint(equalTo: rightAnchor) .isActive = true
    //y center of container
    sendButton.centerYAnchor.constraint(equalTo: centerYAnchor) .isActive = true
    //width 80
    sendButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
    //height
    sendButton.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
    
    
    // Input textr field
    
    addSubview(self.inputTextField)
    //Set up textfield constraints
    //x, y, width, height
    
    self.inputTextField.leftAnchor.constraint(equalTo: uploadImageView.rightAnchor, constant: 8).isActive = true
    //y center
    self.inputTextField.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    // width
    // inputTextField.widthAnchor.constraint(equalToConstant: 100) .isActive = true
    //        inputTextField.rightAnchor.constraint(equalTo: sendButton.leftAnchor, constant: 8).isActive = true
    
    self.inputTextField.rightAnchor.constraint(equalTo: sendButton.leftAnchor).isActive = true        // Height
    self.inputTextField.heightAnchor.constraint(equalTo: heightAnchor) .isActive = true
    
    //inputTextField is green because xcode knows its a class property
    
    //SEPARATOR LINE ON TOP OF THE INPUT CONTAINER
    
    let separatorLineView = UIView()
    separatorLineView.backgroundColor = UIColor(r: 220, g: 220, b: 220)
    separatorLineView.translatesAutoresizingMaskIntoConstraints = false
    addSubview(separatorLineView)
    
    //placement at the very top of input container
    //x,y,width, height
    //x position
    separatorLineView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true        // y position
    separatorLineView.centerYAnchor.constraint(equalTo: topAnchor).isActive = true        //width
    separatorLineView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true        //height
    separatorLineView.heightAnchor.constraint(equalToConstant: 1).isActive = true

    
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
       // handleSend()
        chatLogController?.handleSend()
        return true
    }

    
    
}

