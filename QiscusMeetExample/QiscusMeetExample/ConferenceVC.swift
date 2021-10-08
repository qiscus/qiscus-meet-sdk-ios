//
//  ConferenceVC.swift
//  QiscusMeetExample
//
//  Created by Qiscus on 02/04/20.
//  Copyright © 2020 qiscus. All rights reserved.
//

import UIKit
import QiscusMeet

class ConferenceVC: UIViewController {

    @IBOutlet weak var switchMic: UISwitch!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var btAudioCallLeftCons: NSLayoutConstraint!
    @IBOutlet weak var btVideoCallRightCons: NSLayoutConstraint!
    @IBOutlet weak var audioCallRightCons: NSLayoutConstraint!
    @IBOutlet weak var videoCallLeftCons: NSLayoutConstraint!
    
    @IBOutlet weak var lbRoomID: UILabel!
    var name: String = ""
    var roomID : String = ""
    var isMicOn : Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let sharedPref = UserDefaults.standard
        let sharedMicOn = sharedPref.bool(forKey: "isMicOn")
        
        isMicOn = sharedMicOn
        
        switchMic.addTarget(self, action: #selector(onSwitchValueChanged), for: .touchUpInside)
        switchMic.setOn(sharedMicOn, animated: true)
        QiscusMeet.shared.QiscusMeetDelegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
        
        self.lbRoomID.text = "RoomID : \(roomID)"
        
        if UIScreen.main.sizeType == .iPhone5{
            btAudioCallLeftCons.constant = 10
            btVideoCallRightCons.constant = 10
            audioCallRightCons.constant = 10
            videoCallLeftCons.constant = 10
        }
        
        self.dismissLoading()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func openVideoCall(_ sender: Any) {
       
        if roomID.isEmpty {
            self.navigationController?.popViewController(animated: true)
        }

        self.call(isVideo: true, isMuted: isMicOn)
    }
   
    @IBAction func openAudioCall(_ sender: Any) {
        if roomID.isEmpty {
            self.navigationController?.popViewController(animated: true)
        }

        self.call(isVideo: false, isMuted: isMicOn)
    }
    
    @objc func onSwitchValueChanged(_ switchClick: UISwitch) {
        isMicOn = switchClick.isOn
        let sharedPref = UserDefaults.standard
        sharedPref.setValue(isMicOn, forKey: "isMicOn")
    }
    
    func call(isVideo: Bool, isMuted: Bool){
        showLoading()
        QiscusMeet.call(isVideo: isVideo, isMicMuted: isMuted, room: roomID, avatarUrl: "https://upload.wikimedia.org/wikipedia/en/8/86/Avatar_Aang.png", displayName: name, callKitName: "Qiscus Meet", onSuccess: { (vc) in
            self.dismissLoading()
            vc.modalPresentationStyle = .fullScreen
            self.navigationController?.present(vc, animated: true, completion: {
                
            })
            
           
        }) { (error) in
            print("meet error =\(error)")
            self.dismissLoading()
        }
        
         
    }
    
    func endcall(){
        QiscusMeet.endCall()
    }
    
    func showLoading() {
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.whiteLarge
        loadingIndicator.startAnimating();
    }
    
    func dismissLoading() {
        loadingIndicator.stopAnimating()
        loadingIndicator.isHidden = true
    }
}

extension ConferenceVC : QiscusMeetDelegate{
    func conferenceWillJoin() {
         
    }
    
    func conferenceTerminated() {
        self.navigationController?.dismiss(animated: true, completion: {
            //actionSend comment endCall
            
        })
    }
    
    func conferenceJoined(){

    }
    func participantJoined(){
        
    }
    func participantLeft(){
        
    }
}

extension UIScreen {
    enum SizeType: CGFloat {
        case Unknown = 0.0
        case iPhone5 = 1136.0
    }

    var sizeType: SizeType {
        let height = nativeBounds.height
        guard let sizeType = SizeType(rawValue: height) else { return .Unknown }
        return sizeType
    }
}

