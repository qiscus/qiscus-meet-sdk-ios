# Qiscusmeet

## Introduction

Qiscus Meet is a product provide by Qiscus as a solution for conference call. You can make a conference call up to 5 participants. Qiscus Meet build on top Jitsi Open Source. There are several features that are provided by Qiscus Meet to call conference related matter

## Requirements
- Minimum iOS 8.0
- xCode 10.xx

## Start Call
```
QiscusMeet.shared.QiscusMeetDelegate = self
    let vc = QiscusMeet.shared.call(roomName: roomName)
    self.navigationController?.present(vc, animated: true, completion: {
        
})
```

```
extension ViewController : QiscusMeetDelegate{
    func conferenceTerminated() {
        self.navigationController?.dismiss(animated: true, completion: {
            
        })
    }
}
```
