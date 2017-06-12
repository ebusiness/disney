//
//  CoreData.swift
//  disney
//
//  Created by ebuser on 2017/6/12.
//  Copyright © 2017年 e-business. All rights reserved.
//

import CoreData
import UIKit

class DataManager {
    static let shared: DataManager = {
        let instance = DataManager()
        return instance
    }()

    func save() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        appDelegate.saveContext()
    }

    lazy var context: NSManagedObjectContext = {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { fatalError() }
        return appDelegate.managedObjectContext
    }()

    func randomID() -> String {
        let uuid = UUID()
        return uuid.uuidString
    }
}
