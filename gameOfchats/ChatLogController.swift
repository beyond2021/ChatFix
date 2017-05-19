//
//  ChatLogController.swift
//  gameOfchats
//
//  Created by Kev1 on 4/7/17.
//  Copyright © 2017 Kev1. All rights reserved.
//  https://firebase.googleblog.com/2015/10/client-side-fan-out-for-data-consistency_73.html
//

import UIKit
import Firebase //
import MobileCoreServices //images
import AVFoundation

class ChatLogController : UICollectionViewController, UITextFieldDelegate, UICollectionViewDelegateFlowLayout, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    let cellId = "cellId"
    var user: User? {
        didSet{
            navigationItem.title = user?.name
            
            //fetch the messages by some kind of observation
            observerMessages()
        }
    }
    
    var messages = [Message]()
    
    func observerMessages(){
        //get the current user uid
        guard let uid = FIRAuth.auth()?.currentUser?.uid, let toId = user?.id else {
            return
        }
        
        // which message node do we want to observe. user-message and all the logged in user messages
        let userMessageRef = FIRDatabase.database().reference().child("user-messages").child(uid).child(toId)
        
        userMessageRef.observe(.childAdded, with: { (snapshot) in
            let messageId = snapshot.key // get the message id from our snapshot key = e.g Snap (-KhE4-w9nhOj30nNdXTj) 1
            let messageseRef = FIRDatabase.database().reference().child("messages").child(messageId)
            // now observe a single event type
            messageseRef.observeSingleEvent(of: .value, with: { (snapshot) in
                //let get this and put it in an array
                // lets get this dictionay from a guard statement
                guard let dictionary = snapshot.value as? [String:AnyObject] else {
                    return
                }
                //now dic is available
                //                let message = Message(dictionary: dictionary)
                // message.setValuesForKeys(dictionary) //THIS WILL CRASH IF KEYS DONT MATCH
                
                //  print("We fetched a message from Firebase, and we need to dec ide whether or not to filter it out:", message.text ?? "No message fetched")
                // if message.chatPartnerId() == self.user?.id {
                //put these into the messages array here for the collecvtionview
                self.messages.append(Message(dictionary: dictionary))
                //
                
                DispatchQueue.main.async(execute: {
                    self.collectionView?.reloadData()
                    //scroll to the last index
                    let indexpath = IndexPath(item: self.messages.count - 1, section: 0)
                    self.collectionView?.scrollToItem(at: indexpath, at: .bottom, animated: true)
                })
                
                
                // }
                
            }, withCancel: nil)
            
        }, withCancel: nil)
        
    }
    
    // var titleLabel : UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isTranslucent = false
        
        //self.blackBackgroundView?.backgroundColor = UIColor.rgb(red: 200, green: 201, blue: 210)
//        self.navigationController!.navigationBar.barTintColor = UIColor(r: 61, g: 91, b: 151)
        
        
       navigationController?.navigationBar.tintColor = .white
        //UIColor.rgb(red: 200, green: 201, blue: 210)
//        navigationController?.navigationBar.tintColor = UIColor.rgb(red: 200, green: 201, blue: 210) //Back Button
        
        
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white] //CHANGING THE
//        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.rgb(red: 200, green: 201, blue: 210)] //Title
        //
        navigationController?.hidesBarsOnSwipe = false
        //
