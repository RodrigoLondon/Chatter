//
//  ChatCell.swift
//  Chatter
//
//  Created by Lewis Jones on 09/05/2016.
//  Copyright © 2016 Rodrigo Pena. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {

    let SHADOW_COLOR: CGFloat = 157.0 / 255.0
    let messageLabel: UILabel = UILabel()
    private let bubbleImageView = UIImageView()
    
    private var outgoingConstraints: [NSLayoutConstraint]!
    private var incomingConstraints: [NSLayoutConstraint]!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        bubbleImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(bubbleImageView)
        bubbleImageView.addSubview(messageLabel)
        
        messageLabel.centerXAnchor.constraintEqualToAnchor(bubbleImageView.centerXAnchor).active = true
        messageLabel.centerYAnchor.constraintEqualToAnchor(bubbleImageView.centerYAnchor).active = true

        bubbleImageView.widthAnchor.constraintEqualToAnchor(messageLabel.widthAnchor, constant:50).active = true
        bubbleImageView.heightAnchor.constraintEqualToAnchor(messageLabel.heightAnchor, constant:20).active = true

        outgoingConstraints = [
            bubbleImageView.trailingAnchor.constraintEqualToAnchor(contentView.trailingAnchor, constant:-5),
            bubbleImageView.leadingAnchor.constraintGreaterThanOrEqualToAnchor(contentView.leadingAnchor, constant:30)
        ]
        
        incomingConstraints = [
            bubbleImageView.leadingAnchor.constraintEqualToAnchor(contentView.leadingAnchor, constant:5),
            bubbleImageView.trailingAnchor.constraintLessThanOrEqualToAnchor(contentView.trailingAnchor, constant:-30)
        ]
        
        bubbleImageView.topAnchor.constraintEqualToAnchor(contentView.topAnchor, constant: 10).active = true
        bubbleImageView.bottomAnchor.constraintEqualToAnchor(contentView.bottomAnchor, constant: -10).active = true
        
        
        messageLabel.textAlignment = .Center
        messageLabel.numberOfLines = 0
       /* let image = UIImage(named: "MessageBubble")?.imageWithRenderingMode(.AlwaysTemplate)
        bubbleImageView.tintColor = UIColor.blueColor()
        bubbleImageView.image = image */
        
        bubbleImageView.layer.shadowColor = UIColor(red: SHADOW_COLOR, green: SHADOW_COLOR, blue: SHADOW_COLOR, alpha: 0.5).CGColor
        bubbleImageView.layer.shadowOpacity = 0.8
        bubbleImageView.layer.shadowRadius = 5.0
        bubbleImageView.layer.shadowOffset = CGSizeMake(0.0, 2.0)
        
         
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
  
    func incoming(incoming: Bool) {
        if incoming {
            NSLayoutConstraint.deactivateConstraints(outgoingConstraints)
            NSLayoutConstraint.activateConstraints(incomingConstraints)
            bubbleImageView.image = bubble.incoming
            messageLabel.textColor = UIColor(red: 53/255, green: 63/255, blue: 69/255, alpha: 1)

        } else {
            NSLayoutConstraint.deactivateConstraints(incomingConstraints)
            NSLayoutConstraint.activateConstraints(outgoingConstraints)
            bubbleImageView.image = bubble.outgoing
            messageLabel.textColor = UIColor.whiteColor()
        }        
    }
}

let bubble = makeBubble()

func makeBubble() -> (incoming: UIImage, outgoing: UIImage) {
    let image = UIImage(named: "MessageBubble")!
    let insetsIncoming = UIEdgeInsets(top: 17, left: 26.5, bottom: 17.5, right: 21)
    let insetsOutgoing = UIEdgeInsets(top: 17, left: 21, bottom: 17.5, right: 26.5)
    
    // rendering mode .AlwaysTemplate doesn't work when changing the orientation
    let outgoing = coloredImage(image, red: 20/255, green: 141/255, blue: 247/255, alpha: 1).resizableImageWithCapInsets(insetsOutgoing)
    //outgoing.textColor = UIColor.whiteColor()
    
    
    let flippedImage = UIImage(CGImage: image.CGImage!, scale: image.scale, orientation: UIImageOrientation.UpMirrored)
    
    let incoming = coloredImage(flippedImage,red: 239/255, green: 239/255, blue: 244/255, alpha: 1).resizableImageWithCapInsets(insetsIncoming)
    
    return (incoming, outgoing)
}

func coloredImage(image: UIImage, red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) -> UIImage! {
    let rect = CGRect(origin: CGPointZero, size: image.size)
    UIGraphicsBeginImageContextWithOptions(image.size, false, image.scale)
    let context = UIGraphicsGetCurrentContext()
    image.drawInRect(rect)
    
    CGContextSetRGBFillColor(context, red, green, blue, alpha)
    CGContextSetBlendMode(context, CGBlendMode.SourceAtop)
    CGContextFillRect(context, rect)
    let result = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    

    
    return result
}
