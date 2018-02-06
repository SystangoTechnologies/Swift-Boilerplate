//
//  Constants.swift
//  Skeleton
//
//  Created by Systango on 01/06/17.
//  Copyright © 2017 Systango. All rights reserved.
//

import Foundation
import UIKit

let ApplicationDelegate = UIApplication.shared.delegate as! AppDelegate
typealias CompletionHandler = (_ success: Bool, _ response: Any?) -> Void
typealias ProgressBlock = ((Progress) -> Void)

struct Constants {

    // MARK: General Constants
    static let DeviceTokenKey = "device_token"
    static let DeviceInfoKey = "device_info"
    static let DeviceTypeKey = "device_type"
    static let EmptyString = ""
    
    // MARK: User Defaults
    static let UserDefaultsDeviceTokenKey = "DeviceTokenKey"
    
    // MARK: Enums
    enum RequestType: NSInteger {
        case GET
        case POST
        case MultiPartPost
        case DELETE
        case PUT
    }
    
    // MARK: Numerical Constants
    static let StatusSuccess = 1
    static let ResponseStatusSuccess = 200
    static let ResponseStatusCreated = 201
    static let ResponseStatusAccepted = 202
    static let ResponseStatusNoResponse = 204
    static let ResponseStatusForbidden = 401
    static let ResponseStatusAleradyExist = 409
    static let ResponseStatusEmailNotFound = 422
    static let ResponseStatusServerError = 500
    static let ResponseInvalidCredential = 401
    static let ResponseStatusUserNotExist = 404
    
    // MARK: Network Keys
    static let InsecureProtocol = "http://"
    static let SecureProtocol = "https://"
    static let LocalEnviroment = "LOCAL"
    static let StagingEnviroment = "STAGING"
    static let LiveEnviroment = "LIVE"
    
    
    static let kMessageInternalServer = "Internal Server Error"
    static let kMessageInvalidCredential = "Invalid Credential"
}
//typedef void (^completionBlock)(BOOL success, id response);
