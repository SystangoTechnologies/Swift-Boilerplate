//
//  RealAPI.swift
//  Skeleton
//
//  Created by Systango on 01/06/17.
//  Copyright © 2017 Systango. All rights reserved.
//

import UIKit
import SMobiLog
import ALAlertBanner
import AFNetworking

class RealAPI: NSObject, APIInteractor {
    
    var VMRequest: Request = Request()
    var isForbiddenRetry: Bool = false
    var realAPIBlock: CompletionHandler = { _,_ in }
    
    func initialSetup(request: Request, requestType: NSInteger) -> Void {
        VMRequest = request
        VMRequest.requestType = requestType
        //let message: String = String.init(format: "Info: Performing API call [Request:%@] with [URL:%@] [params: %@]", type(of: request) as! CVarArg, request.urlPath, request.getParams())
        //print(message)
    }
    
    func isForbiddenResponse(statusCode: NSInteger) -> Bool {
        if statusCode == Constants.ResponseStatusForbidden && isForbiddenRetry == false {
            isForbiddenRetry = true
            return true
        }
        return false
    }
    
    func renewLogin() -> Void {
        //User.sharedUser.resetSharedInstance()
        
        // login with saved values
        self.loginWithSavedValues()
    }
    
    func loginWithSavedValues() {
//        let userAuth: UserAuth? = UserAuth.getSavedAuth()
//        if userAuth {
//            if (userAuth.facebookId != nil && userAuth.facebookId.length) || (userAuth.password != nil && userAuth.password.length && userAuth.email != nil && userAuth.email.length) {
//                RequestManager.login(userAuth: userAuth, completion: { (success, response) in
//                    if success {
//                        User.sharedUser.saveLoggedinUserInfoInUserDefault()
//                        
//                        // Trigger last saved API call
//                        self.renewLoginRequestCompleted()
//                    } else {
//                        realAPIBlock(false, nil)
//                    }
//                })
//                return
//            }
//        }
//        realAPIBlock(false, nil)
//        
//        //*> Show Alert
//        ApplicationDelegate.showAlert(message:"Your session expire", isLogout:YES);
    }
    
//    func renewLoginRequestCompleted() {
//        // calling failed API again
//        switch VMRequest.requestType {
//        case Constants.RequestType.GET.rawValue:
//            self.interactAPIWithGetObject(request: VMRequest, completion: realAPIBlock)
//            break
//        case Constants.RequestType.POST.rawValue:
//            self.interactAPIWithPostObject(request: VMRequest, completion: realAPIBlock)
//            break
//        case Constants.RequestType.PUT.rawValue:
//            self.interactAPIWithPutObject(request: VMRequest, completion: realAPIBlock)
//            break
//        case Constants.RequestType.MultiPartPost.rawValue:
//            self.interactAPIWithMultipartObjectPost(request: VMRequest, completion: realAPIBlock)
//            break
//        case Constants.RequestType.DELETE.rawValue:
//            self.interactAPIWithDeleteObject(request: VMRequest, completion: realAPIBlock)
//            break
//        default:
//            break
//        }
//    }
    
    
    //MARK: - AFNetworking
    
    func getObject(request: Request, completion: @escaping CompletionHandler) {
        interactAPIWithGetObject(request: request, completion: completion)
    }
    
    func postObject(request: Request, completion: @escaping CompletionHandler) {
        interactAPIWithPostObject(request: request, completion: completion)
    }
    
    func putObject(request: Request, completion: @escaping CompletionHandler) {
        interactAPIWithPutObject(request: request, completion: completion)
    }
    
    func deleteObject(request: Request, completion: @escaping CompletionHandler) {
        interactAPIWithDeleteObject(request: request, completion: completion)
    }
    
    func multiPartObjectPost(request: Request, progress: ProgressBlock?, completion: @escaping CompletionHandler) -> Void {
        interactAPIWithMultipartObjectPost(request: request, progress: progress, completion: completion)
    }
    
