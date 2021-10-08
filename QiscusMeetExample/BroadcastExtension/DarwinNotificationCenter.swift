//
//  DarwinNotificationCenter.swift
//  QiscusMeetExample
//
//  Created by Gustu on 19/07/21.
//  Copyright © 2021 qiscus. All rights reserved.
//

import Foundation

enum DarwinNotification: String {
    case broadcastStarted = "iOS_BroadcastStarted"
    case broadcastStopped = "iOS_BroadcastStopped"
}

class DarwinNotificationCenter {
    
    static var shared = DarwinNotificationCenter()
    
    private var notificationCenter: CFNotificationCenter
    
    init() {
        notificationCenter = CFNotificationCenterGetDarwinNotifyCenter()
    }
    
    func postNotification(_ name: DarwinNotification) {
        CFNotificationCenterPostNotification(notificationCenter, CFNotificationName(rawValue: name.rawValue as CFString), nil, nil, true)
    }
}
