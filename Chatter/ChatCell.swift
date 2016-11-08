//
//  ChatCell.swift
//  Chatter
//
//  Created by Lewis Jones on 20/05/2016.
//  Copyright © 2016 Rodrigo Pena. All rights reserved.
//

import UIKit

class ChatCell: UITableViewCell {

    let nameLabel = UILabel()
    let messageLabel = UILabel()
    let dateLabel = UILabel()
    var contactImage = UIImageView()
    var imgUser = UIImageView()
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        nameLabel.font = UIFont.systemFontOfSize(16, weight: UIFontWeightBold)
        messageLabel.textColor = UIColor.grayColor()
        dateLabel.textColor = UIColor.grayColor()
        contactImage.layer.cornerRadius = 30
        contactImage.clipsToBounds = true
        
        imgUser.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(imgUser)
        contactImage.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(contactImage)
      
        
        let labels = [nameLabel,messageLabel,dateLabel]
        for label in labels{
            label.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(label)
            
        }
        let constraints:[NSLayoutConstraint] = [
            imgUser.topAnchor.constraintEqualToAnchor(contentView.layoutMarginsGuide.topAnchor),
            imgUser.leadingAnchor.constraintEqualToAnchor(contentView.layoutMarginsGuide.leadingAnchor),
            imgUser.trailingAnchor.constraintEqualToAnchor(contentView.layoutMarginsGuide.leadingAnchor, constant: 60),
            imgUser.bottomAnchor.constraintEqualToAnchor(contentView.layoutMarginsGuide.bottomAnchor),
            contactImage.topAnchor.constraintEqualToAnchor(contentView.layoutMarginsGuide.topAnchor),
            contactImage.leadingAnchor.constraintEqualToAnchor(contentView.layoutMarginsGuide.leadingAnchor),
            contactImage.trailingAnchor.constraintEqualToAnchor(contentView.layoutMarginsGuide.leadingAnchor, constant: 60),
            contactImage.bottomAnchor.constraintEqualToAnchor(contentView.layoutMarginsGuide.bottomAnchor),
            nameLabel.topAnchor.constraintEqualToAnchor(contentView.layoutMarginsGuide.topAnchor),
            nameLabel.leadingAnchor.constraintEqualToAnchor(imgUser.trailingAnchor, constant: 5),
            nameLabel.leadingAnchor.constraintEqualToAnchor(contactImage.trailingAnchor, constant: 5),
            messageLabel.bottomAnchor.constraintEqualToAnchor(contentView.layoutMarginsGuide.bottomAnchor),
            messageLabel.leadingAnchor.constraintEqualToAnchor(nameLabel.leadingAnchor),
            dateLabel.trailingAnchor.constraintEqualToAnchor(contentView.layoutMarginsGuide.trailingAnchor),
            dateLabel.firstBaselineAnchor.constraintEqualToAnchor(nameLabel.firstBaselineAnchor)
        ]
        NSLayoutConstraint.activateConstraints(constraints)
        
        
    }
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



