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
    @objc public var setEnableScreenSharing = false
    @objc public var setEnableReactions = false
    @objc public var setEnableRaiseHand = false
    @objc public var setEnableSecurityOptions = true
    @objc public var setEnableToolbox = true
    @objc public var setEnableTileView = true
    @objc public var setToolboxAlwaysVisible = true
    @objc public var setEnableParticipantPane = true
    @objc public var setEnableVideoMuteButton = true
    @objc public var setEnableInvite = false
    fileprivate override init(){}
}
