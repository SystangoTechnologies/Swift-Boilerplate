//
//  Request.swift
//  Skeleton
//
//  Created by Systango on 29/05/17.
//  Copyright © 2017 Systango. All rights reserved.
//

import UIKit

class Request: NSObject {

    var urlPath: String
    var requestType: NSInteger
    var fileData: Data
    var dataFilename: String
    var fileName: String
    var mimeType: String
    var headers: [String: String]?
    var parameters: Dictionary<String, Any>
    
    override init() {
        urlPath = ""
        requestType = 0
        fileData = Data()
        dataFilename = ""
        fileName = ""
        mimeType = ""
        parameters = [:]
        super.init()
    }
    
    public func getParams() -> Dictionary<String, Any> {
        return parameters
    }
    
    public class func getUrl(path: String) -> String {
        let client: NetworkHttpClient = NetworkHttpClient.sharedInstance
        return String.init(format: "%@%@",client.urlPathSubstring, path)
    }
    
    public func appendDeviceTokenWith(url: String?) -> String {
        var editedUrlString: String = Constants.EmptyString
        let deviceTokenString: String = UserDefaults.standard.value(forKey: Constants.UserDefaultsDeviceTokenKey) as! String
        
        if !String.isNilOrEmpty(string: deviceTokenString) {
            editedUrlString = String.init(format: "%@/%@", url!, deviceTokenString)
        }
        
        return editedUrlString
    }
    
    public func initForDeviceRegistration() -> Any {
        var deviceToken: String = ""
        deviceToken = UserDefaults.value(forKey: Constants.UserDefaultsDeviceTokenKey) as! String
        
        parameters = [:]
        parameters[Constants.DeviceTokenKey] = deviceToken
        parameters[Constants.DeviceInfoKey] = "deviceTestInfo:iPhone6"
        parameters[Constants.DeviceTypeKey] = "iOS"
        
        urlPath = Request.getUrl(path:"kRegisterDeviceURL")
        return self
    }
}
