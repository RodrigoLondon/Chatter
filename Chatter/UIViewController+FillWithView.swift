//
//  UIViewController+FillWithView.swift
//  Chatter
//
//  Created by Lewis Jones on 21/05/2016.
//  Copyright © 2016 Rodrigo Pena. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController{
    func fillViewWith(subview: UIView){
        
        subview.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(subview)
        
        let viewConstraints:[NSLayoutConstraint] = [
            subview.topAnchor.constraintEqualToAnchor(topLayoutGuide.bottomAnchor),
            subview.leadingAnchor.constraintEqualToAnchor(view.leadingAnchor),
            subview.trailingAnchor.constraintEqualToAnchor(view.trailingAnchor),
            subview.bottomAnchor.constraintEqualToAnchor(bottomLayoutGuide.topAnchor)
        ]
        NSLayoutConstraint.activateConstraints(viewConstraints)
    }
}
