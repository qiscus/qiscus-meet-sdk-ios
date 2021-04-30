//
//  QiscusMeetConfig.swift
//  FirebaseCore
//
//  Created by Ganjar Widiatmansyah on 14/08/20.
//

import Foundation

public class QiscusMeetConfig: NSObject {
    public static var shared = QiscusMeetConfig()
    @objc public var setPassword = false
    @objc public var setChat = false
    @objc public var setOverflowMenu = false
    @objc public var setVideoThumbnailsOn = true
    @objc public var setJwtConfig = MeetJwtConfig()
    @objc public var setEnableRoomName = true
//    @objc public var setEnableExtraMenu = false
    fileprivate override init(){}
}