    func interactAPIWithGetObject(request: Request, completion: @escaping CompletionHandler) -> Void {
        initialSetup(request: request, requestType: Constants.RequestType.GET.rawValue)
        NetworkHttpClient.sharedInstance.getAPICall(request.urlPath, parameters: request.getParams(), headers: request.headers, success: { (responseDataTask,responseObject) in
            self.handleSuccessResponse(response: responseObject, responseDataTask: responseDataTask, block: completion)
        }, failure: { (responseDataTask,error) in
            self.handleError(error: error as Any, responseDataTask: responseDataTask, block: completion)
        })
    }
    
    func interactAPIWithPutObject(request: Request, completion: @escaping CompletionHandler) -> Void {
        initialSetup(request: request, requestType: Constants.RequestType.PUT.rawValue)
        NetworkHttpClient.sharedInstance.putAPICall(request.urlPath, parameters: request.getParams(), headers: request.headers!, success: { (responseDataTask,responseObject) in
            self.handleSuccessResponse(response: responseObject, responseDataTask: responseDataTask, block: completion)
        }, failure: { (responseDataTask,error) in
            self.handleError(error: error as Any, responseDataTask: responseDataTask, block: completion)
        })
    }
    
    func interactAPIWithPostObject(request: Request, completion: @escaping CompletionHandler) -> Void {
        initialSetup(request: request, requestType: Constants.RequestType.POST.rawValue)
        NetworkHttpClient.sharedInstance.postAPICall(request.urlPath, parameters: request.getParams(), headers: request.headers, success: { (responseDataTask,responseObject) in
            self.handleSuccessResponse(response: responseObject, responseDataTask: responseDataTask, block: completion)
        }, failure: { (responseDataTask,error) in
            self.handleError(error: error as Any, responseDataTask: responseDataTask, block: completion)
        })
    }
    
    func interactAPIWithDeleteObject(request: Request, completion: @escaping CompletionHandler) -> Void {
        initialSetup(request: request, requestType: Constants.RequestType.DELETE.rawValue)
        NetworkHttpClient.sharedInstance.deleteAPICall(request.urlPath, parameters: request.getParams(), headers: request.headers, success: { (responseDataTask,responseObject) in
            self.handleSuccessResponse(response: responseObject, responseDataTask: responseDataTask, block: completion)
        }, failure: { (responseDataTask,error) in
            self.handleError(error: error as Any, responseDataTask: responseDataTask, block: completion)
        })
    }
    
    func interactAPIWithMultipartObjectPost(request: Request, progress: ProgressBlock?, completion: @escaping CompletionHandler) -> Void {
        initialSetup(request: request, requestType: Constants.RequestType.MultiPartPost.rawValue)
        
        NetworkHttpClient.sharedInstance.multipartPostAPICall(request.urlPath, parameters: request.getParams(), headers: request.headers, data: request.fileData, name: request.dataFilename, fileName: request.fileName, mimeType: request.mimeType, progress: progress, success: { (response, responseObject) in
            self.handleSuccessResponse(response: responseObject, block: completion)
        }) { (response, error) in
            self.handleError(error: error as Any, responseDataTask: response, block: completion)
        }
        
    }
    
