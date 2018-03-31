//
//  StatusTableViewController.swift
//  Coco
//
//  Created by Hugo Prinsloo on 2018/03/31.
//  Copyright © 2018 Over. All rights reserved.
//

import UIKit

class StatusTableViewController: UITableViewController {
    
    let db = CocoDatabase()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        _ = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(update), userInfo: nil, repeats: false)
        _ = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(update1), userInfo: nil, repeats: false)
        _ = Timer.scheduledTimer(timeInterval: 6, target: self, selector: #selector(update2), userInfo: nil, repeats: false)
        
        db.itemsDidUpdate = { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    @objc func update() {
        db.addItem(item: ActivityItem(name: "gym", duration: 120, timestamp: Date().ticks))
    }
    @objc func update1() {
        db.addItem(item: ActivityItem(name: "shower", duration: 160, timestamp: Date().ticks))
    }
    @objc func update2() {
        db.addItem(item: ActivityItem(name: "gym", duration: 3000, timestamp: Date().ticks))
    }
}


extension StatusTableViewController {
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return db.numberOfItems()
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = "Whooho"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Section \(section)"
    }

}



