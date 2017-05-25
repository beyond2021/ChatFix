//
//  BaseWorkView.swift
//  ChatFix
//
//  Created by Kev1 on 5/21/17.
//  Copyright © 2017 Kev1. All rights reserved.
//

import UIKit
extension BaseWorkView {
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //print what identifys the class
        print("UIView :Tounches began in UIView")
        next?.touchesBegan(touches, with: event)
           }
    
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        if(event?.subtype == UIEventSubtype.motionShake) {
            print("You shook me, now what")
        }

    }
    
    
}




protocol BaseWorkViewDelegate: class {
    func dismissWorkView(sender: UIButton)
}

class BaseWorkView: UIView {
    
    
    
    
    
    weak var delegate : BaseWorkViewDelegate?
    
    let whiteView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.clipsToBounds = true
        view.layer.masksToBounds = true
        
        return view
     }()
    let workImageView : UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = aquaBlueChatfixColor
       view.contentMode = .scaleAspectFill
     //   view.clipsToBounds = true
//view.clipsToBounds = true
        view.layer.masksToBounds = true
      //  let image = UIImage(named: "monitor-1307227_640")
       // view.image = image
                
        return view
    }()

    
    
    
    /*
    let dismissButton : UIButton = {
        let button = UIButton(type:.system )
        let image = UIImage(named: "Cancel-51")
        button.setImage(image, for: UIControlState.normal)
//        button.addTarget(self, action: #selector(CallingCell.dismissWorkView), for: .touchUpInside)
        button.addTarget(self, action: #selector(dismissWorkView), for: .touchUpInside)
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        
        
       return button
    }()
     
 */
   /*
     initWithCoder:
     layerClass
     setNeedsDisplay
     addConstraints:
     addConstraint: (can happen multiple times)
     willMoveToSuperview:
     invalidateIntrinsicContentSize
     didMoveToSuperview
     awakeFromNib
     willMoveToWindow:
     needsUpdateConstraints
     didMoveToWindow
     setNeedsLayout
     updateConstraints
     intrinsicContentSize
     layoutSubviews (can happen multiple times)
     drawRect:
 
 */
    
    
    
    let descriptionLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        
        
       return label
    }()
    
    let quoteLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.text = "Shake To Get A Quote"
        label.textColor = .white
        
        
        return label
    }()
    
   
   
   
       override init(frame: CGRect) {
        super.init(frame: frame)
        self.isUserInteractionEnabled = true
        
        
        layer.cornerRadius = 20
        self.becomeFirstResponder()
    }
    
    
//   var quoteWidthAnchor : NSLayoutConstraint?
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.becomeFirstResponder()
 //       self.canBecomeFirstResponder = true

        //
        addSubview(workImageView)
        workImageView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        workImageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        workImageView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        workImageView.heightAnchor.constraint(equalToConstant: bounds.size.height / 2).isActive = true
       // print("height is:",bounds.size.height)
        //
        workImageView.addSubview(quoteLabel)
        quoteLabel.centerXAnchor.constraint(equalTo: workImageView.centerXAnchor).isActive = true
        quoteLabel.topAnchor.constraint(equalTo: workImageView.topAnchor, constant: 20).isActive = true
        quoteLabel.widthAnchor.constraint(equalToConstant: bounds.size.width / 2).isActive = true
        quoteLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        
        
        addSubview(whiteView)
        whiteView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        whiteView.topAnchor.constraint(equalTo: workImageView.bottomAnchor).isActive = true
        whiteView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        whiteView.heightAnchor.constraint(equalToConstant: bounds.size.height / 2).isActive = true
        
        whiteView.addSubview(descriptionLabel)
        descriptionLabel.leftAnchor.constraint(equalTo: whiteView.leftAnchor, constant: 20).isActive = true
        descriptionLabel.topAnchor.constraint(equalTo: whiteView.topAnchor, constant: 20).isActive = true
        descriptionLabel.rightAnchor.constraint(equalTo: whiteView.rightAnchor, constant: -20).isActive = true
        descriptionLabel.bottomAnchor.constraint(equalTo: whiteView.bottomAnchor, constant: -20).isActive = true

        
        
    }
    
    
    var work : Work? {
        didSet{
            workImageView.image = UIImage(named: (work?.imageName)!)                
                
            descriptionLabel.text = work?.workDescription
          //  print("description label is:",descriptionLabel.text ?? "")
            
            
        }
        
    }
    
    //MARK:- Shake Gesture
     
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
   }
