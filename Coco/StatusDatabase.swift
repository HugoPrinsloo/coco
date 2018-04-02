//
//  StatusDatabase.swift
//  Coco
//
//  Created by Hugo Prinsloo on 2018/03/31.
//  Copyright © 2018 Over. All rights reserved.
//

import Foundation
import Firebase
import CodableFirebase


protocol StatusDatabase {
    func addItem(item: ActivityItem)
    func itemAtIndex(_ index: Int) -> ActivityItem
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
        db = Database.database().reference().child("model")        
    }
    
    func fetch() {
        db?.observe(DataEventType.value, with: { (snapshot) in
            
            //if the reference have some values
            if snapshot.childrenCount > 0 {
                
                //clearing the list
                self.items.removeAll()
                
                //iterating through all the values
                for item in snapshot.children.allObjects as! [DataSnapshot] {
                    //getting values
                    let object = item.value as? [String: AnyObject]
                    let name  = object?["name"]
                    let timestamp  = object?["timestamp"]
                    let duration = object?["duration"]
                    let id = object?["id"]
                    
                    //creating artist object with model and fetched values
                    let activityItem = ActivityItem(id: id as! String?, name: name as! String?, duration: duration as! String?, timestamp: timestamp as! String?)
                    
                    //appending it to list
                    self.items.append(activityItem)
                }
                
                //reloading the tableview
                self.itemsDidUpdate!()
            }
        })
    }
    
    func addItem(item: ActivityItem) {
        items.append(item)
        //generating a new key inside item
        //and also getting the generated key
        if let key = db?.childByAutoId().key {
            //creating item with the given values
            let artist = ["id":key,
                          "name": item.name,
                          "duration": item.duration,
                          "timestamp": item.timestamp
            ]
            
            //adding the artist inside the generated unique key
            db?.child(key).setValue(artist)
        }
    }
    
    func numberOfItems() -> Int {
        return items.count
    }
    
    func itemAtIndex(_ index: Int) -> ActivityItem {
        return items[index]
    }

    public func addTotificationBlock(_ block: @escaping () -> Void) {
        
    }
    
}

class ArtistModel {
    var id: String?
    var name: String?
    var genre: String?
    
    init(id: String?, name: String?, genre: String?){
        self.id = id
        self.name = name
        self.genre = genre
    }
}


struct ActivityItem: Codable {
    let id: String?
    let name: String?
    let timestamp: String?
    let duration: String?
    
    init(id: String?, name: String?, duration: String?, timestamp: String?) {
        self.name = name
        self.duration = duration
        self.timestamp = "12234"
        self.id = id
    }
}











