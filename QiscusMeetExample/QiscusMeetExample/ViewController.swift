//
//  ViewController.swift
//  QiscusMeetExample
//
//  Created by asharijuang on 19/04/19.
//  Copyright © 2019 qiscus. All rights reserved.
//

import UIKit
import QiscusMeet

class ViewController: UIViewController {
    
    @IBOutlet weak var loadingView: UIActivityIndicatorView!
    
    @IBOutlet weak var videoButton: UIButton?
    @IBOutlet weak var fieldRoom: UITextField!
    @IBOutlet weak var fieldName: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        QiscusMeet.shared.QiscusMeetDelegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadingView.isHidden = true
    }
    
    @IBAction func openJitsiMeet(sender: Any?) {
        guard let roomName = self.fieldRoom.text else { return }
        if roomName.isEmpty { return }
        
       self.call(isVideo: true, roomName: roomName)
    }

    @IBAction func openJitsiMeetAudio(_ sender: Any) {
        guard let roomName = self.fieldRoom.text else { return }
        if roomName.isEmpty { return }
        
        self.call(isVideo: false, roomName: roomName)
    }
    
    func call(isVideo: Bool, roomName : String){
        
        if fieldName.text?.isEmpty == true {
            return
        }
        
        loadingView.isHidden = false
        loadingView.startAnimating()
        
        let vc = QiscusMeet.call(isVideo: isVideo, room: roomName, avatarUrl: "", displayName: fieldName.text ?? "UserDefault", onSuccess: { (vc) in
            
            self.loadingView.isHidden = true
            self.loadingView.stopAnimating()
            
            vc.modalPresentationStyle = .fullScreen
            self.navigationController?.present(vc, animated: true, completion: {
                
            })
        }) { (error) in
            self.loadingView.isHidden = true
            self.loadingView.stopAnimating()
            print("meet error =\(error)")
        }
    }
    
    func endcall(){
        QiscusMeet.endCall()
    }
}

extension ViewController : QiscusMeetDelegate{
    func conferenceTerminated() {
        self.navigationController?.dismiss(animated: true, completion: {
            //actionSend comment endCall
        })
    }
}

