//
//  InterfaceController.swift
//  CocoWatch Extension
//
//  Created by Hugo Prinsloo on 2018/04/02.
//  Copyright © 2018 Over. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity

class InterfaceController: WKInterfaceController {
    
    var items: [String?] = [] {
        didSet {
            print(items)
        }
    }

    @IBOutlet var tableView: WKInterfaceTable!

    let session = WCSession.default
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        NotificationCenter.default.addObserver(self, selector: #selector(didReceivePhoneData), name: NSNotification.Name(rawValue: "ReceivedPhoneData"), object: nil)
        loadTableData()
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

    func loadTableData() {
        tableView.setNumberOfRows(items.count, withRowType: "RowController")
        
        for (index, items) in items.enumerated() {
            if let rowController = tableView.rowController(at: index) as? RowController {
                rowController.rowLabel.setText(items)
            }
        }
    }
    
    override func table(_ table: WKInterfaceTable, didSelectRowAt rowIndex: Int) {
        super.table(tableView, didSelectRowAt: rowIndex)
//        pushController(withName: "DetailController", context: data[rowIndex])
    }
    
    @objc func didReceivePhoneData(info: NSNotification) {
        if let message = info.userInfo {
            items.removeAll()
            items = message["Array1"] as! [String?]
        }
        loadTableData()
    }
}


