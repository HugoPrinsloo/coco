//
//  StatusDatabase.swift
//  Coco
//
//  Created by Hugo Prinsloo on 2018/03/31.
//  Copyright © 2018 Over. All rights reserved.
//

import Foundation
import Firebase

protocol StatusDatabase {
    func addItem(item: ActivityItem)
}

class CocoDatabase: StatusDatabase {
    
    private var items: [ActivityItem] = [] {
        didSet {
            itemsDidUpdate?()
        }
    }
    
    var db: DatabaseReference?
        
    var itemsDidUpdate: (() -> Void)?
    
    init() {
        
        db = Database.database().reference().child("Activity")
        db?.observe(DataEventType.value, with: { (snap) in
            //TODO: Should decode snap and update items
        })
    }
    
    func addItem(item: ActivityItem) {
        items.append(item)
        let newItem = db?.child("\(items.count) - \(item.name)")
        newItem?.setValue(item.timestamp)
        newItem?.child("duration").setValue(item.duration)
        newItem?.child("timestamp").setValue(item.timestamp)
    }
    
    func numberOfItems() -> Int {
        return items.count
    }
    
    public func addTotificationBlock(_ block: @escaping () -> Void) {
        
    }
    
}

struct ActivityItem {
    let name: String
    let duration: Int
    let timestamp: UInt64
}



