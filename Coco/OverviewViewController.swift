//
//  OverviewUpdatedViewController.swift
//  Coco
//
//  Created by Hugo Prinsloo on 2018/04/07.
//  Copyright © 2018 Over. All rights reserved.
//

import UIKit
import Firebase
import WatchConnectivity


class OverviewViewController: UIViewController {
    
    private let db = CocoDatabase()
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    let watchSession = WCSession.default

    override func viewDidLoad() {
        super.viewDidLoad()
        title = NSLocalizedString("Today", comment: "")
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.configureNavigationBar(backgroundColor: UIColor(cocoColor: .midnightBlue), tintColor: UIColor.white, shadowColor: UIColor.white, textColor: UIColor.white)
        view.backgroundColor = UIColor(cocoColor: .midnightBlue)

        collectionView.backgroundColor = UIColor.clear
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(OverviewCell.self, forCellWithReuseIdentifier: "Cell")
        
        db.itemsDidUpdate = { [weak self] in
            self?.collectionView.reloadData()
        }
        
        db.fetch()
        NotificationCenter.default.addObserver(self, selector: #selector(watchInfoReceived), name: NSNotification.Name(rawValue: "receivedWatchData"), object: nil)
    }
    
    @objc func watchInfoReceived(info: NSNotification) {
        
    }
    
    @IBAction func handleAddButtonTapped(_ sender: UIButton) {
        //1. Create the alert controller.
        let alert = UIAlertController(title: "Add Item", message: nil, preferredStyle: .alert)
        
        //2. Add the text field. You can configure it however you need.
        alert.addTextField { (textField) in
            textField.becomeFirstResponder()
            textField.placeholder = "Activity"
        }
        
        alert.addTextField { (textField2) in
            textField2.placeholder = "Start Time"
            
        }
        
        alert.addTextField { (textField2) in
            textField2.placeholder = "End Time"
            
        }
        
        alert.addTextField { (textField2) in
            textField2.placeholder = "Duration (min)"
            
        }
        
        
        
        // 3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0] // Force unwrapping because we know it exists.
            let start = alert?.textFields![1] // Force unwrapping because we know it exists.
            let end = alert?.textFields![2] // Force unwrapping because we know it exists.
            let dur = alert?.textFields![3] // Force unwrapping because we know it exists.

            if let text = textField?.text {
                self.db.addItem(item: ActivityItem(id: nil, name: text, duration: dur?.text, startTime: start?.text, endTime: end?.text))
            }
        }))
        
        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
    }
}

extension OverviewViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return db.numberOfItems()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! OverviewCell
        let item = db.itemAtIndex(indexPath.item)
        cell.configure(item.name ?? "", duration: "\(String(describing: item.duration)) Min", startTime: item.startTime ?? "", endTime: item.endTime ?? "")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width - 20, height: 62)
    }
}








