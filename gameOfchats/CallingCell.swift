//
//  CallingCell.swift
//  gameOfchats
//
//  Created by Kev1 on 5/11/17.
//  Copyright © 2017 Kev1. All rights reserved.
//

import UIKit

class CallingCell: BaseFeedCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    let workArrayStrings = ["Structured Cabling", "Office Networking", "Entry Access Systems", "Enterprise wireless Access Points", "Alarm Systems", "Mobile App Development" ]
    //MANUALLY LOADING ALL WORK
    var works = [Work]()
    
    func getWork(){
        /*
        let workStructuredCabling = Work()
        workStructuredCabling.name = "Structured Cabling"
        workStructuredCabling.workId = 100056
        workStructuredCabling.workDescription = "Structured cabling design and installation is governed by a set of standards that specify wiring data centers, offices, and apartment buildings for data or voice communications using various kinds of cable, most commonly category 5e (CAT5e), category 6 (CAT6), and fiber optic cabling and modular connectors. These standards define how to lay the cabling in various topologies in order to meet the needs of the customer, typically using a central patch panel (which is normally 19 inch rack-mounted), from where each modular connection can be used as needed. Each outlet is then patched into a network switch (normally also rack-mounted) for network use or into an IP or PBX (private branch exchange) telephone system patch panel."
 */
        
        
        if let path = Bundle.main.path(forResource: "work", ofType: "json") {
            do{
               let data = try(NSData(contentsOfFile: path, options: NSData.ReadingOptions.mappedIfSafe))
                //now we will get our json dictionary
                let jsonDictionary = try(JSONSerialization.jsonObject(with: data as Data, options: .mutableContainers)) as! [String:AnyObject]
         //   print(jsonDictionary["work"] ?? "")
                
               /*
                if let workDictionary = jsonDictionary["work"] as? [String:AnyObject] {
                    //Create our new work object
                    let work = Work()
                    //WITH ONE LINE OF CODE
                    work.setValuesForKeys(workDictionary)
                   print(work.name ?? "", work.workDescription ?? "")
                    self.work = [work]
                //    print(self.work)
                    
                }
 */
             if let worksArray = jsonDictionary["work"] as? [[String:AnyObject]] {
              //  print(works)
             //   self.works = works
                for workDictionary in worksArray {
                    let work = Work()
                    
                   work.setValuesForKeys(workDictionary)
                    self.works.append(work)
                }
                
                
                }
                
                

                
            }
            catch let dataErr {
                print(dataErr)
                
            }
            
        }
    }
    
    let workCellId = "workCellId"
    
    lazy var collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.dataSource = self
        cv.delegate = self
        
       return cv
    }()
    
    
   
    let workView : BaseWorkView = {
        let wview = BaseWorkView()
        wview.translatesAutoresizingMaskIntoConstraints = false
        wview.backgroundColor = aquaBlueChatfixColor
        
        return wview
    }()
 

   
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let image = UIImage(named: "20")
       // let baseWorkView = BaseWorkView()
       // baseWorkView.delegate = self
        
        backgroundImageView.image = image
        setupCollectionView()
        getWork()
    }
    
    deinit {
      //  self.messagesController?.navigationController?.isNavigationBarHidden = false
    }
    
    
    func setNavBar(){
      self.messagesController?.navigationController?.isNavigationBarHidden = true
        self.messagesController?.menuBar.isHidden = true
        
    }
    
    
    
    func presentWorkView(work:Work){
        
        UIView.animate(withDuration: 1.0, delay: 0.2, usingSpringWithDamping: 1, initialSpringVelocity: 3, options: .curveEaseOut, animations: {
            self.messagesController?.navigationController?.isNavigationBarHidden = true
            
            self.messagesController?.navigationController?.navigationBar.isHidden = true
            self.messagesController?.navigationController?.navigationBar.isTranslucent = true
//            NotificationCenter.default.post(name: WORK_VIEW_UP_NOTIFICATION, object: nil)
            //extendedLayoutIncludesOpaqueBars
//            self.messagesController?.navigationController?.extendedLayoutIncludesOpaqueBars = true//
            
            
            self.messagesController?.navigationController?.setNavigationBarHidden(true, animated: true)
            
            //
            self.messagesController?.menuBar.isHidden = true
            
            self.messagesController?.menuBar.alpha = 0
            
            
            
            
        }) { (true) in
            //
       //   self.setupWorkView(work: work)
        NotificationCenter.default.post(name: WORK_VIEW_UP_NOTIFICATION, object: nil)
            
            
        }
        
       
    //    print(work.name ?? "")
        
        
        addSubview(workView)
        workView.leftAnchor.constraint(equalTo: backgroundImageView.leftAnchor, constant: 20).isActive = true
        
        workView.rightAnchor.constraint(equalTo: backgroundImageView.rightAnchor, constant: -20).isActive = true
        
        workView.topAnchor.constraint(equalTo: backgroundImageView.topAnchor, constant: 20).isActive = true
        
        workView.bottomAnchor.constraint(equalTo: backgroundImageView.bottomAnchor, constant: -20).isActive = true
//        
//        let baseWorkView = BaseWorkView()
//        print(work.imageName ?? "")
//        baseWorkView.workImageView.image = UIImage(named: work.imageName!)
//        baseWorkView.descriptionLabel.text = work.workDescription
        
        workView.work = work
        
    }

     
    
    
    
    func removeBaseWorkView(){
        print("Removing Base work view")
        
//        self.messagesController?.menuBar.isHidden = false
//        self.messagesController?.menuBar.alpha = 1
        
        UIView.animate(withDuration: 0.5, delay: 0.2, usingSpringWithDamping: 1, initialSpringVelocity: 3, options: .curveEaseOut, animations: {
            //
            self.messagesController?.navigationController?.navigationBar.isHidden = false
            self.messagesController?.navigationController?.setNavigationBarHidden(false, animated: true)
            //self.messagesController?.menuBar.removeFromSuperview()
            self.messagesController?.navigationController?.navigationBar.isTranslucent = false
        //    self.messagesController?.menuBar.isHidden = false
            self.messagesController?.blueView.alpha = 1            //
        //    self.messagesController?.setupMenuBar()
            
//            self.messagesController?.menuBar.alpha = 1
            
            self.messagesController?.menuBar.isHidden = false
            self.messagesController?.menuBar.alpha = 1
            
            
            
            
        }) { (true) in
            //
            NotificationCenter.default.post(name: WORK_VIEW_DOWN_NOTIFICATION, object: nil)
        }
        
        
        
        
        //
        workView.removeFromSuperview()
        

        
        
        
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCollectionView() {
        addSubview(collectionView)
        
        collectionView.register(WorkCell.self, forCellWithReuseIdentifier: workCellId)
        
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .vertical
            //flowLayout.scrollDirection = .horizontal
            flowLayout.minimumLineSpacing = 20 //Decrease the gap
            
        }

        collectionView.contentInset = UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0)
        collectionView.scrollIndicatorInsets = UIEdgeInsets(top:50, left: 0, bottom: 0, right: 0)
        
        collectionView.alpha = 0
        
        collectionView.leftAnchor.constraint(equalTo: backgroundImageView.leftAnchor, constant: 20).isActive = true
        
        collectionView.rightAnchor.constraint(equalTo: backgroundImageView.rightAnchor, constant: -20).isActive = true
        
        collectionView.topAnchor.constraint(equalTo: backgroundImageView.topAnchor, constant: 20).isActive = true
        
        collectionView.bottomAnchor.constraint(equalTo: backgroundImageView.bottomAnchor, constant: -20).isActive = true
        
        UIView.animate(withDuration: 1.0, delay: 0.5, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.collectionView.alpha = 1
        }) { (true) in
            //TODO
//self.readJson()
            self.getWork()
        }

        
        
    }
    
    
    
    
    
    //MARK:- Motion
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
      print("I received a shake")
        
        
    }
    
    //MARK:- DataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       // return workArrayStrings.count
        return works.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: workCellId, for: indexPath) as! WorkCell
        let work = self.works[indexPath.row]
        cell.work = work
        
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 150, height: 150)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.item)
        let cell = collectionView.cellForItem(at: indexPath)
        
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 5, options: [],
                                   animations: {
                                    cell!.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
                                    
        },
                                   completion: { finished in
                                    UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 5, options: .curveEaseInOut,
                                                               animations: {
                                                                cell!.transform = CGAffineTransform(scaleX: 1, y: 1)
                                    },
                                                               completion: nil
                                    )
                                    
        }
        )
        
        NotificationCenter.default.post(name: WORK_VIEW_UP_NOTIFICATION, object: nil)
        
       presentWorkView(work: works[indexPath.item])
        
    }
    
    
    
 
    var messagesController : MessagesController?
    
    
    //MARK:- IMPLEMENTATION SECTION
    func showControllerForSetting(work: Work){
        messagesController?.navigationController?.navigationBar.isHidden = true
        messagesController?.navigationController?.setNavigationBarHidden(true, animated: false)
        messagesController?.menuBar.isHidden = true
        messagesController?.menuBar.alpha = 0
        
        
        
        let dummySettingsViewController = UIViewController()
//        dummySettingsViewController.navigationItem.title = work.name.rawValue
        //dummySettingsViewController.navigationItem.title = work.name
        
        dummySettingsViewController.view.backgroundColor = aquaBlueChatfixColor
      //  messagesController?.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white] //CHANGING
      //  messagesController?.navigationController?.navigationBar.tintColor = .white //setting the back button color
        
        messagesController?.navigationController?.pushViewController(dummySettingsViewController, animated: true)
        
    }
    //MARK:- Delegate Methods
   
    
    
    
    }

extension CallingCell {
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //print what identifys the class
        print("CallingCell :Tounches began in UIView")
       removeBaseWorkView()
        
    }
}
