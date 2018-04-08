//
//  ActivitySelectionTableViewController.swift
//  Coco
//
//  Created by Hugo Prinsloo on 2018/04/07.
//  Copyright © 2018 Over. All rights reserved.
//

import UIKit

protocol ActivitySelectionDelegate: class {
    func activitySelectionController(_ activitySelectionController: ActivitySelectionTableViewController, didSelect item: Activity)
}

class ActivitySelectionTableViewController: UITableViewController {

    private var items: [Activity] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    weak var delegate: ActivitySelectionDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        items = ActivityItemManager.loadItems() ?? []
        tableView.register(TableCell.self, forCellReuseIdentifier: "ACell")
    }

    func setup() {
        var items: [Activity] = ActivityItemManager.loadItems() ?? []
        
        if items.isEmpty {
            //1. Create the alert controller.
            let alert = UIAlertController(title: "Add Item", message: nil, preferredStyle: .alert)
            
            //2. Add the text field. You can configure it however you need.
            alert.addTextField { (textField) in
                textField.becomeFirstResponder()
                textField.placeholder = "Activity"
            }
            
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
                let textField = alert?.textFields![0] // Force unwrapping because we know it exists.
                
                if let text = textField?.text {
                    items.append(Activity(name: text))
                    ActivityItemManager.save(items)
                }
            }))
            
            // 4. Present the alert.
            present(alert, animated: true, completion: nil)
            
        } else {
            let alert = UIAlertController(title: "Select Item", message: nil, preferredStyle: .alert)
            
            alert.addTextField { (textField) in
                textField.placeholder = "New Item"
            }
            
            alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { [weak alert] (_) in
                let textField = alert?.textFields![0] // Force unwrapping because we know it exists.
                
                if let text = textField?.text {
                    items.append(Activity(name: text))
                    ActivityItemManager.save(items)
                }
            }))
            
            for item in items {
                alert.addAction(UIAlertAction(title: item.name, style: .default, handler: nil))
            }
            present(alert, animated: true, completion: nil)
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count + 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ACell", for: indexPath) as! TableCell
        
        if indexPath.row == 0 {
            cell.textLabel?.text = "Add Item"
        } else {
            cell.textLabel?.text = items[indexPath.row - 1].name
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            addNewItem()
        } else {
            delegate?.activitySelectionController(self, didSelect: items[indexPath.row - 1])
        }

    }
    
    func addNewItem() {
        let alert = UIAlertController(title: "Add Item", message: nil, preferredStyle: .alert)
        
        //2. Add the text field. You can configure it however you need.
        alert.addTextField { (textField) in
            textField.becomeFirstResponder()
            textField.placeholder = "Activity"
        }
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0] // Force unwrapping because we know it exists.
            
            if let text = textField?.text {
                self.items.append(Activity(name: text))
                ActivityItemManager.save(self.items)
            }
        }))
        
        // 4. Present the alert.
        present(alert, animated: true, completion: nil)
    }

}

class TableCell: UITableViewCell {
    
}

class ActivityItemManager {
    
    private static let key = "ActivityItems"
    
    private static func archive(_ items : [Activity]) -> NSData {
        return NSKeyedArchiver.archivedData(withRootObject: items as NSArray) as NSData
    }
    
    static func loadItems() -> [Activity]? {
        if let unarchivedObject = UserDefaults.standard.object(forKey: key) as? Data {
            return NSKeyedUnarchiver.unarchiveObject(with: unarchivedObject as Data) as? [Activity]
        }
        return nil
    }
    
    static func save(_ items: [Activity]) {
        let archivedObject = archive(items)
        UserDefaults.standard.set(archivedObject, forKey: key)
        UserDefaults.standard.synchronize()
    }
}

class Activity: NSObject, NSCoding {
    
    let name: String?
    
    required init(name: String) {
        self.name = name
    }
    
    required init?(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObject(forKey: "name") as? String
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "name")
    }
}

