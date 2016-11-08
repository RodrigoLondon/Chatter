//
//  ChatCreationDelegate.swift
//  Chatter
//
//  Created by Lewis Jones on 22/05/2016.
//  Copyright © 2016 Rodrigo Pena. All rights reserved.
//

import Foundation
import CoreData

protocol ChatCreationDelegate{
    func created(chat chat: Chat, inContext context:NSManagedObjectContext)
}