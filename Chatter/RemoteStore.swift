//
//  RemoteStore.swift
//  Chatter
//
//  Created by Lewis Jones on 09/06/2016.
//  Copyright © 2016 Rodrigo Pena. All rights reserved.
//

import Foundation
import CoreData

protocol RemoteStore{
    func signUp(phoneNumber phoneNumber:String, email:String, password:String, success:()->(), error:(errorMessage:String)->())
    func startSyncing()
    func store(inserted inserted: [NSManagedObject], updated:[NSManagedObject], deleted:[NSManagedObject])

}