//        navigationController?.hidesBarsWhenVerticallyCompact = false
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        // make it draggable
        collectionView?.alwaysBounceVertical = true
        //space ontop AND BOTTOM SPACE of the collectionview
        collectionView?.contentInset  = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0) //MUST CHANGE BOTH
        //  collectionView?.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0) //MUST CHANGE BOTH
        //
        //Set up nav bar
        //navigationItem.title = "Chat Log Controller"
        //collectionView?.backgroundColor = UIColor.white
        collectionView?.backgroundColor = UIColor.rgb(red: 200, green: 201, blue: 210)
        
        //register cell
        collectionView?.register(ChatMessageCell.self, forCellWithReuseIdentifier: cellId)
        
        //
        collectionView?.keyboardDismissMode = .interactive // interact with the keyboard
        
        //KEYBOARD SYMAMTICS
        setupKeyboardObservers()
    }
    
    
    func viewDidAppear() {
        super.viewDidAppear(true)
        navigationController?.hidesBarsOnSwipe = false
    }
    
    
    
    
    lazy var inputContainerView: ChatInputContainerView = {
        let chatInputContainerView = ChatInputContainerView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50)) //refractor1
        //
        chatInputContainerView.chatLogController = self //NOW CHAT INPUT CONTAINERVIEW CAN CALL OUR FUNCTIONS
        
        return chatInputContainerView
        
    }()
    
    func handleUploadTap(){
        
        //Bring up the picker
        let imagePickerController = UIImagePickerController()
        imagePickerController.allowsEditing = true
        imagePickerController.delegate = self
        imagePickerController.mediaTypes = [kUTTypeImage as String , kUTTypeMovie as String]
        
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        //Video
        if let videoUrl = info[UIImagePickerControllerMediaURL] as? URL{
            
            handleVideoSelectedForUrl(url: videoUrl)
            //print("Here is the video file url:", videoUrl)
            //we want to upload this file to firebase storage -
            //return
        } else {
            self.handleImageSelectedForInfo(info: info as AnyObject)
            
            
        }
        
        // get rid of the picker
        dismiss(animated: true, completion: nil)
        
    }
    //MARK: - VIDEO
    
    private func handleVideoSelectedForUrl(url:URL) {
        let fileName = UUID().uuidString + ".mov"
        let uploadTask = FIRStorage.storage().reference().child("message_movies").child(fileName).putFile(url, metadata: nil, completion: { (metadata, error) in
            // FIRST WE HANDLE THE ERROR
            if error != nil {
                print( "Failed upload of video", error ?? "")
                return
            }
            
            //SUCCESS
            if let videoUrl = metadata?.downloadURL()?.absoluteString {
                //print("Video Storage Url is:", videoUrl)
                //get the first frame of the video
                if   let thumbnailImage = self.thumbnailImageForVideoUrl( fileUrl: url as NSURL) {
                    
                    
                    //
                    self.uploadToFireBaseStorageUsingImage(image: thumbnailImage, completion: { (imageUrl) in
                        let properties = ["imageUrl": imageUrl, "imageWidth": thumbnailImage.size.width, "imageHeight": thumbnailImage.size.height, "videoUrl": videoUrl, ] as [String : Any]
                        
                        self.sendMessageWithProperties(properties: properties as [String : AnyObject])
                        
                        
                    })
                    
                }
            }
        })
        
        uploadTask.observe(.progress) { (snapshot) in
            if let completedUnitCount = snapshot.progress?.completedUnitCount{
                
                self.navigationItem.title = String(completedUnitCount)
            }// print(snapshot.progress?.completedUnitCount ?? 0)//upload progress
        }
        uploadTask.observe(.success) { (snapshot) in
            self.navigationItem.title = self.user?.name
            //
            //self.titleLabel?.text = self.user?.name
            
        }
    }
    //VIDEO THUMBNAIL
    private func thumbnailImageForVideoUrl(fileUrl : NSURL) -> UIImage? {
        //Asset Generator
        let asset = AVAsset(url: fileUrl as URL)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        
        do {
            let thumbnailCGImage = try imageGenerator.copyCGImage(at: CMTimeMake(1, 60), actualTime: nil) //gives us the first frame. this also throws(copyCGImage)
            return UIImage(cgImage: thumbnailCGImage) //retur the image
            
        } catch let err {
            print(err)
        }
        return nil
    }
    
    
    //IMAGE
    fileprivate func handleImageSelectedForInfo(info: AnyObject){
        
        var selectedImageFromPicker: UIImage?
        
        
        if let editedImage = info["UIImagePickerControllerEditedImage"]{
            // print((editedImage as AnyObject).size)
            //get the selected image
            selectedImageFromPicker = editedImage as? UIImage
            
            
            
        } else if let originaImage = info["UIImagePickerControllerOriginalImage"] {
            
            // print the original image size
            //  print((originaImage as AnyObject).size)
            // now lets do something with the image we have
            selectedImageFromPicker = originaImage as? UIImage
            
        }
        if let selectedImage = selectedImageFromPicker {
            // now we have access to the selected image
            // profileImageView.image = selectedImage // the image is now in the profile
            uploadToFireBaseStorageUsingImage(image: selectedImage, completion: { (imageUrl) in
                //
                self.sendMessageWithImageUrl(imageUrl: imageUrl, image: selectedImage)
            })
            //uploadToFireBaseStorageUsingImage(image: selectedImage)
        }
        
        
        
    }
    
    
    
    func uploadToFireBaseStorageUsingImage(image: UIImage, completion:@escaping (_ imageUrl:String) -> ()) {
        print("Upload to Firebase!!!")
        
        //    1: GET A REFERENCE T6O FIREBASE STORAGE
        let imageName = NSUUID().uuidString // timestamp Get a unique name for the image
        let ref = FIRStorage.storage().reference().child("message_images").child(imageName)
        
        
        if let uploadImageData = UIImageJPEGRepresentation(image, 0.2){
            ref.put(uploadImageData, metadata: nil, completion: { (metadata, error) in
                if error != nil {
                    print("Failed to upload image", error ?? "")
                    return
                }
                //SUCCESS
                // print(metadata?.downloadURL()?.absoluteString ?? "")  ----- image string
                
                if let imageUrl = metadata?.downloadURL()?.absoluteString {
                    //now that we have the image we want to upload it to Firebase
                    completion(imageUrl)
                    
                    //  self.sendMessageWithImageUrl(imageUrl: imageUrl, image: image)
                    
                    
                    
                }
                
            })
            
        }
        
        
    }
    
    
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    //KEYBOARD USING INPUT ACCESSAR VIEW
    // OVERRIDE BECAUSE ITS A PROPERTY OF UIVIEWCONTROLLER BY SPECIFYING A GET
    override var inputAccessoryView: UIView? {
        get {
            
            return inputContainerView
            
        }
    }
    override var canBecomeFirstResponder: Bool { return true
    }
    
    ///
    
    func setupKeyboardObservers(){
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardDidShow), name:.UIKeyboardDidShow, object: nil)
        
        
    }
    
    func handleKeyboardDidShow(){
        //we want to scroll to the last index of the collectionview
        
        if messages.count > 0 {
            let indexpath = IndexPath(item: messages.count - 1, section: 0)// last
            collectionView?.scrollToItem(at: indexpath, at: .top, animated: true)
            
            
        }
        
    }
    
    
    //This method is called everytime we show the keyboard
    func handleKeyboardWillShow(notification: Notification){
        let keyboardFrame = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as AnyObject).cgRectValue
        
  //      print(notification.userInfo ?? "")// print out the keyboard info, size etc.
        //print(keyboardFrame?.height ?? "") // we get the height of the keyboard of 271.0
        let keyboardDuration = (notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as AnyObject).doubleValue
        //Move the input area up 271.0 some how in setupComponents
        containerViewBottomAnchor?.constant = -(keyboardFrame?.height)!
        UIView.animate(withDuration: keyboardDuration!) {
            self.view.layoutIfNeeded()// call this mehod after u modify constraint
        }
        
        
    }
    //IMPORTANT FOR POTENTIAL MEMORY LEAK
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidDisappear(true)
        //NotificationCenter.default.removeObserver(self)//OR SELF WILL BE KEPT IN MEMOY FOREVER MEANING EVERYTIME WE LOAD A CHATCONTROLLER ONE MORE WILL BE ADDED
    }
    deinit {
        NotificationCenter.default.removeObserver(self)//OR SELF WILL BE KEPT IN MEMOY FOREVER MEANING EVERYTIME WE LOAD A CHATCONTROLLER ONE MORE WILL BE ADDED
    }
    
    
    //
    func handleKeyboardWillHide(notification: Notification){
        containerViewBottomAnchor?.constant = 0 // bring to input view back
        let keyboardDuration = (notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as AnyObject).doubleValue
        UIView.animate(withDuration: keyboardDuration!) {
            self.view.layoutIfNeeded() // call this mehod after u modify constraint
        }
        
    }
    //MARK: - CollectionView LifeCycle
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //dequeing
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ChatMessageCell
        
        //delegation from the chatcell
        cell.chatLogController = self  //working backwards. we then give cell this property
        
        
        // cell.backgroundColor = UIColor.blue
        let message = messages[indexPath.item]
        
        //
        cell.message = message //create a message property on the cell class
        
        
        cell.textView.text = message.text
        // modifiying the width of the cell somehow?
        
        
        setupCell(cell: cell, message: message)
        // estimatedStringForText(text: message.text!)
        
        
        
        if let text = message.text{
            //This is a text message
            cell.bubbleViewWidthAnchor?.constant =  estimatedStringForText(text: text).width + 32
            cell.textView.isHidden = false
            
        } else if message.imageUrl != nil {
            //this is a chat image
            //will fall in here if its an image
            //image size
            cell.bubbleViewWidthAnchor?.constant = 200 //set a constawidth for the image
            cell.textView.isHidden = true
        }
        
        cell.playButton.isHidden = message.videoUrl == nil // if the video url is nil we hide the button
        
        return cell
    }
    
    //SETUP CELL
    func setupCell(cell:ChatMessageCell, message: Message){
        //loading the correct image
        
        if let profileImageUrl = self.user?.profileImageUrl{
            cell.profileImageView.loadImageUsingCacheWithUrlString(urlString: profileImageUrl)
            
        }// get the senders image
        
        
        
        //CHECK WHETHER THIS MESSAGE SHOULD BE A BLUE OR GRAY BUBBLE
        if message.fromId == FIRAuth.auth()?.currentUser?.uid {
            //means from the logged in user = outgoiing blue
            cell.bubbleView.backgroundColor = ChatMessageCell.blueBubbleColor //class property
            cell.textView.textColor = UIColor.white
            cell.profileImageView.isHidden = true
            cell.bubbleViewRightAnchor?.isActive = true
            cell.bubbleViewLeftAnchor?.isActive = false
            
            
        } else {
            //incoming gray messages
            cell.bubbleView.backgroundColor = ChatMessageCell.grayBubbleColor
            // change the textcolor to black
            cell.profileImageView.isHidden = false
            cell.textView.textColor = UIColor.black
            cell.bubbleViewRightAnchor?.isActive = false
            cell.bubbleViewLeftAnchor?.isActive = true
        }
        
        //adding the message image
        if let messageImageUrl = message.imageUrl {
            cell.messageImageView.loadImageUsingCacheWithUrlString(urlString: messageImageUrl)
            cell.messageImageView.isHidden = false
            //cell.bubbleView.isHidden = true
            cell.bubbleView.backgroundColor = UIColor.clear
            
        } else {
            cell.messageImageView.isHidden = true
            // cell.bubbleView.isHidden = false
        }
        
    }
    
    
    
    //SIZE TO LAYOUT THE CELLS. ADJUSTIBLE CELL HEIGHT
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //return CGSize(width: view.frame.width, height: 80)
        //make cells adjustable to text height
        var height : CGFloat = 80
        
        let message = messages[indexPath.item]
        // get estimated height
        if let text = message.text {
            height = estimatedStringForText(text: text).height + 20 //20 pushes the text up a bit
        } else if let imageWidth = message.imageWidth?.floatValue, let imageHeight = message.imageHeight?.floatValue {
            // height = 120 // image cell will all have the height of 120
            //Math h1 / w1 = h2 / w2
            //solve for h1 = h2 / w2 * w1
            height = CGFloat(imageHeight / imageWidth * 200)
        }
        
        let width = UIScreen.main.bounds.width //solves the rotation issue
        return CGSize(width: width, height: height)
    }
    
    // ADJUSTIBLE CELL HEIGHT
    private func estimatedStringForText(text: String) -> CGRect {
        let size = CGSize(width: 200, height: 1000)// 200 from the width anchor above and 1000 for anything very large
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin) // google it
        
        
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 16)], context: nil) //ObjectiveC NSString Method
        
        
    }
    var containerViewBottomAnchor: NSLayoutConstraint?
    
    //MARK: - Send message to users
    //Chatinput at the bottom, we will put a container
    //MARK:- Start sending messages into firebase
    
    
    func handleSend(){
        let properties = ["text": inputContainerView.inputTextField.text ?? ""] as [String : Any] //name in chat
        sendMessageWithProperties(properties: properties as [String : AnyObject])
        
        
    }
    
    func sendMessageWithImageUrl(imageUrl: String, image: UIImage){
        
        let properties = [ "imageUrl": imageUrl, "imageWidth": image.size.width, "imageHeight": image.size.height] as [String : Any]
        
        sendMessageWithProperties(properties: properties as [String : AnyObject])
    }
    
    private func sendMessageWithProperties(properties: [String:AnyObject]) {
        let reference = FIRDatabase.database().reference().child("messages")
        
        let childRef = reference.childByAutoId()
        // is it smart to include the name in the message node
        //let values = ["test": inputTextField.text] // no name in chat
        
        //A MESSAGE MUST HAVE SENDER AND RECIPIANT(current User)
        let toId = user!.id! //RECIPIANT set in  NewMessageController
        let fromId = FIRAuth.auth()!.currentUser!.uid //SENDER // get the current user from the firebase
        
        //TIMESTAMP WHEN MESSAGE IS SENT OUT
        //let timeStamp = Int(NSDate().timeIntervalSince1970)
        let timeStamp = NSNumber(value: Int(NSDate().timeIntervalSince1970))
        
        var values = [ "toId": toId, "fromId": fromId, "timeStamp": timeStamp] as [String : Any] //name in chat
        //we want to append properties onto values somehow???se
        //key = $0 value =$1
        properties.forEach({values[$0] = $1}) //AMENDING DICTIONARYS
        
        //     let childReference = reference.childByAutoId()
        
        //     childReference.updateChildValues(values as Any as! [AnyHashable : Any])
        //SOLVING THE FAN-OUT ISSUE https://www.youtube.com/watch?v=K1AgGLoT54M&list=PL0dzCUj1L5JEfHqwjBV0XFb9qx9cGXwkq&index=11
        
        childRef.updateChildValues(values) { (error, childReference) in
            // check error
            if error != nil {
                print(error ?? "Catastrophic Error Keev")
                return
            }
            //clear the input text
            self.inputContainerView.inputTextField.text = nil
            
            
            
            //create a new node called userreferencesref
            
            let userMessagesRef = FIRDatabase.database().reference().child("user-messages").child(fromId).child(toId)
            //save some data in child messages
            let messageId = childRef.key
            userMessagesRef.updateChildValues([messageId:1]) //save
            // Recipient
            let recipientMessageRef = FIRDatabase.database().reference().child("user-messages").child(toId).child(fromId)
            // save the recipient
            recipientMessageRef.updateChildValues([messageId:1]) //save
        }
        
    }
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        handleSend()
        return true
    }
    
    //ROTATION
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        //this method id call anythime the device rotates
        collectionView?.collectionViewLayout.invalidateLayout() //
    }
    //MARK: - My custom zooming logic
    var startingFrame : CGRect?
    var blackBackgroundView : UIView?
    var startingImageView : UIImageView?
    
    func performZoomInForStartingImageView(startingImageView: UIImageView) {
        
        self.startingImageView = startingImageView
        self.startingImageView?.isHidden = true
        // print("Performing zoom in logic in controller")
        //1: put red view on top of imageView
        startingFrame = startingImageView.superview?.convert(startingImageView.frame, to: nil)
        // print(startingFrame ?? 0)
        // Optional((206.0, 350.666666666667, 200.0, 200.0))
        //lets make the red box
        let zoominImageView = UIImageView(frame: startingFrame!)
        zoominImageView.isUserInteractionEnabled = true
        zoominImageView.backgroundColor = UIColor.red
        //add the image
        zoominImageView.image = startingImageView.image
        //
        //zooming out
        zoominImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleZoomOut)))
        //get the key window
        if let keyWindow = UIApplication.shared.keyWindow {
            //ading a black background to the zoomed image
            blackBackgroundView = UIView(frame: keyWindow.frame)
            blackBackgroundView?.backgroundColor = UIColor.black
            blackBackgroundView?.alpha = 0 //Starts off invisible
            keyWindow.addSubview(blackBackgroundView!)
            keyWindow.addSubview(zoominImageView)
            //Next we want to zoom it into the middle of the page
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                //
                self.blackBackgroundView?.alpha = 1
                //hide the chat inpu container
                self.inputContainerView.alpha = 0
                //Math for the height ----- h2 / w1 = h1 / w1
                //solve for H2------- H2 = h1 / w1 * w2
                let height = self.startingFrame!.height / self.startingFrame!.width * keyWindow.frame.width
                //we need to set the frame inside this block
                //width = entire app width
                zoominImageView.frame = CGRect(x: 0, y: 0, width: keyWindow.frame.width, height: height)
                //center it
                zoominImageView.center = keyWindow.center
            }, completion: nil)
            
            
        }
        
    }
    
    func handleZoomOut(tapGesture: UITapGestureRecognizer){
        print("Zooming Out")
        if let zoomOutImageView = tapGesture.view {
            //corners
            zoomOutImageView.layer.cornerRadius = 16
            zoomOutImageView.clipsToBounds = true
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                
                //
                zoomOutImageView.frame = self.startingFrame!
                self.blackBackgroundView?.alpha = 0
                self.inputContainerView.alpha = 1
            }, completion: { (Bool) in
                // remove it
                zoomOutImageView.removeFromSuperview()
                self.startingImageView?.isHidden = false
                
                
            })
            
        }
        
    }
    
    
}
