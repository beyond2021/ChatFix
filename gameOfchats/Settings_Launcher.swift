//
//  Settings_Launcher.swift
//  OnFleek
//
//  Created by Kev1 on 4/30/17.
//  Copyright © 2017 Kev1. All rights reserved.
//

import UIKit

class SettingsLauncher: NSObject, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    let blackView = UIView()
    
    let collectionView : UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        cv.backgroundColor = .white
        
     return cv
    }()
    //THIS ARRAY IS OUR DATASOURCE
    let settings : [Setting] = {
        //let s = Settings(name: "Settings", imageName: "Settings Filled-50")
        
        let settingsSetting = Setting(name: .Settings, imageName: "Settings Filled-50")
        let cancelSetting = Setting(name: .Cancel, imageName: "Cancel-50") // with the enum
        let termsPrivacy = Setting(name: .TermsPrivacy, imageName: "Lock Filled-50")
        let sendFeedback = Setting(name: .SendFeedback, imageName: "Comments Filled-50") // with the enum
        let help = Setting(name: .Help, imageName: "Help Filled-50")
        let switchAccount = Setting(name: .SwitchAccount, imageName: "Circled User Male Filled-50") // with the enum
        
        
        
        return [settingsSetting, termsPrivacy, sendFeedback, help, switchAccount , cancelSetting]

        
    }()
    
    let cellHeight : CGFloat = 50
    
    func showSettings(){
        print("Nav More Pressed")
        //get the apps window
        if let window = UIApplication.shared.keyWindow {
            // 2 part animation
            // darken View Animation and menu slide up
            //1: black background view
            
            blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
            
            blackView.backgroundColor = UIColor(white: 0, alpha: 0.5) //black with transparency
            // add it as a subview to viewcontrollers view
            window.addSubview(blackView)
            //
            window.addSubview(collectionView) //may sure that the collectionview is added after the black view
            
            let height: CGFloat = CGFloat(settings.count) * cellHeight//THIS IS HOW WE GET THE TOTAL HEIGHT
            let y = window.frame.height - height
            
            collectionView.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: height)
            //Constraints
            blackView.frame = window.frame
            blackView.alpha = 0
            
            UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.blackView.alpha = 1
                self.collectionView.frame = CGRect(x: 0, y: y, width: self.collectionView.frame.width, height: self.collectionView.frame.height)
                
                
            }, completion: nil)
            
        }
        
    }
    
    func handleDismiss(){
        UIView.animate(withDuration: 0.5, animations: {
            self.blackView.alpha = 0
            // get the window
            if let window = UIApplication.shared.keyWindow {
                self.collectionView.frame = CGRect(x: 0, y: window.frame.height, width: self.collectionView.frame.width, height: self.collectionView.frame.height)
                
                
            }
        })
        
        
    }
    
    let cellId = "cellId"

    
    
    override init(){
        super.init()
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(SettingCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    //CollectionView Life Cycle
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //
        //return 3
       return settings.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! SettingCell // the dequed cell will always be a settings cell
        //cell.textl
        let setting = settings[indexPath.item] //
        cell.setting = setting
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//         if let window = UIApplication.shared.keyWindow {
//            return CGSize(width: window.frame.width, height: 50)
//            
//        }
//        
//        
//        //
//        return CGSize.zero
   return CGSize(width: collectionView.frame.width, height: CGFloat(cellHeight))
    
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    var homeController : MessagesController?
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //
        //print("Pushed :",indexPath.item)
        //get the setting for the item
        //let setting = settings[indexPath.item]
        //print(setting.name)
        //dismissing the collectionView 
        //handleDismiss()
        
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.blackView.alpha = 0
            if let window = UIApplication.shared.keyWindow {
                self.collectionView.frame = CGRect(x: 0, y: window.frame.height, width: self.collectionView.frame.width, height: self.collectionView.frame.height)
                
                
            }
            
        }) { (completed : Bool) in
            let setting = self.settings[indexPath.item]
            //push new viewcontroller
            //self.homeController?.showControllerForSetting(setting: setting)
            if setting.name != .Cancel{
                self.homeController?.showControllerForSetting(setting: setting)
                
            }
            
            
        }
        
        
        
        
    }
    
}
