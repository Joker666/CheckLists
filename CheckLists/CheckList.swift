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
    var listId = 0
    var iconName: String
    var items = [CheckListItem]()
    
    convenience init(name: String) {
        self.init(name: name, iconName: "No Icon")
    }
    
    init(name: String, iconName: String) {
        self.name = name
        self.iconName = iconName
        super.init()
    }
    
    required init(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObjectForKey("Name") as! String
        items = aDecoder.decodeObjectForKey("Items") as! [CheckListItem]
        listId = aDecoder.decodeIntegerForKey("ListId")
        iconName = aDecoder.decodeObjectForKey("IconName") as! String
        
        super.init()
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(name, forKey: "Name")
        aCoder.encodeInteger(listId, forKey: "ListId")
        aCoder.encodeObject(iconName, forKey: "IconName")
        aCoder.encodeObject(items, forKey: "Items")
    }
    
    func countUncheckedItems() -> Int {
        return items.reduce(0, combine: {count, item in count + (item.checked ? 0 : 1)})
    }
}