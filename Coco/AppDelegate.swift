//
//  AppDelegate.swift
//  Coco
//
//  Created by Hugo Prinsloo on 2018/03/31.
//  Copyright © 2018 Over. All rights reserved.
//

import UIKit
import Firebase
import WatchConnectivity

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    override init() {
        FirebaseApp.configure()
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        if WCSession.isSupported() {
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}

extension AppDelegate: WCSessionDelegate {
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "receivedWatchData"), object: self, userInfo: message)
    }
    
    
    //below 3 functions are needed to be able to connect to several Watches
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {}
    
    func sessionDidDeactivate(_ session: WCSession) {}
    
    func sessionDidBecomeInactive(_ session: WCSession) {}
}

extension WCSessionDelegate {
    func session(_ session: WCSession, didReceiveActivity activity: [ActivityItem]) {
    }
}

extension NotificationCenter {
    open func post(name aName: NSNotification.Name, object anObject: Any?, activity: [ActivityItem]? = nil) {
        
    }
}

