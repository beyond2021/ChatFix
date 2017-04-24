//
//  LoginController+handlers.swift
//  gameOfchats
//
//  Created by Kev1 on 4/4/17.
//  Copyright © 2017 Kev1. All rights reserved.
//

import UIKit
import Firebase

// We will put our handler functions in this extension

extension LoginController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    // ProfileImageView handler
    func handleSelectProfileImageView() {
        // print(123)
        //lets bring up our image picker
        let picker = UIImagePickerController() // get a ref to picker controller
        present(picker, animated: true, completion: nil) // present the picker
        
        // 2 things we can do with this picker. we can cancel or pick a photo we have to add UIImagePickerControllerDelegate
        picker.delegate = self
        //editing phase of the picker
        picker.allowsEditing = true // adds a crop and zoom functionality
        
    }
    //Handle Pick
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
     //   print(info)
        //lets get the edited image
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
            profileImageView.image = selectedImage // the image is now in the profile
        }
        
                // get rid of the picker
        dismiss(animated: true, completion: nil)
        
    }
    
    //Cancel
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        //print("Canceled Picker")
        //dismiss
        dismiss(animated: true, completion: nil)
    }
    
    //
    
    //MARK: - Handle Registering With Firebase
    func handleRegister() {
        // Test
        print(123)
        // !: Call the authentication function
        
        // Use guard statements for forms and form validations. this check is made because textfields are optional and people can put anything in them.
        guard  let email = emailTextField.text, let password = passwordTextField.text, let name = nameTextField.text else {
            print("Form is not valid")
            return
        }
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user : FIRUser?, error) in
            
            if error != nil {
                print(error ?? "There was an error Mr. Keevin")
                // if there is an error print it and jump out
                return
            }
            
            // verify userID
            guard let uid = user?.uid else {
                return
            }
            
            //create a unique id for profile image
            let imageName = NSUUID().uuidString // timestamp
            //HERE WE WANT TO UPLOAD A FILE TO THE DATABASE// PROFILE IMAGE
            let storageRef = FIRStorage.storage().reference().child("profile_images").child("\(imageName).jpg") // get ref to the storage
            // compress the image because they r taking too long to load
            if let uploadData = UIImageJPEGRepresentation(self.profileImageView.image!, 0.1) {
            
            //if let uploadData = UIImagePNGRepresentation(self.profileImageView.image!) {
                // upload
                storageRef.put(uploadData, metadata: nil, completion: { (metadata, error) in
                    if error != nil {
                        print(error ?? "There is an upload Profile image error")
                        return
                    }
                    
                    //SUCCESS
                    if let profileImageUrl =    metadata?.downloadURL()?.absoluteString {
                       let values = ["name": name, "email": email, "profileImageUrl" : profileImageUrl]
                        
                        self.registerUserIntoDatabaseWithUid(uid: uid, values: values as [String : AnyObject])
                        //print(metadata ?? "SUCCESS")

                        
                    }
                    
                                    })
            }
         
        })
        
    }
    
    private func registerUserIntoDatabaseWithUid(uid: String, values:[String : AnyObject]){
        // If no errors we have success
        //SUCCESSFULLY AUTHENTICATED USER
        // we need to save the user here, so that they persist. so later we can retrieve them
        //let reference = FIRDatabase.database().reference(fromURL: "https://peephole-6f487.firebaseio.com/")////let reference whats in the googleSearch PList instead
        let reference = FIRDatabase.database().reference() //Using the Google PList instaed
        // lets define so values to save in a dictionary
        // lets use child reference users on FireBast
        let usersReference = reference.child("users").child(uid) // saving the unique id in the users folder.
        // now we have users separated by their userID
//
        //reference.updateChildValues(values) // here we store the values dictionary
        // or we can do the one with completion block
        usersReference.updateChildValues(values, withCompletionBlock: { (err, reference) in
            if err != nil {
                print(err ?? "This person was not saved") // print error and jump out
                return
            }
            //SUCCESS
            print("Saved user successfully into firebase database.")
            // here we want to dissmiss theview controller and get us back to our main screen
            
            // update nav bar
          //  self.messagesController?.fetchUserAndSetUpNavBarTitle() // 1 less firebase call
           // self.navigationController?.navigationItem.title = values["values"] as? String
            
            let user = User()
            //THIS SETTER POTENTIALLY CRASHER IF KEYS DONT MATCH
            user.setValuesForKeys(values)
            self.messagesController?.setUpNavBarWithUser(user: user)
            
            self.dismiss(animated: true, completion: nil)
            
            
        })
        
    }
    
    
}
