//
//  ContextViewController .swift
//  Chatter
//
//  Created by Lewis Jones on 26/05/2016.
//  Copyright © 2016 Rodrigo Pena. All rights reserved.
//

import Foundation
import CoreData

protocol ContextViewController{
    var context:NSManagedObjectContext?{get set}
}
