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
import WatchConnectivity


protocol StatusDatabase {
    func addItem(item: ActivityItem)
    func itemAtIndex(_ index: Int) -> ActivityItem
}

class CocoDatabase: StatusDatabase {
    
    let watchSession = WCSession.default

    private var items: [ActivityItem] = [] {
        didSet {
        }
    }
    
    private var itemsToWatch: [String?] = []
    

    
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
                self.itemsToWatch.removeAll()
                
                //iterating through all the values
                for item in snapshot.children.allObjects as! [DataSnapshot] {
                    //getting values
                    let object = item.value as? [String: String]
                    let name  = object?["name"]
                    let duration = object?["duration"]
                    let id = object?["id"]
                    
                    //creating artist object with model and fetched values
                    let activityItem = ActivityItem(id: id, name: name, duration: duration)
                    
                    //appending it to list
                    self.items.append(activityItem)
                    self.itemsToWatch.append(activityItem.name)
                }
                
                //reloading the tableview
                self.itemsDidUpdate!()
                self.sendToWatch()
            }
        })
        

    }
    
    func sendToWatch() {
        do {
            let applicationDict = ["Array1": itemsToWatch]
            try watchSession.updateApplicationContext(applicationDict)
        }
            
        catch {
            print(error)
        }
    }
    
    
    func prepareForWatch(_ activityItems: [[String: String]]) {
        for item in activityItems {
            
        }
    }
    
    func addItem(item: ActivityItem) {
        items.append(item)
        //generating a new key inside item
        //and also getting the generated key
        if let key = db?.childByAutoId().key {
            //creating item with the given values
            let activity = ["id":key,
                          "name": item.name,
                          "duration": item.duration,
            ]
            
            //adding the artist inside the generated unique key
            db?.child(key).setValue(activity)
        }
    }
    
    func numberOfItems() -> Int {
        return items.count
    }
    
    func itemAtIndex(_ index: Int) -> ActivityItem {
        return items[index]
    }
}

//extension CocoDatabase: WCSessionDelegate {
//
//    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
//        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "receivedWatchData"), object: self, userInfo: message)
//    }
//
//
//    //below 3 functions are needed to be able to connect to several Watches
//    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {}
//
//    func sessionDidDeactivate(_ session: WCSession) {}
//
//    func sessionDidBecomeInactive(_ session: WCSession) {}
//}



public struct ActivityItem: Codable {
    let id: String?
    let name: String?
    let duration: String?
    
    init(id: String?, name: String?, duration: String?) {
        self.name = name
        self.duration = duration
        self.id = id
    }
}










