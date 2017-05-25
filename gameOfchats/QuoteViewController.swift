//
//  QuoteViewController.swift
//  ChatFix
//
//  Created by Kev1 on 5/24/17.
//  Copyright © 2017 Kev1. All rights reserved.
//

import UIKit
import AVFoundation

class QuoteViewController: UIViewController , AVCapturePhotoCaptureDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    /*
 //   @IBOutlet weak var cameraView: UIView!
    
    let recordButton : UIButton = {
        //let button = UIButton()
        let button = UIButton(type: .system)
        button.setTitle("Record", for: .normal)
        button.setTitleColor(aquaBlueChatfixColor, for: .normal);
        let image = UIImage(named: "Message Filled-50");
        button.translatesAutoresizingMaskIntoConstraints = false;
        
        return button
    }()
    
    let imgOverlay: UIImageView = {
        let cv = UIImageView()
        cv.translatesAutoresizingMaskIntoConstraints = false
        
        return cv
    }()
    
    let previewView: UIView = {
        let cv = UIView()
        cv.translatesAutoresizingMaskIntoConstraints = false
        
        return cv
    }()


    
    
    
    var captureSession = AVCaptureSession()
    var videoCaptureDevice : AVCaptureDevice?
    let stillImageOutput : AVCapturePhotoOutput? = nil
    var previewLayer : AVCaptureVideoPreviewLayer?
    var movieFileOutput : AVCaptureMovieFileOutput? = nil
    var input : AVCaptureInput?
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
      //  view.addSubview(<#T##view: UIView##UIView#>)
        reset()
        self.intializeCameraForVideo()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
       // self.intializeCameraForVideo()
    }
    
    @IBAction func recordVideoButtonPressed(sender:AnyObject){
        
        
    }
    
    @IBAction func cameraToggleButtonPressed(sender:AnyObject){
        
        
    }
    //MAIN:-
    func setVideoOrientation(){
        if let connection = self.previewLayer?.connection {
            if connection.isVideoOrientationSupported {
                connection.videoOrientation = self.videoOrientation()
                self.previewLayer?.frame = self.view.bounds
                
            }
            
        }
        
        
    }
    
    func intializeCameraForVideo(){
        self.captureSession.sessionPreset = AVCaptureSessionPresetHigh
        //get all devices
        if let discovery = AVCaptureDeviceDiscoverySession.init(deviceTypes: [AVCaptureDeviceType.builtInWideAngleCamera], mediaType: AVMediaTypeVideo, position: .unspecified) {
            
            for device in discovery.devices as [AVCaptureDevice] {
                if device.hasMediaType(AVMediaTypeVideo) {
                    if device.position == AVCaptureDevicePosition.back {
                        self.videoCaptureDevice = device
                        
                    }
                    
                    
                }
                
                
            }
            if videoCaptureDevice != nil {
                //input = AVCaptureDeviceInput(device: self.videoCaptureDevice)
                
                // now that we have a capture device lets add it to the session
                do {
                    input = try(AVCaptureDeviceInput(device: self.videoCaptureDevice))
                  // input = try captureSession.addInput(videoCaptureDevice)
                    
                    
                   self.captureSession.addInput(input)//this is only video
                    //lets grab the default audio= the default mic or the headset if its activated
                    
                    if let audioInput = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeAudio){
                        try self.captureSession.addInput(AVCaptureDeviceInput(device: audioInput))
                        
                    }
                    print(captureSession )
                    
                    //NOW LETS ADD OUR PREVIEW LAYER
                   self.previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
                    
                    print("self.previewLayer",self.previewLayer ?? "")
//                    if case previewLayer?.session = captureSession {
//                     print("preview layer is:",self.previewLayer ?? "")
//                        
//                    }
                    
                    
         //           (self.previewLayer!).session = captureSession;                    print("preview 
         //           layer is:",self.previewLayer ?? "")
                    
                    
                    
                    //set the preview frame to the device dimensions
                    self.previewView.frame.size = CGSize(width: view.frame.size.width, height: view.frame.size.height)
//                        CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height)
//                    self.previewView.frame.size = self.view.frame.size
//                    self.view.layer.addSublayer(self.previewLayer!)
                    
                    
                    self.previewView.layer.addSublayer(self.previewLayer!)
                    self.previewLayer?.frame = self.previewView.frame
                   // self.v
                    //set the video orientation
                    self.setVideoOrientation()
                    //
                    self.captureSession.addOutput(self.movieFileOutput)
                    //
                    self.captureSession.startRunning()
                    
                    
                } catch {
                    //Catch our errors
                    print(error)
                    
                }
                
            }

            
            
        }
        //going true the devices array
        
        
    }
    
    
    //Helper functions; Check what the device current orientation is. the out orientation is not necessarly to same as the device
    func videoOrientation() -> AVCaptureVideoOrientation {
        var videoOrientation : AVCaptureVideoOrientation?
         let orientation : UIDeviceOrientation = UIDevice.current.orientation
            
            switch orientation {
            case .portrait:
                videoOrientation = .portrait
            case .landscapeLeft:
                videoOrientation = .landscapeRight
            case .landscapeRight:
                videoOrientation = .landscapeLeft
            case .portraitUpsideDown:
                videoOrientation = .portrait
                
            default:
                videoOrientation = .portrait
            }
            
            
       return videoOrientation!
        
        
    }
    override func viewWillLayoutSubviews() {
        self.setVideoOrientation()
    }
    
      deinit {
        reset()
    }
    
    func reset(){
        self.captureSession.removeInput(input)
        self.captureSession.removeOutput(movieFileOutput)
        
        self.captureSession.stopRunning()
        self.movieFileOutput = nil;
        
        
    }
 */
    
    
}
