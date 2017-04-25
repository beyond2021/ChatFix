//
//  LoginController.swift
//  gameOfchats
//
//  Created by Kev1 on 4/2/17.
//  Copyright © 2017 Kev1. All rights reserved.
//

import UIKit
import Firebase

class LoginController: UIViewController {
    
    var messagesController : MessagesController?
    
    //MARK:- Spinner
    lazy var spinner : UIActivityIndicatorView = {
        let sp = UIActivityIndicatorView()
        sp.color = .white
        sp.translatesAutoresizingMaskIntoConstraints = false
        return sp
    }()

    
    
   //MARK: - MAKING THE INPUT CONTAINER
    
    let inputContainerView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white //
        // this is needed for view to show
        view.translatesAutoresizingMaskIntoConstraints = false // a must to make anchor constraints work.
        // round the corner of the view
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.white.cgColor
        
        return view
  }() // () executes this block to get our view. means give me back the entire block.
    
    //MARK: - MAKING THE REGISTER BUTTON
    // Lazy Var because we need access to self below
    lazy var loginRegisterButton : UIButton = {
        let button = UIButton(type: .system)
        
        //set the button color
        button.backgroundColor = UIColor(r: 80, g: 101, b: 161)
        button.setTitle("Register", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
       // button.addTarget(self, action: #selector(handleRegister), for: .touchUpInside) // self the reason we use lazy var
        button.addTarget(self, action: #selector(handleLoginRegister), for: .touchUpInside) // self the reason we use lazy var
        
        return button
          }()
    
       //MARK: - CREATE THE TEXTFIELDS FOR THE INPUT CONTAINER
    //NAME
    let nameTextField : UITextField = {
        let textField = UITextField()
        textField.placeholder = "Name"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
        
    }()
    
    //MARK: - THE LINE UNDER THE TEXT FIELD
    let nameSeperatorView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
         } ()
    
    //MARK: - Email Text Field
    let emailTextField : UITextField = {
        let textField = UITextField()
        textField.placeholder = "Email"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
        
    }()
    
    //MARK: -  Email Seperator
    let emailSeperatorView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
        
        
    } ()
    
    //MARK: - Password Text Field
    let passwordTextField : UITextField = {
        let textField = UITextField()
        textField.placeholder = "Password"
        textField.isSecureTextEntry = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
        
    }()
   
    
    //MARK: - ProfileImageView Construction
    lazy var profileImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "AdobeStock_44190609")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        // image is squished so lets fix the aspect ratio
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 75
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.white.cgColor
        //
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.white.cgColor
        // lets add a gesture to my imageView
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectProfileImageView)))
        // change default interaction to on for imageView
        imageView.isUserInteractionEnabled = true
        return imageView
        
    }()
    
        
    //MARK: - Segemented Contorl
    lazy var loginRegisterSegmentedController: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Login","Register"])
        sc.tintColor = UIColor.white
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.selectedSegmentIndex = 1
        // add a target to sc handleLoginRegister  handleLoginRegistorChange
        sc.addTarget(self, action: #selector(handleLoginRegistorChange), for: .valueChanged)
        return sc
        
        
    }()
    
    
    //MARK:- pickImageLabel
    let pickImageLabel: UILabel = {
        let label = UILabel()
        label.text = "Please choose a profile pic you Super Star"
        label.textAlignment = .center
        label.textColor = .white
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        
        
      return label
    }()
    
    //MARK: - View life Cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    
    // ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        //First I wanna change the background color before color extension
        //view.backgroundColor = UIColor(red: 61/255, green: 91/255, blue: 151/255, alpha: 1)
        
        // after my extension
        view.backgroundColor = UIColor(r: 61, g: 91, b: 151)
        // add the views
        view.addSubview(inputContainerView)
        view.addSubview(loginRegisterButton)
        view.addSubview(profileImageView)
        view.addSubview(loginRegisterSegmentedController)
        view.addSubview(pickImageLabel)
        view.addSubview(spinner)
        
        
        // set up the views
        setUpInputContainer()
        setUpLoginRegisterButton()
        setUpProfileImageView()
        setUpLoginRegisterControl()
        setupSpinner()
        
        //Setup password and textfield logic
        //setupPasswordTextfieldsAndLoginRegisterButtonLogic()
        
    }
    
    func setupSpinner() {
        //x, y, width, height
        spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: loginRegisterButton.bottomAnchor, constant: 40).isActive = true
        spinner.widthAnchor.constraint(equalToConstant: 250).isActive = true
        spinner.heightAnchor.constraint(equalToConstant: 250).isActive = true
        
    }

    
    
    
    // MARK: - Height Manipulation
    var inputsContainerViewHeightAnchor : NSLayoutConstraint? // hold a reference to the 
    //anchor
    var inputsContainerViewCenterAnchor : NSLayoutConstraint?
    
    // TextField Height anchor
    var nametextFieldHeightAnchor : NSLayoutConstraint? // hold a reference to the anchor
    // email
    var emailTextFieldHeightAnchor : NSLayoutConstraint? //
    //
    var passwordTextFieldHeightAnchor : NSLayoutConstraint?
    
    
    //MARK: - Setup input container
    func setUpInputContainer(){
        // these contraint is only for iOS 9 and later.
        // time to constrain and position my view
        // x, y, width and height constraint we need
        // x is in the middle of the view
        inputContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
          // y is in the middle of the view
        inputContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true        // width the entire width of the scree minus 12 on each side
        inputContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true        // height 150
   //     inputContainerView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        // shrinking the container
        inputsContainerViewHeightAnchor = inputContainerView.heightAnchor.constraint(equalToConstant: 150)
        inputsContainerViewHeightAnchor?.isActive = true
        
        //adding the input textfields
        inputContainerView.addSubview(nameTextField)
        inputContainerView.addSubview(nameSeperatorView)
        inputContainerView.addSubview(emailTextField)
        inputContainerView.addSubview(emailSeperatorView)
        inputContainerView.addSubview(passwordTextField)
        
        
        // x, y, width and height constraint we need
        //x is 12 pixel from left
        nameTextField.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor, constant: 12).isActive = true
        // y is right against the top
        nameTextField.topAnchor.constraint(equalTo: inputContainerView.topAnchor).isActive = true        // the same width as the input container view
        nameTextField.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true        // height
        nametextFieldHeightAnchor = nameTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 1/3)
        nametextFieldHeightAnchor?.isActive = true
        
        //get rid of the name text field by using the height anchor
        
        //Adding separator lines
              // x, y, width and height constraint we need
        // x to the edge of the container
        nameSeperatorView.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor).isActive = true        // y starts at the bottom of the textfield
        nameSeperatorView.topAnchor.constraint(equalTo: nameTextField.bottomAnchor).isActive = true        // width is the total width of the container view
        nameSeperatorView.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        nameSeperatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        ////////////////////////////
        
        emailTextField.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor, constant: 12).isActive = true
        // y is right against the top
        emailTextField.topAnchor.constraint(equalTo: nameSeperatorView.bottomAnchor).isActive = true        // the same width as the input container view
        emailTextField.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true        // height
        // emailTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 1/3).isActive = true
        emailTextFieldHeightAnchor = emailTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 1/3)
        emailTextFieldHeightAnchor?.isActive = true
        
        //
        
        emailSeperatorView.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor).isActive = true        // y starts at the bottom of the textfield
        emailSeperatorView.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true        // width is the total width of the container view
        emailSeperatorView.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        emailSeperatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true

       ////////////////////////////////
        
        
        passwordTextField.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor, constant: 12).isActive = true
        // y is right against the top
        passwordTextField.topAnchor.constraint(equalTo: emailSeperatorView.bottomAnchor).isActive = true        // the same width as the input container view
        passwordTextField.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true        // height
        //passwordTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 1/3).isActive = true
        
        passwordTextFieldHeightAnchor = emailTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 1/3)
        passwordTextFieldHeightAnchor?.isActive = true
        
        //
        
        // x to the edge of the container
        pickImageLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true        // y starts at the bottom of the textfield
        pickImageLabel.bottomAnchor.constraint(equalTo: profileImageView.topAnchor, constant: -20).isActive = true        // width is the total width of the container view
        pickImageLabel.widthAnchor.constraint(equalTo: loginRegisterButton.widthAnchor).isActive = true
        pickImageLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true

        
        
        
    }
    
    
    //MARK: - Setup login register button.
    // When this button is pressed, we want it to ping FireBase
    func setUpLoginRegisterButton() {
        // x, y, width and height constraint we need
        // x is in the middle of the view
        loginRegisterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        // y is at the bottom of the container view. top of button will be at bottom of view.
        loginRegisterButton.topAnchor.constraint(equalTo: inputContainerView.bottomAnchor, constant: 12).isActive = true
        // width as wide as the container view
        loginRegisterButton.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true        // height is 50
        loginRegisterButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
    }
    
    //MARK: - ProfileImage
    func setUpProfileImageView() {
        
        //image is going to be on top of the container
        // x, y, width and height constraint we need
        // x value is the center of the entire view
        profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor) .isActive = true
        // y value on top of the inputcontainer(-12). so lets constain the bottom of the profile image top of container
        profileImageView.bottomAnchor.constraint(equalTo: loginRegisterSegmentedController.topAnchor, constant: -12).isActive = true        //lets make the width 150
        profileImageView.widthAnchor.constraint(equalToConstant: 150).isActive = true        // let make the height 150
        profileImageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
    }
    
    //MARK:- Set up login Register control
    func setUpLoginRegisterControl(){
        // x, y, width and height constraint we need
        // x is in the middle of the view
        loginRegisterSegmentedController.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        // y is -12 pix above input container. -ve makes it above
        loginRegisterSegmentedController.bottomAnchor.constraint(equalTo: inputContainerView.topAnchor, constant: -12).isActive = true
        // width is the same as input container view
       loginRegisterSegmentedController.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        // Height is constant of 150 , mulitiplier: 0.5
        // cutting the width in half
       // loginRegisterSegmentedController.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor, multiplier: 0.5).isActive = true
        loginRegisterSegmentedController.heightAnchor.constraint(equalToConstant: 36).isActive = true
    }
    //
    //hhandle loginREgister.
    func handleLoginRegister(){
                // find out whether to login or reghidter the user.
        // if the toggle is selected as 0
        if loginRegisterSegmentedController.selectedSegmentIndex == 0 {
            handleLogIn()
        } else {
            handleRegister()
        }
        
    }
    
    //Handle login after logout.
    func handleLogIn (){
        // Sign in the user with firebase
        guard  let email = emailTextField.text, let password = passwordTextField.text else {
           // print("Form is not valid")
                       return
        }
        
        loginValidation(email: email, password: password)
        
        /*
        
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
            if error != nil {
                print(error ?? "There is a login error")
                
                
                return // print the error and get out
            }
            // IF THERE IS SUCCESS
            self.messagesController?.fetchUserAndSetUpNavBarTitle() // nav bar title
            self.dismiss(animated: true, completion: nil)
        })
 */
            
    }
    
    
    
       //MARK : - Hndle login register change
    func handleLoginRegistorChange(){
        if loginRegisterSegmentedController.selectedSegmentIndex == 0 {
            nameTextField.isHidden = true
            
        } else {
            nameTextField.isHidden = false
          //  let aState = AppState.RegisterState
            
        }
        
         
        
     //   print(loginRegisterSegmentedController.titleForSegment(at: loginRegisterSegmentedController.selectedSegmentIndex) ?? <#default value#>) // to get the title. SegmetedControl Check.
        let title = loginRegisterSegmentedController.titleForSegment(at: loginRegisterSegmentedController.selectedSegmentIndex)
            
        loginRegisterButton.setTitle(title, for: .normal)
        
        //change height of input container to 100 instead of 150
      //  inputsContainerViewHeightAnchor?.constant = 100 // shrink it
        // toggle it
        inputsContainerViewHeightAnchor?.constant = loginRegisterSegmentedController.selectedSegmentIndex == 0 ? 100 : 150
        // give it 100 if its 0 anf 150 if its 1
        nametextFieldHeightAnchor?.isActive = false
        nametextFieldHeightAnchor = nameTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: loginRegisterSegmentedController.selectedSegmentIndex == 0 ? 0 : 1/3)
        nametextFieldHeightAnchor?.isActive = true
        
        //
        emailTextFieldHeightAnchor?.isActive = false

        emailTextFieldHeightAnchor = emailTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: loginRegisterSegmentedController.selectedSegmentIndex == 0 ? 1/2: 1/3)
        emailTextFieldHeightAnchor?.isActive = true
       
        passwordTextFieldHeightAnchor?.isActive = false
        passwordTextFieldHeightAnchor = passwordTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: loginRegisterSegmentedController.selectedSegmentIndex == 0 ? 1/2: 1/3)
 
        passwordTextFieldHeightAnchor?.isActive = true
 
        
        // Nametextfield title label
        nameTextField.placeholder = loginRegisterSegmentedController.selectedSegmentIndex == 0 ? "" : "Name"
     //  */
    
    }
    
    // Change the stausbar to a white colr.
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //LOGIN VALIDATION
    
    func loginValidation(email:String, password:String) {
        
        
        // Validate the text fields
        if isValidEmail(testStr: email) == false{
            let alertc = UIAlertController(title: "Invalid", message: "Please enter a valid email address", preferredStyle: .alert)
            alertc.addAction(UIAlertAction(title: "Try again", style: .default, handler: nil))
            // perhaps use action.title here
            
            self.present(alertc, animated: true)
            
        } else if (password.characters.count) < 6 {
            let alertc = UIAlertController(title: "Invalid", message: "Password must be greater than 8 characters", preferredStyle: .alert)
            alertc.addAction(UIAlertAction(title: "Try again", style: .default, handler: nil))
            // perhaps use action.title here
            
            self.present(alertc, animated: true)
            
            
        }
            
            
            
        else {
            
            spinner.startAnimating()
            //
            
           // /*
             FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
             if error != nil {
             print(error ?? "There is a login error")
             
             
             return // print the error and get out
             }
             // IF THERE IS SUCCESS
             self.messagesController?.fetchUserAndSetUpNavBarTitle() // nav bar title
             self.dismiss(animated: true, completion: nil)
             })
           //  */
            
            
            
        }
    }

    
}

extension UIColor {
    
    convenience  init(r: CGFloat, g: CGFloat, b: CGFloat) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
    
    
}
