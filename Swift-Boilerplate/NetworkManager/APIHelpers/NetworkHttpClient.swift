//
//  NetworkHttpClient.swift
//  Skeleton
//
//  Created by Systango on 31/05/17.
//  Copyright © 2017 Systango. All rights reserved.
//

import UIKit
import AFNetworking

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

class NetworkHttpClient: NSObject {
    
    typealias SuccessBlock = (_ dataTask: Any?,_ response: Any?) -> Void
    typealias FailureBlock = (_ dataTask: Any?,_ error: Any?) -> Void
    
    static let sharedInstance = NetworkHttpClient()
    
    var urlPathSubstring: String = ""
    
    override init() {
        let appSettings: AppSettings = AppSettingsManager.sharedInstance.fetchSettings()
        urlPathSubstring = appSettings.URLPathSubstring
        
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: BASE URL
    class func baseUrl() -> String {
        let appSettings: AppSettings = AppSettingsManager.sharedInstance.appSettings
        
        let secureConnection: String = appSettings.EnableSecureConnection ? Constants.SecureProtocol : Constants.InsecureProtocol
        if appSettings.NetworkMode == Constants.LiveEnviroment { // for live env
            return String.init(format: "%@%@", secureConnection, appSettings.ProductionURL)
        } else if appSettings.NetworkMode == Constants.StagingEnviroment { // for staging env
            return String.init(format: "%@%@", secureConnection, appSettings.StagingURL)
        } else { // for local env
            return String.init(format: "%@%@", secureConnection, appSettings.LocalURL)
        }
    }
    
    // MARK: API calls with
    
    func getAPICall(_ strURL : String, parameters : Dictionary<String, Any>?, headers : [String : String]?, success:@escaping SuccessBlock, failure:@escaping FailureBlock) {
        
        performAPICallWith(strURL, methodType: .get, parameters: parameters, headers: headers, success: success, failure: failure)
    }
    
    func postAPICall(_ strURL : String, parameters : Dictionary<String, Any>?, headers : [String : String]?, success:@escaping SuccessBlock, failure:@escaping FailureBlock) {
        
        performAPICallWith(strURL, methodType: .post, parameters: parameters, headers: headers, success: success, failure: failure)
    }
    
    func putAPICall(_ strURL : String, parameters : Dictionary<String, Any>?, headers : [String : String]?, success:@escaping SuccessBlock, failure:@escaping FailureBlock) {
        
        performAPICallWith(strURL, methodType: .put, parameters: parameters, headers: headers, success: success, failure: failure)
    }
    
    func deleteAPICall(_ strURL : String, parameters : Dictionary<String, Any>?, headers : [String : String]?, success:@escaping SuccessBlock, failure:@escaping FailureBlock) {
        
        performAPICallWith(strURL, methodType: .delete, parameters: parameters, headers: headers, success: success, failure: failure)
    }
    
    func performAPICallWith(_ strURL : String, methodType: HTTPMethod, parameters : Dictionary<String, Any>?, headers : [String : String]?, success:@escaping SuccessBlock, failure:@escaping FailureBlock){
        
        let afSessionManager = AFHTTPSessionManager()//(sessionConfiguration:urlConfigurator)
        
        let requestSerializer = AFJSONRequestSerializer()
        if (headers != nil){
            for (offset: _,element: (key: key,value: value)) in (headers?.enumerated())! {
                requestSerializer.setValue(value, forHTTPHeaderField: key)
            }
            afSessionManager.requestSerializer = requestSerializer;
        }
        let responseSerialization = AFJSONResponseSerializer()
        let contentTypes: Set<String> = ["text/html", "application/json"]
        responseSerialization.acceptableContentTypes = contentTypes
        
        switch methodType {
        case .get:
            afSessionManager.get(strURL, parameters: parameters, progress: nil, success: { (urlDataTask, urlResponse) in
                success(urlDataTask,urlResponse)
            }, failure: { (urlDataTask, error) in
                failure(urlDataTask, error)
            })
        case .post:
            afSessionManager.post(strURL, parameters: parameters, progress: nil, success: { (urlDataTask, urlResponse) in
                success(urlDataTask,urlResponse)
            }, failure: { (urlDataTask, error) in
                failure(urlDataTask, error)
            })
        case .put:
            afSessionManager.put(strURL, parameters: parameters, success: { (urlDataTask, urlResponse) in
                success(urlDataTask,urlResponse)
            }, failure: { (urlDataTask, error) in
                failure(urlDataTask, error)
            })
        case .delete:
            afSessionManager.delete(strURL, parameters: parameters, success: { (urlDataTask, urlResponse) in
                success(urlDataTask,urlResponse)
            }, failure: { (urlDataTask, error) in
                failure(urlDataTask, error)
            })
            break
        }
    }
    
    
    func multipartPostAPICall(_ strURL: String, parameters: Dictionary<String, Any>?, headers : [String : String]?, data: Data, name: String, fileName: String, mimeType: String, progress: ProgressBlock?, success:@escaping SuccessBlock, failure:@escaping FailureBlock) -> Void {
        /*
        let request: URLRequest = AFHTTPRequestSerializer().multipartFormRequest(withMethod: "POST", urlString: strURL, parameters: parameters, constructingBodyWith: { (formData) in
            formData.appendPart(withFileData: data, name: name, fileName: fileName, mimeType: mimeType)
        }, error: nil) as URLRequest
        
        let manager: AFURLSessionManager = AFHTTPSessionManager(sessionConfiguration: URLSessionConfiguration.default)
        
        let uploadTask = manager.uploadTask(withStreamedRequest: request, progress: progress) { (response, responseObject, error) in
            
            if let error = error {
                failure(response, error)
            } else {
                success(response, responseObject)
            }
            
        }
        
        uploadTask.resume()
        */
        
        let afSessionManager = AFHTTPSessionManager()//(sessionConfiguration:urlConfigurator)
        
        let requestSerializer = AFJSONRequestSerializer()
        if (headers != nil){
            for (offset: _,element: (key: key,value: value)) in (headers?.enumerated())! {
                requestSerializer.setValue(value, forHTTPHeaderField: key)
            }
            afSessionManager.requestSerializer = requestSerializer;
        }
        let responseSerialization = AFJSONResponseSerializer()
        let contentTypes: Set<String> = ["text/html", "application/json"]
        responseSerialization.acceptableContentTypes = contentTypes
        
        afSessionManager.post(strURL, parameters: parameters, constructingBodyWith: { (formData) in
            formData.appendPart(withFileData: data, name: name, fileName: fileName, mimeType: mimeType)
        }, progress: progress, success: { (urlDataTask, urlResponse) in
            success(urlDataTask, urlResponse)
        }) { (urlDataTask, error) in
            failure(urlDataTask, error)
        }
    }
    
}
