//
//  AppSettings.swift
//  Skeleton
//
//  Created by Systango on 01/06/17.
//  Copyright © 2017 Systango. All rights reserved.
//

import UIKit
//import JSONModel

class AppSettings: NSObject {
    var NetworkMode: String = ""
    var LocalURL: String = ""
    var ProductionURL: String = ""
    var StagingURL: String = ""
    var URLPathSubstring: String = ""
    var EnableSecureConnection: Bool = false
    var EnablePullToRefresh: Bool = false
    var EnableBanner: Bool = false
    var EnableCoreData: Bool = false
    var EnableTwitter: Bool = false
    var EnableFacebook: Bool = false
    
    override init() {
        super.init()
    }
    
    convenience init(dictionary: [String: Any]) {
        self.init()
        NetworkMode = dictionary.getString(forKey: "NetworkMode")
        LocalURL = dictionary.getString(forKey: "LocalURL")
        ProductionURL = dictionary.getString(forKey: "ProductionURL")
        StagingURL = dictionary.getString(forKey: "StagingURL")
        URLPathSubstring = dictionary.getString(forKey: "URLPathSubstring")
        EnableSecureConnection = dictionary.getBool(forKey: "EnableSecureConnection")
        EnablePullToRefresh = dictionary.getBool(forKey: "EnablePullToRefresh")
        EnableBanner = dictionary.getBool(forKey: "EnableBanner")
        EnableCoreData = dictionary.getBool(forKey: "EnableCoreData")
        EnableTwitter = dictionary.getBool(forKey: "EnableTwitter")
        EnableFacebook = dictionary.getBool(forKey: "EnableFacebook")
    }
}
