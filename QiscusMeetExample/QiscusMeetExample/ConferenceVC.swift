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

    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var btAudioCallLeftCons: NSLayoutConstraint!
    @IBOutlet weak var btVideoCallRightCons: NSLayoutConstraint!
    @IBOutlet weak var audioCallRightCons: NSLayoutConstraint!
    @IBOutlet weak var videoCallLeftCons: NSLayoutConstraint!
    
    var name: String = ""
    var roomID : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        QiscusMeet.shared.QiscusMeetDelegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
        
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

        self.call(isVideo: true)
    }
   
    @IBAction func openAudioCall(_ sender: Any) {
        if roomID.isEmpty {
            self.navigationController?.popViewController(animated: true)
        }

        self.call(isVideo: false)
    }
    
    func call(isVideo: Bool){
        showLoading()
        let vc = QiscusMeet.call(isVideo: isVideo, room: roomID, avatarUrl: "", displayName: name, onSuccess: { (vc) in
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
    func conferenceTerminated() {
        self.navigationController?.dismiss(animated: true, completion: {
            //actionSend comment endCall
        })
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

