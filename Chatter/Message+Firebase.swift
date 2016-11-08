//
//  Message+Firebase.swift
//  Chatter
//
//  Created by Lewis Jones on 23/06/2016.
//  Copyright © 2016 Rodrigo Pena. All rights reserved.
//

import Foundation
import Firebase
import CoreData

extension Message:FirebaseModel{
    func upload(rootRef: Firebase, context: NSManagedObjectContext) {
        if chat?.storageId == nil{
            chat?.upload(rootRef, context: context)
        }
        let data = [
            "message":text!,
            "sender":FirebaseStore.currentPhoneNumber!
        ]
        
        guard let chat = chat, timestamp = timestamp, storageId = chat.storageId else {return}
        let timeInterval = String(Int(timestamp.timeIntervalSince1970 * 100000))
        rootRef.childByAppendingPath("chats/"+storageId+"/messages/"+timeInterval).setValue(data)
    }
}