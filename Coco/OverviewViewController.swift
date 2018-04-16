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
    
    private let db = CocoBase()
    private let itemManager = ActivityItemManager()
    
    static var activityItems: [Activity]?
    private var items: [ActivityItem] = []

    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    let watchSession = WCSession.default

    override func viewDidLoad() {
        super.viewDidLoad()
        title = NSLocalizedString("Today", comment: "")
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.configureNavigationBar(backgroundColor: UIColor(cocoColor: .midnightBlue), tintColor: UIColor.white, shadowColor: UIColor.white, textColor: UIColor.white)
        view.backgroundColor = UIColor(cocoColor: .midnightBlue)
        addButton.titleLabel?.font = UIFont(cocoFont: .medium, size: 18)

        collectionView.backgroundColor = UIColor.clear
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.prefetchDataSource = self
        
        collectionView.register(OverviewCell.self, forCellWithReuseIdentifier: "Cell")
        
        db.itemsDidUpdate = { [weak self] in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
                self?.addButton.setTitle((self?.db.itemIsOpen)! ? "Stop Activity" : "Add Activity", for: .normal)
            }
        }
        
        db.fetch()
        
        NotificationCenter.default.addObserver(self, selector: #selector(watchInfoReceived), name: NSNotification.Name(rawValue: "receivedWatchData"), object: nil)
   
        OverviewViewController.activityItems = ActivityItemManager.loadItems()
        
    }
        
    @objc func watchInfoReceived(info: NSNotification) {

    }
    
    @IBAction func handleAddButtonTapped(_ sender: UIButton) {
        if db.itemIsOpen {
            db.endActivity()
        } else {
            let vc = ActivitySelectionTableViewController()
            vc.delegate = self
            present(vc, animated: true, completion: nil)
        }
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
        let state: OverviewCell.State = db.itemIsOpen ? .open : .closed
        
        cell.configure(state: state, activity: item.name ?? "", startTime: item.startTime, endTime: item.endTime, duration: item.duration)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width - 20, height: 62)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        db.endActivity()
    }
}

extension OverviewViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
//        db.itemAtIndex(indexPaths)
    }
    
    func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        
    }
}

extension OverviewViewController: ActivitySelectionDelegate {
    func activitySelectionController(_ activitySelectionController: ActivitySelectionTableViewController, didSelect item: Activity) {
        activitySelectionController.dismiss(animated: true, completion: nil)
        db.startActivity(ActivityItem(id: nil, name: item.name, duration: nil, startTime: nil, endTime: nil))
    }
}







