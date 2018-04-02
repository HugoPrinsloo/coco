//
//  OverviewViewController.swift
//  Coco
//
//  Created by Hugo Prinsloo on 2018/03/31.
//  Copyright © 2018 Over. All rights reserved.
//

import UIKit

class OverviewViewController: UIViewController {
    
    let db = CocoDatabase()

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        db.itemsDidUpdate = { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    @IBAction func hanldeButtonTapped(_ sender: UIButton) {
        //1. Create the alert controller.
        let alert = UIAlertController(title: "Add Item", message: "Enter a text", preferredStyle: .alert)
        
        //2. Add the text field. You can configure it however you need.
        alert.addTextField { (textField) in
            textField.becomeFirstResponder()
        }
        
        // 3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0] // Force unwrapping because we know it exists.
            if let text = textField?.text {
                self.db.addItem(name: text, duration: 123)
            }
        }))
        
        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)

    }
}

extension OverviewViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return db.numberOfItems()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let item = db.itemAtIndex(index: indexPath.row)
        cell.textLabel?.text = item.name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
