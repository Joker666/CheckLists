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
        handleFirstTime()
    }
    
    var indexOfSelectedCheckList: Int {
        get {
            return NSUserDefaults.standardUserDefaults().integerForKey("CheckListIndex")
        }
        set {
            NSUserDefaults.standardUserDefaults().setInteger(newValue, forKey: "CheckListIndex")
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
    
    func handleFirstTime() {
        if NSUserDefaults.standardUserDefaults().boolForKey("FirstTime") {
            let checkList = CheckList(name: "List")
            checkList.listId = 0
            lists.append(checkList)
            
            indexOfSelectedCheckList = 0
            NSUserDefaults.standardUserDefaults().setBool(false, forKey: "FirstTime")
        }
    }
    
    func registerDefaults() {
        let dictionary = ["CheckListIndex": -1, "FirstTime": true]
        
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
                
                sortCheckLists()
            }
        }
    }
    
    func sortCheckLists() {
        lists.sortInPlace({checkList1, checkList2 in return checkList1.name.localizedStandardCompare(checkList2.name) == NSComparisonResult.OrderedAscending})
    }
}
