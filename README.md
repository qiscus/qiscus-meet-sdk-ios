# Qiscusmeet

## Introduction

Qiscus Meet is a product provide by Qiscus as a solution for conference call. You can make a conference call up to 5 participants. Qiscus Meet build on top Jitsi Open Source. There are several features that are provided by Qiscus Meet to call conference related matter

## Requirements
- Minimum iOS 8.0
- xCode 10.xx

## Init QiscusMeet
init QiscusMeet with base url
```
QiscusMeet.setup(url: baseUr)
```
## Start Call
Set `QiscusMeetDelegate` in your viewDidLoad()
```
override func viewDidLoad() {
    super.viewDidLoad()
    QiscusMeet.shared.QiscusMeetDelegate = self
}
```

Implementation QiscusMeetDelegate

```
extension ViewController : QiscusMeetDelegate{
    func conferenceTerminated() {
        self.navigationController?.dismiss(animated: true, completion: {
            
        })
    }
}
```

Implementation start call

```
 /// Func Start Call
 /// - Parameter :
 /// isVideo: Boolean, by default is video (true), if you want to use audio, you can set isVideo : false 
 /// room: String
 /// avatarUrl: String
 /// displayName: String
 /// - Returns: onSuccess() will return UIViewController, and onError will return String Error

QiscusMeet.call(isVideo: true, room: String, avatarUrl: String, displayName: String, onSuccess: { (vc) in
    self.navigationController?.present(vc, animated: true, completion: {
        
    })
}) { (error) in
    print("meet error =\(error)")
}
```

Implementation end call

```
 func endcall(){
    QiscusMeet.endCall()
 }
```



