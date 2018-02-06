//
//  Util.swift
//  Skeleton
//
//  Created by Systango on 01/06/17.
//  Copyright © 2017 Systango. All rights reserved.
//

import Foundation

class Util {
    public static func postNotification(name: String, dict: Dictionary<String, Any>)
    {
        let notification: Notification = Notification.init(name: Notification.Name(rawValue: name), object: nil, userInfo: dict) as Notification
        NotificationCenter.default.post(notification)
    }
}
