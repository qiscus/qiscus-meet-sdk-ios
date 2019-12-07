//
//  QiscusMeet.swift
//  QiscusMeet
//
//  Created by asharijuang on 20/04/19.
//

import Foundation
import JitsiMeet
import UIKit
import Alamofire
import SwiftyJSON

public protocol QiscusMeetDelegate {
    func conferenceTerminated()
}

public class QiscusMeet: NSObject {
    
    public static let shared    : QiscusMeet            = QiscusMeet()
    
    public var QiscusMeetDelegate : QiscusMeetDelegate? = nil
    private var prefixQiscus = "qcu_"
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
    
    public func initJwtServer(url: String){
        let defaults = UserDefaults.standard
        defaults.set(url, forKey: prefixQiscus + "initJwtServer")
    }
    
    public func initBaseServer(url : String){
        let defaults = UserDefaults.standard
        defaults.set(url, forKey: prefixQiscus + "initBaseServer")
    }
    
    private func getInitBaseServer() -> String{
        let defaults = UserDefaults.standard
        return defaults.string(forKey: prefixQiscus + "initBaseServer") ?? "https://meet.qiscus.com"
    }
    
    private func getInitJwtServer() -> String{
        let defaults = UserDefaults.standard
        return defaults.string(forKey: prefixQiscus + "initJwtServer") ?? "https://meet-jwt.qiscus.com"
    }
    
    public func getJwtUrl(room: String, avatar: String, displayName: String, onSuccess:  @escaping (String) -> Void, onError: @escaping (String) -> Void){
        let baseUrlRoom = getInitBaseServer() + "/" + room
        var params = ["baseUrl": baseUrlRoom,
                      "name" : displayName,
                      "avatar" : avatar
                      ]
        Alamofire.request(getInitJwtServer(),
                          method: .post,
                          parameters: params,
                          encoding: JSONEncoding.default)
            .responseJSON { response in
                guard response.result.isSuccess else {
                    print("QiscusMeet error = \(String(describing: response.result.error))")
                    onError(String(describing: response.result.error))
                    return
                }
                
                var data = JSON(response.result.value)
                let url = data["url"].stringValue

                onSuccess(url)
            }
        
    }
    
    public func call(baseUrlCall: String)->UIViewController{
        let vc = MeetRoomVC()
        vc.baseUrlCall = baseUrlCall
        return vc
    }
    
    public func endCall(){
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "MeetEndCall"), object: nil)
    }
    
}