    func handleSuccessResponse(response: Any?, responseDataTask: Any? = nil, block:@escaping CompletionHandler) -> Void {
        
        //use the below lines to get authorization from header in response
        /*
        if let dataTask = responseDataTask as? URLSessionDataTask {
            if let httpHeader = dataTask.response as? HTTPURLResponse {
                let authorization = httpHeader.allHeaderFields.getString(forKey: Constants.kAuthorization)
                if authorization.length > 0 {
                    UserDefaults.standard.setValue("Bearer \(authorization)", forKey: Constants.kAuthorization)
                }
            }
        }
         */
        
        if response != nil {
            isForbiddenRetry = false
            block(true, response)
        } else if let dataTask = responseDataTask as? URLSessionDataTask {
            if let networkError = dataTask.error as NSError? {
                self.handleError(error: networkError, responseDataTask: responseDataTask, block: block)
            } else {
                var errorMessage: String? = nil
                var errorCode = 0
                if let responseErrorData = (responseDataTask as? [AnyHashable: Any])?[AFNetworkingOperationFailingURLResponseDataErrorKey] as? Data, let responseString = String(data: responseErrorData, encoding: String.Encoding.utf8) {
                    errorMessage = responseString
                }
                if let httpResonseData = (responseDataTask as? [AnyHashable: Any])?[AFNetworkingOperationFailingURLResponseErrorKey] as! HTTPURLResponse?{
                    errorCode = httpResonseData.statusCode
                }
                
                if let httpResonseData = dataTask.response as? HTTPURLResponse {
                    errorCode = httpResonseData.statusCode
                }
                
                if errorCode == Constants.ResponseStatusCreated || errorCode == Constants.ResponseStatusAccepted {
                    block(true, errorMessage)
                    return
                } else if errorCode == Constants.ResponseStatusAleradyExist || errorCode == Constants.ResponseStatusEmailNotFound || errorCode == Constants.ResponseStatusSuccess {
                    block(false, errorMessage)
                    return
                } else if errorCode == Constants.ResponseStatusSuccess {
                    block(true, errorMessage)
                    return
                } else if errorCode == Constants.ResponseStatusNoResponse {
                    block(true, errorMessage)
                    return
                } else if errorCode == Constants.ResponseStatusUserNotExist {
                    block(false, errorMessage)
                    return
                } else if errorCode == Constants.ResponseInvalidCredential {
                    block(false, Constants.kMessageInvalidCredential)
                    return
                } else if errorCode == Constants.ResponseStatusServerError {
                    block(false, Constants.kMessageInternalServer)
                    return
                } else {
                    block(false, dataTask.error?.localizedDescription)
                    return
                }
            }
        } else {
            block(false,nil)
        }
    }
    
    func handleError(error: Any, responseDataTask: Any?, block: @escaping CompletionHandler) -> Void {
        let networkError = error as? NSError
        if (networkError != nil){
            var errorCode = 0
            var errorMessage = networkError?.localizedDescription
            if let userInfo = networkError?.userInfo as NSDictionary? {
                if let responseErrorData = userInfo.value(forKey: AFNetworkingOperationFailingURLResponseDataErrorKey) as? Data, let responseString = String(data: responseErrorData, encoding: String.Encoding.utf8) {
                    
                    errorMessage = responseString
                    
                }
                if let httpResonseData = userInfo.value(forKey: AFNetworkingOperationFailingURLResponseErrorKey) as! HTTPURLResponse?{
                    errorCode = httpResonseData.statusCode
                }
            }
            if self.isForbiddenResponse(statusCode:(networkError?.code)!) {
                realAPIBlock = block
                renewLogin()
                return
            } else if errorCode == Constants.ResponseStatusCreated || errorCode == Constants.ResponseStatusAccepted {
                block(true, errorMessage)
                return
            } else if errorCode == Constants.ResponseStatusAleradyExist || errorCode == Constants.ResponseStatusEmailNotFound {
                block(false, errorMessage)
                return
            } else if errorCode == Constants.ResponseStatusSuccess {
                block(true, errorMessage)
                return
            } else if errorCode == Constants.ResponseStatusUserNotExist {
                block(false, errorMessage)
                return
            } else if errorCode == Constants.ResponseInvalidCredential {
                block(false, Constants.kMessageInvalidCredential)
                return
            } else if errorCode == Constants.ResponseStatusServerError {
                block(false, Constants.kMessageInternalServer)
                return
            } else {
                block(false, networkError?.localizedDescription)
                return
            }
        }else{
            block(false, nil)
        }
        
    }
    
}
