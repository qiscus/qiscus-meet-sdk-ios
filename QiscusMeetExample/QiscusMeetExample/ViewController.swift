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
    @IBOutlet weak var videoButton: UIButton?
    @IBOutlet weak var fieldRoom: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        QiscusMeet.shared.QiscusMeetDelegate = self
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
        let vc = QiscusMeet.call(isVideo: isVideo, room: roomName, avatarUrl: "https://filmschoolrejects.com/wp-content/uploads/2017/04/0JRofTsuy93evl_J5.jpg", displayName: "arief", onSuccess: { (vc) in
            self.navigationController?.present(vc, animated: true, completion: {
                
            })
        }) { (error) in
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

