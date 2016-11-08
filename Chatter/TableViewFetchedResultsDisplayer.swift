//
//  TableViewFetchedResultsDisplayer.swift
//  Chatter
//
//  Created by Lewis Jones on 27/05/2016.
//  Copyright © 2016 Rodrigo Pena. All rights reserved.
//

import Foundation
import UIKit

protocol TableViewFetchedResultsDisplayer{
    func configureCell(cell:UITableViewCell, atIndexPath indexPath: NSIndexPath)
}
