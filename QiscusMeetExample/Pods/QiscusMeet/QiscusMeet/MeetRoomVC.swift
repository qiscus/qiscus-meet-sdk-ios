//
//  MeetRoomVC.swift
//  Pods-QiscusMeetExample
//
//  Created by Qiscus on 02/12/19.
//

import UIKit
import JitsiMeet

class MeetRoomVC: UIViewController, JitsiMeetViewDelegate {

    var pipViewCoordinator: PiPViewCoordinator?
    var jitsiMeetView: JitsiMeetView?
    var baseUrlCall: String = ""
    var isMicMuted: Bool = false
    var isVideo: Bool = true
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
            
            self.jitsiMeetView = jitsiMeetView
            let options = JitsiMeetConferenceOptions.fromBuilder { (builder) in
                builder.welcomePageEnabled = false
                builder.room  = self.baseUrlCall
                builder.audioMuted = !self.isMicMuted
                builder.setFeatureFlag("requirepassword.enabled", withBoolean: QiscusMeetConfig.shared.setPassword)
                builder.setFeatureFlag("videoThumbnail.enabled", withBoolean: QiscusMeetConfig.shared.setVideoThumbnailsOn)
                builder.setFeatureFlag("chat.enabled", withBoolean: QiscusMeetConfig.shared.setChat)
                builder.setFeatureFlag("overflowMenu.enabled", withBoolean: QiscusMeetConfig.shared.setOverflowMenu)
              
                if !self.isVideo{
                    builder.videoMuted = true
                    builder.audioOnly = true
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

}
