# Qiscusmeet

## Introduction

Qiscus Meet is a product provide by Qiscus as a solution for conference call. You can make a conference call up to 5 participants. Qiscus Meet build on top Jitsi Open Source. There are several features that are provided by Qiscus Meet to call conference related matter

## Requirements
- Minimum iOS 8.0
- xCode 10.xx

## Init QiscusMeet
init QiscusMeet with base url
```
QiscusMeet.setup(url: "<<base url>>")
```
## Start Call
Set `QiscusMeetDelegate` in your viewDidLoad()
```
override func viewDidLoad() {
    super.viewDidLoad()
    QiscusMeet.shared.QiscusMeetDelegate = self
}
```

```
QiscusMeet.call(isVideo: Bool = true, room: String, avatarUrl: String, displayName: String, onSuccess: { (vc) in
    self.navigationController?.present(vc, animated: true, completion: {
        
    })
}) { (error) in
    print("meet error =\(error)")
}
```

```
extension ViewController : QiscusMeetDelegate{
    func conferenceTerminated() {
        self.navigationController?.dismiss(animated: true, completion: {
            
        })
    }
}
```
