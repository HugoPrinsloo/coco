//
//  InterfaceController.swift
//  CocoWatch Extension
//
//  Created by Hugo Prinsloo on 2018/04/02.
//  Copyright © 2018 Over. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {

    @IBOutlet var tableView: WKInterfaceTable!
    
    let data = ["test", "test2"]
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
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
        tableView.setNumberOfRows(data.count, withRowType: "RowController")
        
        for (index, data) in data.enumerated() {
            if let rowController = tableView.rowController(at: index) as? RowController {
                rowController.rowLabel.setText(data)
            }
        }
    }
    
    override func table(_ table: WKInterfaceTable, didSelectRowAt rowIndex: Int) {
        super.table(tableView, didSelectRowAt: rowIndex)
//        pushController(withName: "DetailController", context: data[rowIndex])
    }
}
