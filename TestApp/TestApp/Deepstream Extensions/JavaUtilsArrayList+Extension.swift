//
//  JavaUtilsArrayList+Extension.swift
//  TestApp
//
//  Created by Akram Hussein on 17/12/2016.
//  Copyright (c) 2016 deepstreamHub GmbH. All rights reserved.
//

import Foundation

extension JavaUtilArrayList {
    
    func toNSArray<T>() -> [T] {
        var arr:[T] = []
        for i : Int32 in 0 ..< self.size() {
            arr.append(self.getWith(i) as! T)
        }
        return arr
    }
}


