//
//  FirebaseModel.swift
//  Chatter
//
//  Created by Lewis Jones on 23/06/2016.
//  Copyright © 2016 Rodrigo Pena. All rights reserved.
//

import Foundation
import Firebase
import CoreData


protocol FirebaseModel{
    func upload(rootRef:Firebase, context:NSManagedObjectContext)
}