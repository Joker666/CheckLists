//
//  CheckList.swift
//  CheckLists
//
//  Created by Hasan Rafi on 12/18/15.
//  Copyright © 2015 Hasan Rafi. All rights reserved.
//

import Foundation

class CheckList: NSObject, NSCoding {
    var name = ""
    var id : Int32 = 0
    var items = [CheckListItem]()
    
    init(name: String) {
        self.name = name
        super.init()
    }
    
    required init(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObjectForKey("Name") as! String
        items = aDecoder.decodeObjectForKey("Items") as! [CheckListItem]
        self.id = aDecoder.decodeInt32ForKey("Id")
        
        super.init()
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(name, forKey: "Name")
        aCoder.encodeInt32(self.id, forKey: "Id")
        aCoder.encodeObject(items, forKey: "Items")
    }
    
    func countUncheckedItems() -> Int {
        return items.reduce(0, combine: {count, item in count + (item.checked ? 0 : 1)})
    }
}