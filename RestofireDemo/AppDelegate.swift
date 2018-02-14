//
//  AppDelegate.swift
//  RestofireDemo
//
//  Created by Rahul Katariya on 13/02/18.
//  Copyright © 2018 Rahul Katariya. All rights reserved.
//

import UIKit
import Restofire
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var persistentContainer: NSPersistentContainer!
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        Restofire.Configuration.default.host = "private-07c21-rahulkatariya.apiary-mock.com"
        Restofire.Configuration.default.headers = ["Content-Type": "application/json"]
        
        persistentContainer = NSPersistentContainer(name: "Notes")
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        persistentContainer.persistentStoreDescriptions = [description]
        persistentContainer.loadPersistentStores() { _, _ in
            NotesGetAllService(context: self.persistentContainer.viewContext).execute()
        }
        if let navController = window?.rootViewController as? UINavigationController {
            if let notesTVC = navController.topViewController as? NotesTableViewController {
                notesTVC.persistentContainer = self.persistentContainer
            }
        }
        
        return true
    }

}

extension Restofire.DataResponseSerializable where Response: Decodable {
    
    public var responseSerializer: DataResponseSerializer<Response> {
        return DataRequest.JSONDecodableResponseSerializer()
    }
    
}
