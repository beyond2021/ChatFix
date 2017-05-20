//
//  CallingCell.swift
//  gameOfchats
//
//  Created by Kev1 on 5/11/17.
//  Copyright © 2017 Kev1. All rights reserved.
//

import UIKit

class CallingCell: BaseFeedCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout  {
    
    let workArrayStrings = ["Structured Cabling", "Office Networking", "Entry Access Systems", "Wireless Access Points", "Alarm Systems", "Mobile App Development" ]
    
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

   
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let image = UIImage(named: "20")
        backgroundImageView.image = image
        setupCollectionView()
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
        
        UIView.animate(withDuration: 3.0, delay: 0.5, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.collectionView.alpha = 1
        }) { (true) in
            //TODO
            self.readJson()
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
        return workArrayStrings.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: workCellId, for: indexPath)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 150, height: 150)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.item)
    }
    
    
//MARK:- read Json
    
    

    private func readJson() {
        let str = "{\"names\": [\"Bob\", \"Tim\", \"Tina\"]}"
        let data = str.data(using: String.Encoding.utf8, allowLossyConversion: false)!
        
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String: AnyObject]
            if let names = json["names"] as? [String] {
                print(names)
            }
        } catch let error as NSError {
            print("Failed to load: \(error.localizedDescription)")
        }
        
        
        
//        do {
//            if let file = Bundle.main.url(forResource: "work", withExtension: "json") {
//                let data = try Data(contentsOf: file)
//                print(data)
////                let json = try JSONSerialization.jsonObject(with: data, options: [])
//                let json = try JSONSerialization.jsonObject(with: data, options:.allowFragments)
//                
//                
//                if let object = json as? [String: Any] {
//                    // json is a dictionary
//                    print(object)
//                } else if let object = json as? [Any] {
//                    // json is an array
//                    print(object)
//                } else {
//                    print("JSON is invalid")
//                }
//            } else {
//                print("no file")
//            }
//        } catch {
//            print(error.localizedDescription)
//        }
    }
 
 
    
    //
    /*
    
    private func readJson() {
        let file = Bundle.main.path(forResource: "work", ofType: "json")
        let data = try? Data(contentsOf: URL(fileURLWithPath: file!))
//        let jsonData = try? JSONSerialization.jsonObject(with: data!, options: []) as! [String:Any]
//        print(jsonData)
//    }
        
       //
        do {
            //REDUCTION
            //ALL THE SETTINGS DONE IN VIDEO! - SETVALUEFORKEY
            
            //BANG! RELATED
            if let unwrappedData = data, let jsonDictionaries = try JSONSerialization.jsonObject(with: unwrappedData, options: .mutableLeaves) as? [[String : AnyObject]]  {
                DispatchQueue.main.async( execute: {
                    
                    //.Success(JSON)
                    print(jsonDictionaries)
                })
                
              //  print(.Failure(error as NSError))
                
            }
            
            
        } catch let jsonError {
            print(jsonError) //error parsing the json
        }
        
        //NOW WE HAVE THIS JSON OBJECT
        
    }
    
 */
    
        //
    
    
    }


