//
//  Contact+CoreDataProperties.swift
//  Chatter
//
//  Created by Lewis Jones on 21/06/2016.
//  Copyright © 2016 Rodrigo Pena. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Contact {

    @NSManaged var contactId: String?
    @NSManaged var favorite: Bool
    @NSManaged var firstName: String?
    @NSManaged var imageData: NSData?
    @NSManaged var lastName: String?
    @NSManaged var status: String?
    @NSManaged var storageId: String?
    @NSManaged var chats: NSSet?
    @NSManaged var messages: NSSet?
    @NSManaged var phoneNumbers: NSSet?

}
