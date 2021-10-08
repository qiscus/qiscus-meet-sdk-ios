//
//  MeetJwtConfig.swift
//  FirebaseCore
//
//  Created by Qiscus on 29/09/20.
//

import Foundation
public class MeetJwtConfig: NSObject {
    //public static var shared = MeetJwtConfig()
    @objc public var appId = QiscusMeet.shared.getAppId()
    @objc public var email = ""
    @objc public var iss = "meetcall" // TODO move to constant place as default value
    @objc public var sub = QiscusMeet.shared.getBaseUrl()
    @objc public var moderator = false
    
    @objc public func getJwtPayload() -> [String:Any]? {
        if email.isEmpty == true {
            return nil
        } else {
            let jwtPayload = [
                "email": email,
                "moderator" : false,
                "app_id" : appId,
                "iss" : iss,
                "sub" : sub.substring(from: 8)
                ] as [String : Any]
            
            return jwtPayload
        }
    }
    
    public override init(){}
}

extension String {
    func index(from: Int) -> Index {
        return self.index(startIndex, offsetBy: from)
    }

    func substring(from: Int) -> String {
        let fromIndex = index(from: from)
        return String(self[fromIndex...])
    }
}
