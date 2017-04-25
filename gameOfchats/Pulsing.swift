//
//  Pulsing.swift
//  Testing
//
//  Created by Kev1 on 4/24/17.
//  Copyright © 2017 Kev1. All rights reserved.
//

import UIKit

class Pulsing: CALayer {
    var animationGroup = CAAnimationGroup()
    //
    var initialPulseScale:Float = 0
    //
    var nextPulseAfter:TimeInterval = 0
    //
    var animationDuration:TimeInterval = 1.5
    //
    var radius:CGFloat = 200
    //
    var numberOfPulses = Float.infinity //forever
    
    
    //regular initializer
    override init(layer: Any) {
        super.init(layer: layer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //THIS IS OUR INITIALIZER
    init(numberOfPulses:Float =  Float.infinity, radius:CGFloat, position:CGPoint) {
        //
        super.init()
        //Our settings
        
        //backgroundColor
        self.backgroundColor = UIColor.black.cgColor
        //change the scale to the main screen
        self.contentsScale = UIScreen.main.scale
        //opacity
        self.opacity = 0
        //radius
        self.radius = radius
        //numberOfPulses
        self.numberOfPulses = numberOfPulses
        //position
        self.position = position
        
        self.bounds = CGRect(x: 0, y: 0, width: radius * 2, height: radius * 2)
        //make sure that we are a circle
        self.cornerRadius = radius
        
        
        DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
            //SETUP
            self.setupAnimationGroup()
            DispatchQueue.main.async {
                 self.add(self.animationGroup, forKey: "pulse")
            }
        }
        
       
        //Add
       
    }
    
    //Noew lets create our animation
    
    //CABasicAnimation
    func createScaleAnimation() -> CABasicAnimation {
        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale.xy")
        scaleAnimation.fromValue = NSNumber(value: initialPulseScale)
        scaleAnimation.toValue = NSNumber(value: 1)
        scaleAnimation.duration = animationDuration
        
      return scaleAnimation
    }
    
    //CAKeyframeAnimation
    
    func createOpacityAnimation() -> CAKeyframeAnimation {
        //create the animation
        let opacityAnimation = CAKeyframeAnimation(keyPath: "opacity")
        opacityAnimation.duration = animationDuration
        opacityAnimation.values = [0.8, 0.4, 0]
        //when
        opacityAnimation.keyTimes = [0, 0.2, 1]
        
        
     return opacityAnimation
    }
    
    func setupAnimationGroup(){
        self.animationGroup = CAAnimationGroup()
        self.animationGroup.duration = animationDuration + nextPulseAfter
        self.animationGroup.repeatCount = numberOfPulses
        // 
        let defaultCurve = CAMediaTimingFunction(name: kCAMediaTimingFunctionDefault)
        self.animationGroup.timingFunction = defaultCurve
        //
        self.animationGroup.animations = [createScaleAnimation(), createOpacityAnimation()]
    }

    

}
