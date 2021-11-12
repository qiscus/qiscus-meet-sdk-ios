# Qiscusmeet

## Introduction

Qiscus Meet is a product provide by Qiscus as a solution for conference call. You can make a conference call up to 5 participants. Qiscus Meet build on top Jitsi Open Source. There are several features that are provided by Qiscus Meet to call conference related matter

## Requirements
- Minimum iOS 11
- xCode 13.1

## Init QiscusMeet in AppDelegate
init QiscusMeet with appID and url
init QiscusMeetConfig
```
QiscusMeet.setup(appId: "YOUR APP ID", url: "YOUR SERVER URL")
let meetConfig = MeetJwtConfig()
meetConfig.email = "users@email.com"
QiscusMeetConfig.shared.setJwtConfig = meetConfig
QiscusMeetConfig.shared.setEnableScreenSharing = true
QiscusMeetConfig.shared.setEnableRoomName = true
QiscusMeetConfig.shared.setPassword = true
QiscusMeetConfig.shared.setChat = true
QiscusMeetConfig.shared.setOverflowMenu = true
QiscusMeetConfig.shared.setVideoThumbnailsOn = false
QiscusMeetConfig.shared.setEnablePip = false
```
## Call
Set `QiscusMeetDelegate` in your viewDidLoad()
```
override func viewDidLoad() {
    super.viewDidLoad()
    QiscusMeet.shared.QiscusMeetDelegate = self
}
```

### Implementation Start call

```
 /// Func Start Call
 /// - Parameter :
 /// isVideo: Boolean, by default is video (true), if you want to use audio, you can set isVideo : false 
 /// room: String
 /// avatarUrl: String
 /// displayName: String
 /// callKitName : String (add "" for empty)
 /// - Returns: onSuccess() will return UIViewController, and onError will return String Error

  QiscusMeet.call(isVideo: isVideo, isMicMuted: isMuted, room: roomID, avatarUrl: "https://files.startupranking.com/startup/thumb/70089_80272951c13fa343805ec3b9161427be7a522a6f_qiscus_l.png", displayName: name,callKitName: "Qiscus Meet: "+roomID, onSuccess: { (vc) in
            vc.modalPresentationStyle = .fullScreen
            self.navigationController?.present(vc, animated: true, completion: {
                
            })
        }) { (error) in
            print("meet error =\(error)")
        }
```
### Implementation QiscusMeetDelegate
```
extension ViewController:QiscusMeetDelegate{
    func conferenceJoined(){

    }
    func conferenceWillJoin(){

    }
    func conferenceTerminated() {
        self.navigationController?.dismiss(animated: true, completion: {
            //actionSend comment endCall
            self.setupUI()
            
        })
    }
    
    
    func participantJoined(){
        
    }
    func participantLeft(){
        QiscusMeet.endCall()
        self.navigationController?.dismiss(animated: true, completion: {
            //actionSend comment endCall
            self.setupUI()
            
        })
    }
}
```
### Implementation End Call
```
 func endcall(){
    QiscusMeet.endCall()
 }
```