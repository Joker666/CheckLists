//
//  CheckList.swift
//  CheckLists
//
//  Created by Hasan Rafi on 12/18/15.
//  Copyright © 2015 Hasan Rafi. All rights reserved.
//

import Foundation

class CheckList: NSObject {
    var name = ""
    
    init(name: String) {
        self.name = name
        super.init()
    }
}