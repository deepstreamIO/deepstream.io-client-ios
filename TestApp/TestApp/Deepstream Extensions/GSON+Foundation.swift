//
//  GSON+Foundation.swift
//  TestApp
//
//  Created by Akram Hussein on 18/12/2016.
//
//

import Foundation

// MARK: - Foundation -> GSON

extension Array where Element : Any {
    var jsonElement : JsonArray {
        get {
            let data = try! JSONSerialization.data(withJSONObject: self, options: [])
            let json = String(data: data, encoding: String.Encoding.utf8)
            return Gson().fromJson(with: json, with: JsonArray_class_()) as! JsonArray
        }
    }
}

extension Dictionary where Key: ExpressibleByStringLiteral {
    var jsonElement : JsonObject {
        get {
            let data = try! JSONSerialization.data(withJSONObject: self, options: [])
            let json = String(data: data, encoding: String.Encoding.utf8)
            return Gson().fromJson(with: json, with: JsonObject_class_()) as! JsonObject
        }
    }
}

// MARK: - GSON -> Foundation

extension JsonObject {
    static let gson = GsonBuilder().enableComplexMapKeySerialization().create()
    var dict : [String : Any] {
        get {
            let serialized = JsonObject.gson?.toJson(with: self)
            let data = serialized!.data(using: .utf8)
            return try! JSONSerialization.jsonObject(with: data!, options: []) as! [String : Any]
        }
    }
}
