//
//  Message.swift
//  Chatter
//
//  Created by Lewis Jones on 13/05/2016.
//  Copyright © 2016 Rodrigo Pena. All rights reserved.
//

import Foundation
import CoreData


class Message: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
    
    var isIncoming:Bool{
        return sender != nil
    }


}
