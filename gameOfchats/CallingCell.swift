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

   
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let image = UIImage(named: "20")
        backgroundImageView.image = image
        setupCollectionView()
        getWork()
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


