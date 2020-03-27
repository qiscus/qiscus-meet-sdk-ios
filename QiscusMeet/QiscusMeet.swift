//
//  QiscusMeet.swift
//  QiscusMeet
//
//  Created by asharijuang on 20/04/19.
//

import Foundation
import JitsiMeet
import UIKit
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
        let jsonData = try? JSONSerialization.data(withJSONObject: params)

        // create post request
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "POST"

        // insert json data to the request
        request.httpBody = jsonData

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let response = response as? HTTPURLResponse {
                let result = self.handleNetworkResponse(response)
                switch result {
                case .success:
                    guard let responseData = data else {
                        onError("errror")
                        return
                    }
                    
                    let data = JSON(responseData)
                    let url = data["url"].stringValue
                    DispatchQueue.main.sync {
                        onSuccess(url)
                    }
                    
                case .failure(let errorMessage):
                    do {
                        _ = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
                    } catch {
                    }
                    DispatchQueue.main.sync {
                        onError(String(describing: errorMessage))
                    }
                    
                }
            }
        }

        task.resume()
    }
    
    enum NetworkResponse:String {
        case success
        case clientError = "Client Error."
        case serverError = "Server Error."
        case badRequest = "Bad request"
        case outdated = "The url you requested is outdated."
        case failed = "Network request failed."
        case noData = "Response returned with no data to decode."
        case unableToDecode = "Response not JSON or undefined."
    }
    
    func handleNetworkResponse(_ response: HTTPURLResponse) -> Result<String>{
           switch response.statusCode {
           case 200...299: return .success
           case 400...499: return .failure(NetworkResponse.clientError.rawValue)
           case 500...599: return .failure(NetworkResponse.serverError.rawValue)
           case 600: return .failure(NetworkResponse.outdated.rawValue)
           default: return .failure(NetworkResponse.failed.rawValue)
           }
       }
    
    enum Result<String>{
        case success
        case failure(String)
    }
    
    private func getTotalParticipants(room: String, onSuccess:  @escaping (Int) -> Void, onError: @escaping (String) -> Void){

        let url = getBaseUrl() + "/get-room-size?room="+room
        
        var urlRequest = URLRequest(url: URL(string: url)!)
        urlRequest.httpMethod = "GET"
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: urlRequest) { (data, response, error) in
           if error != nil {
                onError("error")
            }
            if let response = response as? HTTPURLResponse {
                let result = self.handleNetworkResponse(response)
                switch result {
                case .success:
                    guard let responseData = data else {
                        onError("errror")
                        return
                    }
                    
                    let data = JSON(responseData)
                    let participants = data["participants"].stringValue
                    let intValue:Int = Int(participants)!
                    DispatchQueue.main.sync {
                        onSuccess(intValue)
                    }
                case .failure(let errorMessage):
                    do {
                        _ = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
                    } catch {
                    }
                    DispatchQueue.main.sync {
                         onError(String(describing: errorMessage))
                    }
                }
            }
        }
        task.resume()
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


