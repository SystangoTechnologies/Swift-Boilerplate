//
//  DictionaryExtensions.swift
//  SwifterSwift
//
//  Created by Omar Albeik on 8/24/16.
//  Copyright © 2016 Omar Albeik. All rights reserved.
//

import Foundation


// MARK: - Methods
public extension Dictionary {
	
	/// SwifterSwift: Check if key exists in dictionary.
	///
	/// - Parameter key: key to search for
	/// - Returns: true if key exists in dictionary.
    func has(key: Key) -> Bool {
		return index(forKey: key) != nil
	}
	
    /// SwifterSwift: Remove all keys of the dictionary.
    ///
    /// - Parameter keys: keys to be removed
    mutating func removeAll(keys: [Key]) {
        keys.forEach({ removeValue(forKey: $0)})
    }
    
	/// SwifterSwift: JSON Data from dictionary.
	///
	/// - Parameter prettify: set true to prettify data (default is false).
	/// - Returns: optional JSON Data (if applicable).
    func jsonData(prettify: Bool = false) -> Data? {
		guard JSONSerialization.isValidJSONObject(self) else {
			return nil
		}
		let options = (prettify == true) ? JSONSerialization.WritingOptions.prettyPrinted : JSONSerialization.WritingOptions()
		return try? JSONSerialization.data(withJSONObject: self, options: options)
	}
	
	/// SwifterSwift: JSON String from dictionary.
	///
	/// - Parameter prettify: set true to prettify string (default is false).
	/// - Returns: optional JSON String (if applicable).
    func jsonString(prettify: Bool = false) -> String? {
		guard JSONSerialization.isValidJSONObject(self) else {
			return nil
		}
		let options = (prettify == true) ? JSONSerialization.WritingOptions.prettyPrinted : JSONSerialization.WritingOptions()
		let jsonData = try? JSONSerialization.data(withJSONObject: self, options: options)
		return jsonData?.string(encoding: .utf8)
	}
    
}

// MARK: - Operators

public extension Dictionary {
    
    /// SwifterSwift: Merge the keys/values of two dictionaries.
    ///
    /// - Parameters:
    ///   - lhs: dictionary
    ///   - rhs: dictionary
    /// - Returns: An dictionary with keys and values from both.
    static func +(lhs: [Key: Value], rhs: [Key: Value]) -> [Key: Value] {
        var result = lhs
        rhs.forEach{ result[$0] = $1 }
        return result
    }
    
    // MARK: - Operators
    
    /// SwifterSwift: Append the keys and values from the second dictionary into the first one.
    ///
    /// - Parameters:
    ///   - lhs: dictionary
    ///   - rhs: dictionary
    static func +=(lhs: inout [Key: Value], rhs: [Key: Value]) {
        rhs.forEach({ lhs[$0] = $1})
    }
    
    
    /// SwifterSwift: Remove contained in the array from the dictionary
    ///
    /// - Parameters:
    ///   - lhs: dictionary
    ///   - rhs: array with the keys to be removed.
    /// - Returns: a new dictionary with keys removed.
    static func -(lhs: [Key: Value], keys: [Key]) -> [Key: Value]{
        var result = lhs
        result.removeAll(keys: keys)
        return result
    }
    
    /// SwifterSwift: Remove contained in the array from the dictionary
    ///
    /// - Parameters:
    ///   - lhs: dictionary
    ///   - rhs: array with the keys to be removed.
    static func -=(lhs: inout [Key: Value], keys: [Key]) {
        lhs.removeAll(keys: keys)
    }

}


// MARK: - Methods (ExpressibleByStringLiteral)
public extension Dictionary where Key: ExpressibleByStringLiteral {
	
	/// SwifterSwift: Lowercase all keys in dictionary.
    mutating func lowercaseAllKeys() {
		// http://stackoverflow.com/questions/33180028/extend-dictionary-where-key-is-of-type-string
		for key in keys {
			if let lowercaseKey = String(describing: key).lowercased() as? Key {
				self[lowercaseKey] = removeValue(forKey: key)
			}
		}
	}
	
}

//MARK:- Dictionary

extension Dictionary {
    //extension Dictionary where Key == String
    
    func getString(forKey key: Key, pointValue val: Int = 2, defaultValue def: String = "") -> String {
        if let str = self[key] as? String {
            return str
        } else if let num = self[key] as? NSNumber {
            let doubleVal = Double(truncating: num)
            return String(format: "%0.\(val)f", doubleVal)
        }
        return def
    }
    
    func getFloat(forKey key: Key, defaultValue def: Float = 0.0) -> Float {
        if let num = self[key] as? Float {
            return num
        } else if let str = self[key] as? String {
            if let val = Float(str) {
                return val
            }
        } else if let num = self[key] as? NSNumber {
            return Float(truncating: num)
        }
        return def
    }
    
    func getDouble(forKey key: Key, defaultValue def: Double = 0.0) -> Double {
        if let num = self[key] as? Double {
            return num
        } else if let str = self[key] as? String {
            if let val = Double(str) {
                return val
            }
        } else if let num = self[key] as? NSNumber {
            return Double(truncating: num)
        }
        return def
    }
    
    func getInt(forKey key: Key, defaultValue def: Int = 0) -> Int {
        if let num = self[key] as? Int {
            return num
        } else if let str = self[key] as? String {
            if let val = Int(str) {
                return val
            }
        } else if let num = self[key] as? NSNumber {
            return Int(truncating: num)
        }
        return def
    }
    
    func getBool(forKey key: Key, defaultValue def: Bool = false) -> Bool {
        if let val = self[key] as? Bool {
            return val
        } else if let num = self[key] as? NSNumber {
            if num == 0 {
                return false
            } else if num == 1 {
                return true
            }
        } else if let str = self[key] as? String {
            if str.lowercased() == "true" || str.lowercased() == "yes" {
                return true
            } else if str.lowercased() == "false" || str.lowercased() == "no" {
                return false
            }
        }
        return def
    }
    
    func getArray(forKey key: Key, components separatedBy: String? = nil, defaultValue def: Array<Any> = []) -> Array<Any> {
        if let arr = self[key] as? Array<Any> {
            return arr
        } else if let str = self[key] as? String {
            if let separated = separatedBy {
                return str.components(separatedBy: separated)
            }
        }
        return def
    }
    
    func getDictionay(forKey key: Key, defaultValue def: Dictionary = [:]) -> Dictionary {
        if let dict = self[key] as? Dictionary {
            return dict
        } else if let str = self[key] as? String {
            if let data = str.data(using: .utf8) {
                if let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []) {
                    if let dict = jsonObject as? Dictionary {
                        return dict
                    }
                }
            }
        }
        return def
    }
    
    func getNSDictionary(forKey key: Key, defaultValue def: NSDictionary = NSDictionary()) -> NSDictionary {
        if let dict = self[key] as? NSDictionary {
            return dict
        } else if let str = self[key] as? String {
            if let data = str.data(using: .utf8) {
                if let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []) {
                    if let dict = jsonObject as? NSDictionary {
                        return dict
                    }
                }
            }
        }
        return def
    }
    
    func getNSArray(forKey key: Key, components separatedBy: String? = nil, defaultValue def: NSArray = NSArray()) -> NSArray {
        if let arr = self[key] as? NSArray {
            return arr
        } else if let str = self[key] as? String {
            if let separated = separatedBy {
                return str.components(separatedBy: separated) as NSArray
            }
        }
        return def
    }
}
