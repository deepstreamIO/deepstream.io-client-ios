//
//  JsonElement+Foundation.swift
//  TestApp
//
//  Created by Akram Hussein on 18/12/2016.
//
//

import Foundation

//extension JsonElement {
//    private static let gson = GsonBuilder().enableComplexMapKeySerialization().create()
//    
//    var dict : [String : Any] {
//        get {
//            let serialize = JsonElement.gson?.toJson(with: self)
//        }
//    }
//}

// Json Object -> Dictionary
// Json Array -> Array
// Diction -> Object
// Array -> JsonArray

extension Array where Element : Any {
    var jsonElement : JsonArray {
        get {
            let data = try! JSONSerialization.data(withJSONObject: self, options: [])
            let json = String(data: data, encoding: String.Encoding.utf8)
            return Gson().fromJson(with: json, with: JsonArray_class_()) as! JsonArray
        }
    }
}
