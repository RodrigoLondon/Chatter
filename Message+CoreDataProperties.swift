//
//  Message+CoreDataProperties.swift
//  Chatter
//
//  Created by Lewis Jones on 23/05/2016.
//  Copyright © 2016 Rodrigo Pena. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Message {

    @NSManaged var text: String?
    @NSManaged var timestamp: NSDate?
    @NSManaged var chat: Chat?
    @NSManaged var sender: Contact?

}
