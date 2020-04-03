//
//  ViewController.swift
//  QiscusMeetExample
//
//  Created by asharijuang on 19/04/19.
//  Copyright © 2019 qiscus. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var fieldRoom: UITextField!
    @IBOutlet weak var fieldName: UITextField!
    @IBOutlet weak var btStartConference: UIButton!
    var roomIDDeep : String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
        
        let sharedPref = UserDefaults.standard
        if let name = sharedPref.string(forKey: "name"){
            self.fieldName.text = name
        }
        
        if !roomIDDeep.isEmpty{
            self.fieldRoom.text = roomIDDeep
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    func setupUI(){
        //border
        btStartConference.layer.cornerRadius = 8
        
        fieldRoom.layer.cornerRadius = 8
        fieldRoom.layer.borderWidth = 1
        fieldRoom.layer.borderColor = UIColor.white.cgColor
        
        fieldName.layer.cornerRadius = 8
        fieldName.layer.borderWidth = 1
        fieldName.layer.borderColor = UIColor.white.cgColor
        
        //placeholder
        fieldRoom.attributedPlaceholder = NSAttributedString(string: "Type your room id", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightText])
        
        fieldName.attributedPlaceholder = NSAttributedString(string: "Type your name", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightText])
        
        fieldName.setLeftPaddingPoints(10)
        fieldName.setRightPaddingPoints(10)
        fieldRoom.setLeftPaddingPoints(10)
        fieldRoom.setRightPaddingPoints(10)

 
        if UIScreen.main.sizeType == .iPhone5{
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        }
        
       
        
        self.addDoneButtonOnKeyboard()
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    
    @IBAction func startConference(_ sender: Any) {
        
        guard let roomID = self.fieldRoom.text else {
            return
        }
        
        if roomID.isEmpty {
            return
        }
        guard let userName = self.fieldName.text else { return }
        
        if userName.isEmpty {
            return
        }
        
        let sharedPref = UserDefaults.standard
        sharedPref.setValue(userName, forKey: "name")
        
        let vc = ConferenceVC()
        vc.name = userName
        vc.roomID = roomID
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func addDoneButtonOnKeyboard(){
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 40))
        doneToolbar.barStyle = .default

        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))

        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()

        fieldRoom.inputAccessoryView = doneToolbar
        fieldName.inputAccessoryView = doneToolbar
    }

    @objc func doneButtonAction(){
        fieldRoom.resignFirstResponder()
        fieldName.resignFirstResponder()
    }
    
   
}

extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
    
    @IBInspectable var doneAccessory: Bool{
        get{
            return self.doneAccessory
        }
        set (hasDone) {
            if hasDone{
                addDoneButtonOnKeyboard()
            }
        }
    }
    
    func addDoneButtonOnKeyboard()
    {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))
        
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction()
    {
        self.resignFirstResponder()
    }
}
