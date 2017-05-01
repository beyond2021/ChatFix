//
//  ViewController.swift
//  OnFleek
//
//  Created by Kev1 on 4/26/17.
//  Copyright © 2017 Kev1. All rights reserved.
//

import UIKit

class HomeController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    //INTRODUCING AN ARRAY OF MODELS(VIDEOS) // MODEL CLASS OF MVC
//    var videos : [Video] = {
//        
//        var kanyeChannel = Channel()
//        kanyeChannel.name = "KanyeIsTheBestChannel"
//        kanyeChannel.profileImageName = "kanye_west"
//        //create the very first video
//        var blankSpaceVideo = Video() // as a new video object
//        blankSpaceVideo.title = "Taylor Swift - Blank Space"
//        //blankSpaceVideo.subTitle = "this is Blank Space subtitle"
//        blankSpaceVideo.thumbNailImageName = "TaylorS"
//        blankSpaceVideo.channel = kanyeChannel
//        blankSpaceVideo.numberOfViews = 38888888999
//        
//        var badBloodVideo = Video() // as a new video object
//        badBloodVideo.title = "Taylor Swift - Bad Blood featuring Kendrick Lamar"
//        //badBloodVideo.subTitle = "this is Bad Blood subtitle"
//        badBloodVideo.thumbNailImageName = "taylor-swift-24a"
//        badBloodVideo.channel = kanyeChannel
//        badBloodVideo.numberOfViews = 766778888888888
//
//        
//        
//        return[blankSpaceVideo, badBloodVideo] // only shows the same video twice. we have to do somerthing when the video property is set in VideoCell
//        
//        
//        
//    }()
    //FROM REST API
    var videos : [Video]? // optional because we dont know what it is in the beginning. potentially just nothing
    
    //REST2
    func fetchVideos() {
        let url = URL(string: "https://s3-us-west-2.amazonaws.com/youtubeassets/home.json")
       // 1: fire off a nsurlSession
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            //these 3 parameters (data, response, error) are completed when the service returns from the json request
            
            if error != nil {
                print(error ?? "the request from the server ran into an error")
                return //immediately exit out
            }
            
            //SUCCESS MEAN THAT THE DATA IS GOOD ENOUGH TO START PROCESSING
//            let str = NSString(data: data!, encoding: String.Encoding.utf8.rawValue) //HOW TO CONSTRUCT THE STRING OF THE DATA RECEIVED FROM THE API SWIFT 3
//            print(str ?? "")
            
            //LETS USE A JSON PARSER TO MAKE SENSE OF THE STR
            //let json = JSONSerialization.jsonObject(with: data!, options: .mutableContainers) //can throw
            
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
               // print(json) // Its A dictionary. lets contruct the video object from the json file
                //CONSTRUCT THE VIDEO ARRAY HERE
                self.videos = [Video]()
                
                //LOOP THRU THE ENTIRE JSON OBJECT DICTIONARY RECEIVED. MEANS WE ARE DOWNCASTION THE JSON RECEIVED AS AN ARRAY OF DICTIONARIES
                for dictionary in json as! [[String : AnyObject]] {
                    //get title of dictionaries
                    //print(dictionary["title"] ?? "No Titles")
                    //NOW LETS CONSTUCT OUR VIDEO OBJECT IN THIS LOOP
                    
                    let video = Video() //new video object
                    video.title = dictionary["title"] as! String?
                    video.thumbNailImageName = dictionary["thumbnail_image_name"] as! String?
                    
                   //SETUP A CHANNEL DICTIONARY
                    let channelDictionary = dictionary["channel"] as! [String:AnyObject]
                    let channel = Channel()
                    channel.name = channelDictionary["name"] as? String
                    channel.profileImageName = channelDictionary["profile_image_name"] as? String
                    
                    video.channel = channel
                    
                    
                    self.videos?.append(video) // now we have the entire video array
                }
                
                DispatchQueue.main.async( execute: {
                    //after looping thru everything call reload data
                    self.collectionView?.reloadData() //bug if not on the main thread
                    
                })
                
                
                
            } catch let jsonError {
                print(jsonError) //error parsing the json
            }
            
            //NOW WE HAVE THIS JSON OBJECT
            
            
            
            
        }.resume() // add this to kick off the request
        
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchVideos() // REST 1
        
        //setting the battery color to white
        let titleLabel = UILabel(frame:CGRect(x: 0, y: 0, width: view.frame.width - 32, height: view.frame.height))
        navigationItem.titleView = titleLabel
        titleLabel.text = "Home"
        titleLabel.textColor = .white
        titleLabel.font = UIFont.systemFont(ofSize: 20)
        
        //view.backgroundColor = .red
        navigationItem.title = "Home"
        navigationController?.navigationBar.isTranslucent = false
        collectionView?.backgroundColor = .white
        // register class
        collectionView?.register(VideoCell.self, forCellWithReuseIdentifier: "cellId")
        
        // Push the collectionView down a bit
        collectionView?.contentInset = UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0)
        collectionView?.scrollIndicatorInsets = UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0)
        
        
        
        //Add the menuBar view
        setupMenuBar()
        setupNavBarButtonsOnRight()
        
    }
    
    
    //Right BarButtonItems
    
    func setupNavBarButtonsOnRight(){
        let searchImage = UIImage(named: "Search-50")?.withRenderingMode(.alwaysOriginal)//makes the icon white
        let searchBarButtonItem = UIBarButtonItem(image: searchImage, style: .plain, target: self, action: #selector(handleSearch))
        let moreImage = UIImage(named: "Menu 2 Filled-50")?.withRenderingMode(.alwaysOriginal)
        let moreBarButtonItem = UIBarButtonItem(image: moreImage , style: .plain, target: self, action: #selector(handleMore))
        
        navigationItem.rightBarButtonItems = [ moreBarButtonItem, searchBarButtonItem]
        
    }
    //lazy code only called once when settingsLauncher is nil
    lazy var settingsLauncher: SettingsLauncher = {
        let launcher = SettingsLauncher()
        launcher.homeController = self
      return launcher
    }()
    
    func handleMore(){
        ////////////////////////////////
        //settingsLauncher.homeController = self //this will make sure its not nil when called from. the happens everytime we hit the more button settingsLauncher
        settingsLauncher.showSettings() //this can be nil by itself
        //THIS IS OW WE PUSH A NEW CONTROLLER ONTO THE STACK
        //showControllerForSettings()
        
    }
    
    //
    func showControllerForSetting(setting: Setting){
        let dummySettingsViewController = UIViewController()
        dummySettingsViewController.navigationItem.title = setting.name
        dummySettingsViewController.view.backgroundColor = .white
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white] //CHANGING THE TITLE COLOR 
        
        navigationController?.navigationBar.tintColor = .white //setting the back button color
        navigationController?.pushViewController(dummySettingsViewController, animated: true)

        
        
    }
    
    func handleSearch() {
//        print(123)
        
    }
    var menuBar : MenuBar = {
        let mb = MenuBar()
        mb.translatesAutoresizingMaskIntoConstraints = false
        
       return mb
    }()
    
    private func setupMenuBar(){
     
     self.view.addSubview(menuBar)
        
        
     menuBar.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
     menuBar.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
     menuBar.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
     menuBar.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //return 5
        //return videos.count //error because it require non optional int
        /*
         //same as below
        if let count = videos?.count {
            return count
        }
        return 0
 */
        //
        
        return videos?.count ?? 0
        
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! VideoCell
        cell.video = videos?[indexPath.row] // done in videocell
        //cell.backgroundColor = .red // cell being rendered 50 x 50 pixels accross the screen
        return cell
    }
    
    //UICollectionViewDelegateFlowLayout for the cell size methods
    
    // dequeueReusableCell calls initWithFrame - setupviews method
    
    //sizing of the cells
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //video sizing on the HD on web 1280 / 720 = 1.7, 16/9, 1920/1080 all = 1.777777777777778
        //so 16/9 is the aspect ratio we want
        let height = (view.frame.width - 16 - 16) * 9 / 16
        //print(height)
        
        return CGSize(width: view.frame.width, height: height + 16 + 88)//16 = 68 is the vertical spacing differencr
    }
    // Line spacing
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    

}


