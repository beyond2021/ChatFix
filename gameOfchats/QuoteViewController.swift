//
//  QuoteViewController.swift
//  ChatFix
//
//  Created by Kev1 on 5/24/17.
//  Copyright © 2017 Kev1. All rights reserved.
//

import UIKit
import AVFoundation
import SwiftyCam

class QuoteViewController: SwiftyCamViewController , SwiftyCamViewControllerDelegate {
    //MARK:- Controls
    lazy var flashSwitch : UISwitch = {
        let sw = UISwitch()
        sw.translatesAutoresizingMaskIntoConstraints = false
        sw.addTarget(self, action: #selector(flashDidChange(_:)), for: .valueChanged)
        sw.isOn = true
        sw.setOn(true, animated: true)
        
     return sw
    }()
    
    lazy var camera : UIButton = {
        let sw = UIButton(type: .system)
        sw.translatesAutoresizingMaskIntoConstraints = false
        sw.addTarget(self, action: #selector(cameraSwitch), for: .touchUpInside)
        
        
        return sw
    }()
    
    lazy var photoButton : SwiftyCamButton = {
        let sw = SwiftyCamButton(type: .system)
        sw.translatesAutoresizingMaskIntoConstraints = false
        sw.addTarget(self, action: #selector(takePic), for: .touchUpInside)
        sw.delegate = self
        return sw
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
                setupViews()
        
        cameraDelegate = self
        defaultCamera = .rear
        
        doubleTapCameraSwitch = false
        videoQuality = .high
        maximumVideoDuration = 10.0
        
        
    }
    
    func setupViews(){
        
        
    }
    
    
    //MARK:- Flash
    func flashDidChange(_ sender:UISwitch) {
       // flashEnabled = true
        if (sender.isOn == true){
            print("on")
        }
        else{
            print("off")
        }
        
    }
    func cameraSwitch(){
        
        
    }
    func takePic(){
      // captu
        
    }
    //MARK:- Swifty Cam Delegate methods
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didTake photo: UIImage) {
        // Called when takePhoto() is called or if a SwiftyCamButton initiates a tap gesture
        // Returns a UIImage captured from the current session
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didBeginRecordingVideo camera: SwiftyCamViewController.CameraSelection) {
        // Called when startVideoRecording() is called
        // Called if a SwiftyCamButton begins a long press gesture
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didFinishRecordingVideo camera: SwiftyCamViewController.CameraSelection) {
        // Called when stopVideoRecording() is called
        // Called if a SwiftyCamButton ends a long press gesture
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didFinishProcessVideoAt url: URL) {
        // Called when stopVideoRecording() is called and the video is finished processing
        // Returns a URL in the temporary directory where video is stored
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didFocusAtPoint point: CGPoint) {
        // Called when a user initiates a tap gesture on the preview layer
        // Will only be called if tapToFocus = true
        // Returns a CGPoint of the tap location on the preview layer
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didChangeZoomLevel zoom: CGFloat) {
        // Called when a user initiates a pinch gesture on the preview layer
        // Will only be called if pinchToZoomn = true
        // Returns a CGFloat of the current zoom level
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didSwitchCameras camera: SwiftyCamViewController.CameraSelection) {
        // Called when user switches between cameras
        // Returns current camera selection   
    }
}
