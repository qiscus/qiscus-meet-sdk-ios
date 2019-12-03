//
//  QiscusMeet.swift
//  QiscusMeet
//
//  Created by asharijuang on 20/04/19.
//

import Foundation
import JitsiMeet
import UIKit

public protocol QiscusMeetDelegate {
    func conferenceTerminated()
}

public class QiscusMeet: NSObject {
    
    public static let shared    : QiscusMeet            = QiscusMeet()
    
    public var QiscusMeetDelegate : QiscusMeetDelegate? = nil
    
    class var bundle:Bundle{
        get{
            let podBundle = Bundle(for: QiscusMeet.self)
            
            if let bundleURL = podBundle.url(forResource: "QiscusMeet", withExtension: "bundle") {
                return Bundle(url: bundleURL)!
            }else{
                return podBundle
            }
        }
    }
    
    public func call(roomName: String)->UIViewController{
        let vc = MeetRoomVC()
        vc.roomName = roomName
        return vc
    }
    
}

