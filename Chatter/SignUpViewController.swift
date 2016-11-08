//
//  SignUpViewController.swift
//  Chatter
//
//  Created by Lewis Jones on 02/06/2016.
//  Copyright © 2016 Rodrigo Pena. All rights reserved.
//

import UIKit
import Firebase 


class SignUpViewController: UIViewController {
    
    private let phoneNumberField = UITextField()
    private let emailField = UITextField()
    private let passwordField = UITextField()
    
    var remoteStore: RemoteStore?
    var contactImporter: ContactImporter?
    var rootViewController: UIViewController?


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        view.backgroundColor = UIColor.whiteColor()
        
        let label = UILabel()
        label.text = "Sign up with Chatter"
        label.font = UIFont.systemFontOfSize(24)
        label.textColor = UIColor(red: 20/255, green: 141/255, blue: 247/255, alpha: 1)
        view.addSubview(label)
        
        
        let continueButton = UIButton()
        continueButton.setTitle("Continue", forState: .Normal)
        continueButton.setTitleColor(UIColor(red: 20/255, green: 141/255, blue: 247/255, alpha: 1), forState: .Normal)
        continueButton.addTarget(self, action: "pressedContinue:", forControlEvents: .TouchUpInside)
        view.addSubview(continueButton)
        continueButton.layer.cornerRadius = 5.0
        continueButton.layer.borderColor = UIColor(red: 20/255, green: 141/255, blue: 247/255, alpha: 1).CGColor
        continueButton.layer.borderWidth = 1.0
        continueButton.backgroundColor = UIColor.whiteColor()
        continueButton.tintColor = UIColor.whiteColor()
        continueButton.contentEdgeInsets = UIEdgeInsetsMake(5,5,5,5)
        
        phoneNumberField.keyboardType = .PhonePad
        
        label.translatesAutoresizingMaskIntoConstraints = false
        continueButton.translatesAutoresizingMaskIntoConstraints = false
        
        let fields = [(phoneNumberField, "Phone Number"), (emailField, "Email"), (passwordField,"Password")]
        fields.forEach{
            $0.0.placeholder = $0.1
        
        }
        passwordField.secureTextEntry = true
        
        let stackView = UIStackView(arrangedSubviews:fields.map{$0.0})
        stackView.axis = .Vertical
        stackView.alignment = .Fill
        stackView.spacing = 20
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        let constraints:[NSLayoutConstraint] = [
            label.topAnchor.constraintEqualToAnchor(topLayoutGuide.bottomAnchor, constant: 20),
            label.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor),
            stackView.topAnchor.constraintEqualToAnchor(label.bottomAnchor, constant: 20),
            stackView.leadingAnchor.constraintEqualToAnchor(view.layoutMarginsGuide.leadingAnchor, constant: 80),
            stackView.trailingAnchor.constraintEqualToAnchor(view.layoutMarginsGuide.trailingAnchor),
            //stackView.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor),
            continueButton.topAnchor.constraintEqualToAnchor(stackView.bottomAnchor, constant: 20),
            continueButton.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor)
        ]
        NSLayoutConstraint.activateConstraints(constraints)
        
        phoneNumberField.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func pressedContinue(sender:UIButton){
        sender.enabled = false
//        if sender.backgroundColor == UIColor.whiteColor() {
//            sender.backgroundColor = UIColor(red: 20/255, green: 141/255, blue: 247/255, alpha: 1)
//        }
//        else if sender.backgroundColor == UIColor(red: 20/255, green: 141/255, blue: 247/255, alpha: 1) {
//            sender.backgroundColor = UIColor.whiteColor()
//        }
        //sender.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        //sender.backgroundColor(UIColor(red: 20/255, green: 141/255, blue: 247/255, alpha: 1))
//        
        guard let phoneNumber = phoneNumberField.text where phoneNumber.characters.count > 0 else{
            sender.enabled = true
            alertForError("Please include your phone number.")
            return
        }
        guard let email = emailField.text where email.characters.count > 0 else{
            sender.enabled = true
            alertForError("Please include your email address.")
            return
        }
        guard let password = passwordField.text where password.characters.count >= 6 else{
            sender.enabled = true
            alertForError("Password must be at least 6 characters")
            return
        }
        remoteStore?.signUp(phoneNumber: phoneNumber, email: email, password: password,
            success: {
                guard let rootVC = self.rootViewController, remoteStore = self.remoteStore, contactImporter = self.contactImporter else {return}
                
                remoteStore.startSyncing()
                contactImporter.fetch()
                contactImporter.listenForChanges()
        
                self.presentViewController(rootVC, animated: true, completion: nil)
            },
            error: { errorString in
                self.alertForError(errorString)
                sender.enabled = true
        })
    }
    private func alertForError(error:String){
        let alertController = UIAlertController(title: "Error", message: error, preferredStyle: .Alert)
        let OKAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(OKAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
//    func didRequestPasswordReset(sender: AnyObject) {
//        let prompt = UIAlertController.init(title: nil, message: "Email:", preferredStyle: UIAlertControllerStyle.Alert)
//        let okAction = UIAlertAction.init(title: "OK", style: UIAlertActionStyle.Default) { (action) in
//            let userInput = prompt.textFields![0].text
//            if (userInput!.isEmpty) {
//                return
//            }
//                FIRAuth.auth()?.sendPasswordResetWithEmail(userInput!) { (error) in
//                if let error = error {
//                    print(error.localizedDescription)
//                    return
//                }
//            }
//        }
//        prompt.addTextFieldWithConfigurationHandler(nil)
//        prompt.addAction(okAction)
//        presentViewController(prompt, animated: true, completion: nil);
//    }

}
