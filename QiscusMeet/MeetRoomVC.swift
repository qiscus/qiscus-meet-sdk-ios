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
                builder.setFeatureFlag("directCall", withBoolean: true)
                builder.room  = self.baseUrlCall
              
                if self.isVideo{
                    builder.audioMuted = false
                    builder.videoMuted = false
                }else{
                    builder.videoMuted = true
                    builder.audioOnly = true
                }
            }
            jitsiMeetView.join(options)
            
           let backIcon = UIImageView()
            backIcon.contentMode = .scaleAspectFit
            
            let image = UIImage(named: "AppIcon")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
            backIcon.image = image
            backIcon.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            
            if UIApplication.shared.userInterfaceLayoutDirection == .leftToRight {
                backIcon.frame = CGRect(x: 0,y: 11,width: 30,height: 25)
            }else{
                backIcon.frame = CGRect(x: 22,y: 11,width: 30,height: 25)
            }
            
            let backButton = UIButton(frame:CGRect(x: 0,y: 0,width: 30,height: 44))
            backButton.addSubview(backIcon)
            backButton.addTarget(self, action: #selector(MeetRoomVC.goBack), for: UIControl.Event.touchUpInside)
            
            jitsiMeetView.addSubview(backButton)
            
            
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
    
    @objc func goBack() {
        view.endEditing(true)
        if let delegate = QiscusMeet.shared.QiscusMeetDelegate{
            delegate.backButton()
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
