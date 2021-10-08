//
//  MeetRoomVC.swift
//  Pods-QiscusMeetExample
//
//  Created by Qiscus on 02/12/19.
//

import UIKit
import JitsiMeetSDK

class MeetRoomVC: UIViewController, JitsiMeetViewDelegate {

    var pipViewCoordinator: PiPViewCoordinator?
    var jitsiMeetView: JitsiMeetView?
    var baseUrlCall: String = ""
    var isMicMuted: Bool = false
    var isVideo: Bool = true
    var callKitName = ""
    var userName = ""
    var avatar = ""
    var screenSharing:Bool = true
    init() {
        super.init(nibName: "MeetRoomVC", bundle: QiscusMeet.bundle)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let center : NotificationCenter = NotificationCenter.default
        center.addObserver(self, selector: #selector(MeetRoomVC.endCall(_:)), name: NSNotification.Name(rawValue: "MeetEndCall"), object: nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.cleanUp()
            // create and configure jitsimeet view
            let jitsiMeetView = JitsiMeetView()
            jitsiMeetView.delegate = self
            let userInfo = JitsiMeetUserInfo()
            userInfo.displayName = self.userName
            userInfo.avatar = URL(string: self.avatar)
            self.jitsiMeetView = jitsiMeetView
            let options = JitsiMeetConferenceOptions.fromBuilder { [self] builder in
                builder.welcomePageEnabled = false
                builder.room  = self.baseUrlCall
                builder.setAudioMuted(self.isMicMuted)
                builder.userInfo = userInfo
                builder.setFeatureFlag("resolution", withValue: 360)
                builder.setFeatureFlag("requirepassword.enabled", withBoolean: QiscusMeetConfig.shared.setPassword)
                builder.setFeatureFlag("videoThumbnail.enabled", withBoolean: QiscusMeetConfig.shared.setVideoThumbnailsOn)
                builder.setFeatureFlag("chat.enabled", withBoolean: QiscusMeetConfig.shared.setChat)
                builder.setFeatureFlag("overflow-menu.enabled", withBoolean: QiscusMeetConfig.shared.setOverflowMenu)
                builder.setFeatureFlag("invite.enabled", withBoolean: true)
                builder.setFeatureFlag("meeting-name.enabled", withValue: QiscusMeetConfig.shared.setEnableRoomName)
                builder.setFeatureFlag("setCallkitName",withValue: self.callKitName)
                builder.setFeatureFlag("invite.enabled",withValue: false)
                builder.setFeatureFlag("ios.screensharing.enabled" ,withBoolean: QiscusMeetConfig.shared.setEnableScreenSharing)
                if !self.isVideo{
                    builder.setVideoMuted(true)
                    builder.setAudioOnly(true)
                }else{
                    builder.setVideoMuted(false)
                    builder.setAudioOnly(false)
                }
            }
            jitsiMeetView.join(options)
            
            
            // Enable jitsimeet view to be a view that can be displayed
            // on top of all the things, and let the coordinator to manage
            // the view state and interactions
            self.pipViewCoordinator = PiPViewCoordinator(withView: jitsiMeetView)
            self.pipViewCoordinator?.configureAsStickyView(withParentView: self.view)
            
            // animate in
            jitsiMeetView.alpha = 0
            self.pipViewCoordinator?.show()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "MeetEndCall"), object: nil)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        let rect = CGRect(origin: CGPoint.zero, size: size)
        self.pipViewCoordinator?.resetBounds(bounds: rect)

    }

    func cleanUp() {
        jitsiMeetView?.removeFromSuperview()
        jitsiMeetView = nil
        pipViewCoordinator = nil
    }
    
    @objc func endCall(_ notification: Notification){
        jitsiMeetView?.leave()
    }
    
    
    func conferenceJoined(_ data: [AnyHashable : Any]!) {
        if let delegate = QiscusMeet.shared.QiscusMeetDelegate{
            delegate.conferenceJoined()
        }
    }
    
    func conferenceWillJoin(_ data: [AnyHashable : Any]!) {
        if let delegate = QiscusMeet.shared.QiscusMeetDelegate{
            delegate.conferenceWillJoin()        }
    }

    func enterPicture(inPicture data: [AnyHashable : Any]!) {
        self.pipViewCoordinator?.enterPictureInPicture()
    }

    func conferenceTerminated(_ data: [AnyHashable : Any]!) {
        self.pipViewCoordinator?.hide() { _ in
            self.cleanUp()
            if let delegate = QiscusMeet.shared.QiscusMeetDelegate{
                delegate.conferenceTerminated()
            }
            
        }

    }
    
    func participantJoined(_ data: [AnyHashable : Any]!) {
        if let delegate = QiscusMeet.shared.QiscusMeetDelegate{
            delegate.participantJoined()
        }
    }
    func participantLeft(_ data: [AnyHashable : Any]!) {
        if let delegate = QiscusMeet.shared.QiscusMeetDelegate{
            delegate.participantLeft()
        }
    }
    

}
