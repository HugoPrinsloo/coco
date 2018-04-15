//
//  CKDatabase.swift
//  Coco
//
//  Created by Hugo Prinsloo on 2018/04/15.
//  Copyright © 2018 Over. All rights reserved.
//

import Foundation
import UIKit
import CloudKit

class CocoBase: StatusDatabase {
    
    let privateDatabase = CKContainer.default().privateCloudDatabase
    let zone = CKRecordZone(zoneName: "Activity Zone")
    
    init() {
        // Save zone
        privateDatabase.save(zone) { (zone, error) in
            DispatchQueue.main.async {
                if error == nil {
                    print("zone was saved")
                } else {
                    print("Failed to save zone with error: \(String(describing: error))")
                }
            }
        }
    }
    
    func addItem(item: ActivityItem) {
        let name = item.name as CKRecordValue?
        let start = item.startTime as CKRecordValue?
        
        let record = CKRecord(recordType: "Activity", zoneID: zone.zoneID)
        record.setObject(name, forKey: "name")
        record.setObject(start, forKey: "startTime")
        
        privateDatabase.save(record) { (record, error) in
            DispatchQueue.main.async {
                if error == nil {
                    print("Record was saved")
                } else {
                    print("Failed to save record with error: \(String(describing: error))")
                }
            }
        }
    }
    
    func itemAtIndex(_ index: Int) -> ActivityItem {
        return ActivityItem(id: nil, name: nil, duration: nil, startTime: nil, endTime: nil, date: nil)
    }
    
    func saveOrDeleteMultiple() {
        let operation = CKModifyRecordsOperation(recordsToSave: nil, recordIDsToDelete: nil)
        let config = CKOperationConfiguration()
        
        config.timeoutIntervalForRequest = 10
        config.timeoutIntervalForResource = 10
        
        operation.configuration = config
        
        operation.modifyRecordsCompletionBlock = { savedRecords, deletedRecordIDs, error in
            DispatchQueue.main.async {
                if error == nil {
                    print("operation successful")
                } else {
                    print("Failed to perform operation with error: \(String(describing: error))")
                }
            }
        }
        
        privateDatabase.add(operation)
    }

}

class CloudKitVC: UIViewController {
    
    let db = CocoBase()
    
    @IBAction func buttonTapped(_ sender: Any) {
        db.addItem(item: ActivityItem(id: nil, name: "Coding", duration: nil, startTime: "18:21", endTime: nil, date: nil))
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
