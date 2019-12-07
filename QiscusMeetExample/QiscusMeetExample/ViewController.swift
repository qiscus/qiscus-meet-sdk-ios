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
        
    }

    // MARK: - Actions
    @IBAction func openJitsiMeet(sender: Any?) {
        guard let roomName = self.fieldRoom.text else { return }
        if roomName.isEmpty { return }
        
        QiscusMeet.shared.QiscusMeetDelegate = self
        QiscusMeet.shared.getJwtUrl(room: roomName, avatar: "https://filmschoolrejects.com/wp-content/uploads/2017/04/0JRofTsuy93evl_J5.jpg", displayName: "Ganjar", onSuccess: { (url) in
            let vc = QiscusMeet.shared.call(baseUrlCall : url)
            self.navigationController?.present(vc, animated: true, completion: {
                
            })
        }) { (error) in
            print("meet error =\(error)")
        }
        
    }
    
    func endcall(){
        QiscusMeet.shared.endCall()
    }
}

extension ViewController : QiscusMeetDelegate{
    func conferenceTerminated() {
        self.navigationController?.dismiss(animated: true, completion: {
            //actionSend comment endCall
        })
    }
}

