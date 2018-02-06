//
//  CategoryInterface.swift
//  Skeleton
//
//  Created by Systango on 05/06/17.
//  Copyright © 2017 Systango. All rights reserved.
//

import UIKit

class CategoryInterface: NSObject {
    
//    var block: CompletionHandler = { _,_ in }
//    public func getCategories(request: CategoryRequest, completion: @escaping CompletionHandler) -> Void {
//        block = completion
//        let apiInteractorProvider = APIInteractorProvider.sharedInstance.getAPIInetractor()
//        apiInteractorProvider.postObject(request: request) { (success, response) in
//            self.parseSuccessResponse(response: response)
//        }
//    }
//    
//    // MARK: Parse Response
//
//    func parseSuccessResponse(response: Any?) -> Void {
//        if response is Dictionary<String, Any> {
//            var success: String? = nil
//            let responseDict = response as! Dictionary<String, Any>
//            
//            if responseDict["response"] != nil {
//                let categories = responseDict["response"] as! Array<Any>
//                var categoryList: Array = [CategoryEntity]()
//                for dict in categories {
//                    let category: CategoryEntity = CategoryEntity.getCategoryForResponse(dict)
//                    categoryList.append(category)
//                }
//                block(true, categoryList as Any)
//            } else {
//                var errorMessage: String? = nil
//                if responseDict["msg"] != nil {
//                    errorMessage = responseDict["msg"] as? String
//                }
//                block(Bool(success!)!, errorMessage)
//            }
//        } else if response is Error {
//            var errorMessage: String? = (response as! Error).localizedDescription
//            block(false, errorMessage!)
//        } else {
//            block(false, nil)
//        }
//    }
}
