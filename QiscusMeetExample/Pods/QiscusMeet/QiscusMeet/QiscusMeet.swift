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
    
    public class func setup(url : String){
        let defaults = UserDefaults.standard
        defaults.set(url, forKey: QiscusMeet.shared.prefixQiscus + "initBaseServer")
    }
    
    private func getBaseUrl() -> String{
        let defaults = UserDefaults.standard
        return defaults.string(forKey: prefixQiscus + "initBaseServer") ?? "https://meet.qiscus.com"
    }
    
    private func getJwtUrl(room: String, avatar: String, displayName: String, onSuccess:  @escaping (String) -> Void, onError: @escaping (String) -> Void){
        let baseUrlRoom = getBaseUrl() + "/" + room
        let params = ["baseUrl": baseUrlRoom,
                      "name" : displayName,
                      "avatar" : avatar
                      ]
        let url = getBaseUrl() + ":9090/generate_url"
        Alamofire.request(url,
                          method: .post,
                          parameters: params,
                          encoding: JSONEncoding.default)
            .responseJSON { response in
                guard response.result.isSuccess else {
                    print("QiscusMeet error = \(String(describing: response.result.error))")
                    onError(String(describing: response.result.error))
                    return
                }
                
                var data = JSON(response.result.value!)
                let url = data["url"].stringValue

                onSuccess(url)
            }
    }
    
    private func getTotalParticipants(room: String, onSuccess:  @escaping (Int) -> Void, onError: @escaping (String) -> Void){

        let url = getBaseUrl() + "/get-room-size?room="+room
        Alamofire.request(url,
                          method: .get,
                          encoding: JSONEncoding.default)
            .responseJSON { response in
                guard response.result.isSuccess else {
                    onError(String(describing: response.result.error))
                    return
                }
                
                var data = JSON(response.result.value!)
                let participants = data["participants"].stringValue
                let intValue:Int = Int(participants)!
                
                onSuccess(intValue)
        }
    }
    
    public class func call(isVideo: Bool = true, room: String, avatarUrl: String, displayName: String, onSuccess:  @escaping (UIViewController) -> Void, onError: @escaping (String) -> Void){
        QiscusMeet.shared.getJwtUrl(room: room, avatar: avatarUrl, displayName: displayName, onSuccess: { (url) in
            let vc = MeetRoomVC()
            vc.baseUrlCall = url
            vc.isVideo = isVideo
            onSuccess(vc)
        }) { (error) in
            onError(error)
        }
    }
    
    public class func answer(isVideo: Bool = true, room: String, avatarUrl: String, displayName: String, onSuccess:  @escaping (UIViewController) -> Void, onError: @escaping (String) -> Void){
        
        QiscusMeet.shared.getTotalParticipants(room: room, onSuccess: { (participants) in
           print("QiscusMeet get participants = \(String(describing: participants))")
            if(participants > 0){
                QiscusMeet.shared.getJwtUrl(room: room, avatar: avatarUrl, displayName: displayName, onSuccess: { (url) in
                    let vc = MeetRoomVC()
                    vc.baseUrlCall = url
                    vc.isVideo = isVideo
                    onSuccess(vc)
                }) { (error) in
                    onError(error)
                }
            }
        }) { (error) in
            onError(error)
        }
        
    }
    
    public class func endCall(){
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "MeetEndCall"), object: nil)
    }
    
}

