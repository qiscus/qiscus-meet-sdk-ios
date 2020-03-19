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
    var viewVC : UIViewController? = nil
    var viewIsHidden : Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        QiscusMeet.shared.QiscusMeetDelegate = self
        let center : NotificationCenter = NotificationCenter.default
        center.addObserver(self, selector: #selector(ViewController.activeFromBackground(_:)), name: NSNotification.Name(rawValue: "activeFromBackground"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @IBAction func openJitsiMeet(sender: Any?) {
        guard let roomName = self.fieldRoom.text else { return }
        if roomName.isEmpty { return }
        
       self.call(isVideo: false, roomName: roomName)
    }

    @IBAction func openJitsiMeetAudio(_ sender: Any) {
        guard let roomName = self.fieldRoom.text else { return }
        if roomName.isEmpty { return }
        
        self.call(isVideo: false, roomName: roomName)
    }
    
    func call(isVideo: Bool, roomName : String){
        _ = QiscusMeet.call(isVideo: isVideo, room: roomName, avatarUrl: "https://filmschoolrejects.com/wp-content/uploads/2017/04/0JRofTsuy93evl_J5.jpg", displayName: "arief", onSuccess: { (vc) in
            self.viewVC = vc
            vc.modalPresentationStyle = .fullScreen
            self.navigationController?.present(vc, animated: true, completion: {
                
            })
        }) { (error) in
            print("meet error =\(error)")
        }
    }
    
    @objc func activeFromBackground(_ notification: Notification){
       removeCustomStatusBar()
    }
    
    func removeCustomStatusBar(){
        showCall()
        let currentWindow: UIWindow? = UIApplication.shared.keyWindow
        if let foundView = currentWindow?.viewWithTag(99) {
            foundView.removeFromSuperview()
        }
    }
    
    func showCall(){
        if viewIsHidden == true {
            if let vc = self.viewVC{
                //show statusbar
                UIApplication.shared.keyWindow?.windowLevel = UIWindow.Level.normal
                
                vc.modalPresentationStyle = .fullScreen
                self.viewIsHidden = false
                self.navigationController?.present(vc, animated: true, completion: {
                    
                })
            }
        }
    }
    
    func endcall(){
        QiscusMeet.endCall()
        
        //remove ui customStatusBar
        UIApplication.shared.keyWindow?.windowLevel = UIWindow.Level.normal
        let currentWindow: UIWindow? = UIApplication.shared.keyWindow
        if let foundView = currentWindow?.viewWithTag(99) {
            foundView.removeFromSuperview()
        }
    }
}

extension ViewController : QiscusMeetDelegate{
    func conferenceTerminated() {
        self.navigationController?.dismiss(animated: true, completion: {
            //actionSend comment endCall
        })
    }
    
    func backButton(){
        self.navigationController?.dismiss(animated: true, completion: {
            //actionSend comment endCall
            
            self.viewIsHidden = true
            
            //hidden status bar
            UIApplication.shared.keyWindow?.windowLevel = UIWindow.Level.statusBar
            
            //create custom statusBar activeCall
            let buttonStatus = UIButton()
            buttonStatus.setTitle("Call isActive", for: .normal)
            buttonStatus.setTitleColor(UIColor.white, for: .normal)
            buttonStatus.backgroundColor = UIColor.green
            buttonStatus.addTarget(self, action:  #selector(ViewController.activeCall), for: .touchUpInside)
            buttonStatus.frame = CGRect(x: 0,y: 0,width: self.view.frame.size.width,height: 30)
            
            buttonStatus.tag = 99
            let currentWindow: UIWindow? = UIApplication.shared.keyWindow
            currentWindow?.addSubview(buttonStatus)
            
        })
    }
    
    @objc func activeCall() {
        self.removeCustomStatusBar()
    }
}

