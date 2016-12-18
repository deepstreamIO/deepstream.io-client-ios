//
//  JavaUtilsArrayList+Extension.swift
//  TestApp
//
//  Created by Akram Hussein on 17/12/2016.
//  Copyright (c) 2016 deepstreamHub GmbH. All rights reserved.
//

import Foundation

extension JavaUtilArrayList {
    
    func toArray<T>() -> [T] {
        var arr:[T] = []
        for i : Int32 in 0 ..< self.size() {
            arr.append(self.getWith(i) as! T)
        }
        return arr
    }
}

extension Array where Element : Any {
    var toJavaArray : JavaUtilArrayList {
        get {
            let arrayList : JavaUtilArrayList = JavaUtilArrayList(int: jint(self.count))
            self.forEach({ arrayList.add(withId: $0) })
            return arrayList
        }
    }
}


