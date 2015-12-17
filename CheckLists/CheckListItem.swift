//
// Created by Hasan Rafi on 12/2/15.
// Copyright (c) 2015 Hasan Rafi. All rights reserved.
//

import Foundation

class CheckListItem : NSObject, NSCoding {
    var id = 0
    var text = ""
    var checked = false

    func toggleChecked() {
        checked = !checked
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(text, forKey: "Text")
        aCoder.encodeBool(checked, forKey: "Checked")
    }
    
    required init(coder aDecoder: NSCoder) {
        text = aDecoder.decodeObjectForKey("Text") as! String
        checked = aDecoder.decodeBoolForKey("Checked")
        super.init()
    }
    
    override init() {
        super.init()
    }
}
