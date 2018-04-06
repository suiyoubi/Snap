//
//  Utils.swift
//  snap
//
//  Created by Ao Tang on 2018-03-27.
//  Copyright © 2018 ece.ubc. All rights reserved.
//

import Foundation

class Utils {
    static func deleteQuote(s:String) -> String{
        let s1 = s.prefix(s.count - 1)
        let s2 = s1.suffix(s1.count - 1)
        return String(s2)
    }
}
