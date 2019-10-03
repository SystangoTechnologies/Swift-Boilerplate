//
//  AppSettingsManager.swift
//  Skeleton
//
//  Created by Systango on 01/06/17.
//  Copyright © 2017 Systango. All rights reserved.
//

import UIKit

class AppSettingsManager: NSObject {
    var appSettings: AppSettings
    
    static let sharedInstance = AppSettingsManager()
    
    override init() {
        appSettings = AppSettings()
        super.init()
    }
    
    func fetchSettings() -> AppSettings {
        // Find out the path of AppSettings.plist
        if let path: String = Bundle.main.path(forResource: "AppSettings", ofType: "plist") {
            // Load the file content and initialise the AppSettings obj
            if let dict = NSDictionary(contentsOfFile: path) as? [String : Any] {
                appSettings = AppSettings(dictionary: dict)
            }
        }
        return appSettings
    }
    
    /*
     let path = Bundle.main().pathForResource("DefaultSiteList", ofType: "plist")!
     let url = URL(fileURLWithPath: path)
     let data = try! Data(contentsOf: url)
     let plist = try! PropertyListSerialization.propertyList(from: data, options: .mutableContainers, format: nil)
     */
    
    
}
