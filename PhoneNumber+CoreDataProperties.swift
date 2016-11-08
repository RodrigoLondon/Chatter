//
//  PhoneNumber+CoreDataProperties.swift
//  Chatter
//
//  Created by Lewis Jones on 01/06/2016.
//  Copyright © 2016 Rodrigo Pena. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension PhoneNumber {

    @NSManaged var value: String?
    @NSManaged var kind: String?
    @NSManaged var registered: Bool
    @NSManaged var contact: Contact?

}
