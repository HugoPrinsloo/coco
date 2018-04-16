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

class CocoBase {
    
    let privateDatabase = CKContainer.default().privateCloudDatabase
    let zone = CKRecordZone(zoneName: "Activity Zone")
    
    var items: [ActivityItem] = []
    
    var itemsDidUpdate: (() -> Void)?
    
    var itemIsOpen: Bool {
        guard !items.isEmpty else {
            return false
        }
        return items.first?.endTime == nil
    }


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
    
    func startActivity(_ item: ActivityItem) {
        let name = item.name as CKRecordValue?
        let duration = item.duration as CKRecordValue?
        let start = currentDate() as CKRecordValue?
        let end = item.endTime as CKRecordValue?
        
        let record = CKRecord(recordType: "Activity", zoneID: zone.zoneID)
        
        record.setObject(name, forKey: "name")
        record.setObject(start, forKey: "startTime")
        record.setObject(end, forKey: "endTime")
        record.setObject(duration, forKey: "duration")

        privateDatabase.save(record) { [weak self] (record, error) in
            DispatchQueue.main.async {
                if error == nil {
                    if let i = record {
                        let newItem = self?.recordToActivity(record: i)
                        self?.items.insert(newItem!, at: 0)
                        self?.itemsDidUpdate?()
                        print("Record was saved")
                    }
                } else {
                    print("Failed to save record with error: \(String(describing: error))")
                }
            }
        }
    }
    
    
    func endActivity() {
        guard let item: ActivityItem = self.items.first, let id = item.id else { return }
        privateDatabase.fetch(withRecordID: id) {[weak self] (fetchedRecord, error) in
            if let record = fetchedRecord {
                
                let endTime: String = (self?.currentDate())!
                let end = endTime as CKRecordValue?
                let dur = self?.duration(start: item.startTime!, end: endTime) as CKRecordValue?
                
                record.setObject(end, forKey: "endTime")
                record.setObject(dur, forKey: "duration")
                
                let operation = CKModifyRecordsOperation(recordsToSave: [record], recordIDsToDelete: nil)
                operation.modifyRecordsCompletionBlock = { _, _, error in
                    if error != nil {
                        print("Failed to update with error: \(String(describing: error))")
                    } else {
                        print("Record was updated")
                        self?.itemsDidUpdate?()
                    }
                }
                
                self?.privateDatabase.add(operation)
            }
        }
    }
    
    func duration(start: String, end: String) -> String? {
        guard let s = stringToDate(date: start), let e = stringToDate(date: end) else {
            return nil
        }
        
        let form = DateComponentsFormatter()
        form.maximumUnitCount = 2
        form.unitsStyle = .abbreviated
        form.allowedUnits = [.hour, .minute]
        return form.string(from: s, to: e)
    }
    
    func stringToDate(date: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        if let date = dateFormatter.date(from: date) {
            let calendar = Calendar.current
            let components = calendar.dateComponents([.hour, .minute], from: date)
            let finalDate = calendar.date(from:components)
            return finalDate
        }
        return nil
    }

    
    func itemAtIndex(_ index: Int) -> ActivityItem {
        return items[index]
    }
    
    func numberOfItems() -> Int {
        return items.count
    }
    
    func fetch() {
        let query = CKQuery(recordType: "Activity", predicate: NSPredicate(value: true))
        privateDatabase.perform(query, inZoneWith: nil) { [weak self] (records, error) in
            if error != nil {
                print("Failed to save record with error: \(String(describing: error))")
            } else {
                guard let items = records else { return }
                var activityItems: [ActivityItem] = []
                for item in items {
                    if let activity: ActivityItem = self?.recordToActivity(record: item) {
                        activityItems.append(activity)
                    }
                }
                self?.items = activityItems
                self?.itemsDidUpdate!()
            }
        }
    }
    
    private func recordToActivity(record: CKRecord) -> ActivityItem {
        return ActivityItem(id: record.recordID,
                            name: record["name"] as? String,
                            duration: record["duration"] as? String,
                            startTime: record["startTime"] as? String,
                            endTime: record["endTime"] as? String)
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
    
    func currentDate() -> String {
        let date = Date()
        let formatter = DateFormatter()
        
        formatter.dateFormat = "HH:mm"
        
        return formatter.string(from: date)
    }


}

public struct ActivityItem {
    let id: CKRecordID?
    let name: String?
    let duration: String?
    let startTime: String?
    let endTime: String?
    
    init(id: CKRecordID?, name: String?, duration: String?, startTime: String?, endTime: String?) {
        self.name = name
        self.duration = duration
        self.id = id
        self.startTime = startTime
        self.endTime = endTime
    }
}


class CloudKitVC: UIViewController {
    
    let db = CocoBase()
    
    @IBAction func end(_ sender: Any) {
        db.endActivity()
    }
    @IBAction func buttonTapped(_ sender: Any) {
        db.startActivity(ActivityItem(id: nil, name: "Gym", duration: nil, startTime: nil, endTime: nil))
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
