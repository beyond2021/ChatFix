//
//  Extensions.swift
//  gameOfchats
//
//  Created by Kev1 on 4/5/17.
//  Copyright © 2017 Kev1. All rights reserved.
//

import UIKit


//Caching
//private var imageCache = NSCache<AnyObject, AnyObject>() // memory bank for all our images
private var imageCache = NSCache<NSString, UIImage>()

extension UIImageView {
    func loadImageUsingCacheWithUrlString(urlString: String){
        //set image to nil everytime we run this call to stop bottom cell images from flashing
        self.image = nil
        
        //Fetch the cache images
        //1: check cache for images first
        if let cachedImage = imageCache.object(forKey: urlString as NSString) {
            self.image = cachedImage
           // self.image = nil
            
            return
        }
        
        //otherwise fireoff a new download
        let url = NSURL(string: urlString)
        // let session = URLSession.shared()
        
        let task = URLSession.shared.dataTask(with: url! as URL, completionHandler: { (data, response, error) in
            if error != nil {
                print(error ?? "Profile pic download error")
                return
            }
            
            // 6
            DispatchQueue.main.async() {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                if let downloadedImage = UIImage(data: data!) {
                   // print("Image Data is:", data)
                    imageCache.setObject(downloadedImage, forKey: (urlString as AnyObject) as! NSString)
                   self.image = downloadedImage
                   // self.image = UIImage(named: "Google Images Filled-50")
                }
                
            }
            
        })
        // 8
        task.resume()
        
    }
}
extension UIView {
    func addContraintsWithFormat(format : String, views: UIView...){
        var viewsDictionary = [String: UIView]()
        for (index, view) in views.enumerated(){
            let key = "v\(index)"
            view.translatesAutoresizingMaskIntoConstraints = false
            viewsDictionary[key] = view
            
        }
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
        
        
    }
    
}
