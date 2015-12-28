//
// Created by Hasan Rafi on 12/2/15.
// Copyright (c) 2015 Hasan Rafi. All rights reserved.
//

import Foundation

class CheckListItem : NSObject, NSCoding {
    var itemId = 0
    var text = ""
    var shouldRemind = false
    var dueDate = NSDate()
    var checked = false

    func toggleChecked() {
        checked = !checked
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(text, forKey: "Text")
        aCoder.encodeInteger(itemId, forKey: "ItemId")
        aCoder.encodeBool(checked, forKey: "Checked")
        aCoder.encodeObject(dueDate, forKey: "DueDate")
        aCoder.encodeBool(shouldRemind, forKey: "ShouldRemind")
    }
    
    required init(coder aDecoder: NSCoder) {
        text = aDecoder.decodeObjectForKey("Text") as! String
        checked = aDecoder.decodeBoolForKey("Checked")
        itemId = aDecoder.decodeIntegerForKey("ItemId")
        dueDate = aDecoder.decodeObjectForKey("DueDate") as! NSDate
        shouldRemind = aDecoder.decodeBoolForKey("ShouldRemind")
        super.init()
    }
    
    override init() {
        super.init()
    }
}
