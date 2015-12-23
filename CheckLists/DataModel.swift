//
//  DataModel.swift
//  CheckLists
//
//  Created by Hasan Rafi on 12/23/15.
//  Copyright © 2015 Hasan Rafi. All rights reserved.
//

import Foundation

class DataModel {
    var lists = [CheckList]()
    
    init() {
        loadChecklists()
        registerDefaults()
    }
    
    var indexOfSelectedCheckList: Int {
        get {
            return NSUserDefaults.standardUserDefaults().integerForKey("CheckListIndex")
        }
        set {
            NSUserDefaults.standardUserDefaults().setInteger(newValue, forKey: "CheckListIndex")
        }
    }
    
    func registerDefaults() {
        let dictionary = ["CheckListIndex": -1]
        
        NSUserDefaults.standardUserDefaults().registerDefaults(dictionary)
    }
    
    func documentsDirectory() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as [String]
        return paths[0]
    }
    
    func dataFilePath() -> String {
        return documentsDirectory().NS.stringByAppendingPathComponent( "Checklists.plist")
    }
    
    func saveChecklists() {
        let data = NSMutableData()
        let archiver = NSKeyedArchiver(forWritingWithMutableData: data)
        archiver.encodeObject(lists, forKey: "Checklists")
        archiver.finishEncoding()
        data.writeToFile(dataFilePath(), atomically: true)
    }
    
    func loadChecklists() {
        let path = dataFilePath()
        if NSFileManager.defaultManager().fileExistsAtPath(path) {
            if let data = NSData(contentsOfFile: path) {
                let unarchiver = NSKeyedUnarchiver(forReadingWithData: data)
                lists = unarchiver.decodeObjectForKey("Checklists") as! [CheckList]
                unarchiver.finishDecoding()
            }
        }
    }
}
