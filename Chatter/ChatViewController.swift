//
//  ViewController.swift
//  Chatter
//
//  Created by Lewis Jones on 09/05/2016.
//  Copyright © 2016 Rodrigo Pena. All rights reserved.
//

import UIKit
import CoreData
import MediaPlayer
import Firebase


class ChatViewController: UIViewController{
    
    private let tableView = UITableView(frame: CGRectZero, style: .Grouped)
    private let newMessageField = UITextView()
    //private var messages = [Message]()
    private var sections = [NSDate:[Message]]()
    private var dates = [NSDate]()
    private var bottomConstraint: NSLayoutConstraint!
    private let cellIdentifier = "Cell"
    private var fetchedResultsController: NSFetchedResultsController?
    private var fetchedResultsDelegate: NSFetchedResultsControllerDelegate?
    //private var storageRef = FIRStorage.storage().referenceForURL("https://onechatter.firebaseio.com/")
//    let photoUrl = "photoUrl"
//    let imageUrl = "imageUrl"
    //var storageRef: FIRStorageReference!
   
    

    //Shadows
    let SHADOW_COLOR: CGFloat = 157.0 / 255.0

    
    var context:NSManagedObjectContext?
    
    var chat:Chat?
    
    private enum Error:ErrorType{
        case NoChat
        case NoContext
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        

        view.backgroundColor = UIColor.whiteColor()
        
        navigationController!.navigationBar.barTintColor = UIColor(red: 242/255, green: 242/255, blue: 242/255, alpha: 1)
        
        //navigationItem.rightBarButtonItem = editButtonItem()
        
        do {
            guard let chat = chat else {throw Error.NoChat}
            guard let context = context else {throw Error.NoContext}
            let request = NSFetchRequest(entityName: "Message")
            request.predicate = NSPredicate(format: "chat=%@", chat)
            request.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: false)]
            if let result = try context.executeFetchRequest(request) as? [Message] {
                for message in result{
                    addMessage(message)
                }
                dates = dates.sort({$0.earlierDate($1) == $0})
            }
        } catch {
            print("We couldn't fetch!")
        }
//        func configureStorage() {
//            storageRef = FIRStorage.storage().referenceForURL("gs://<https://onechatter.firebaseio.com/")
//        }
        
           automaticallyAdjustsScrollViewInsets = false
        
           let newMessageArea = UIView()
            newMessageArea.backgroundColor = UIColor(red: 242/255, green: 242/255, blue: 242/255, alpha: 1)
            newMessageArea.translatesAutoresizingMaskIntoConstraints = false
            newMessageArea.layer.borderColor = UIColor(red: SHADOW_COLOR, green: SHADOW_COLOR, blue: SHADOW_COLOR, alpha: 0.5).CGColor
            newMessageArea.layer.borderWidth = 0.5
            view.addSubview(newMessageArea)
        
        newMessageField.translatesAutoresizingMaskIntoConstraints = false
        newMessageArea.addSubview(newMessageField)
        
        newMessageField.scrollEnabled = false
        
        newMessageField.layer.cornerRadius = 5
        
        newMessageField.layer.borderColor = UIColor(red: SHADOW_COLOR, green: SHADOW_COLOR, blue: SHADOW_COLOR, alpha: 0.5).CGColor
        newMessageField.layer.borderWidth = 0.5

        
        let sendButton = UIButton()
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        newMessageArea.addSubview(sendButton)
        
        sendButton.setTitle("Send", forState: .Normal)
        
        sendButton.addTarget(self, action: Selector("pressedSend:"), forControlEvents:.TouchUpInside)
        
        sendButton.setContentHuggingPriority(251, forAxis: .Horizontal)
        
        sendButton.setContentCompressionResistancePriority(751, forAxis: .Horizontal)
        
        sendButton.setTitleColor(UIColor(red: 20/255, green: 141/255, blue: 247/255, alpha: 1), forState: UIControlState.Normal)



        let image = UIImage(named: "Camera") as UIImage?
        
        let photoButton = UIButton(type: UIButtonType.Custom) as UIButton
        
        photoButton.translatesAutoresizingMaskIntoConstraints = false
        newMessageArea.addSubview(photoButton)
        
        photoButton.frame = CGRectMake(100, 100, 100, 100)
        
        
        photoButton.setImage(image, forState: .Normal)
        
        photoButton.addTarget(self, action: Selector("btnTouched:"), forControlEvents:.TouchUpInside)
        
        photoButton.setContentHuggingPriority(251, forAxis: .Horizontal)
        
        photoButton.setContentCompressionResistancePriority(751, forAxis: .Horizontal)
        
        
        bottomConstraint = newMessageArea.bottomAnchor.constraintEqualToAnchor(view.bottomAnchor)
        bottomConstraint.active = true

            
            let messageAreaConstraints:[NSLayoutConstraint] = [
                newMessageArea.leadingAnchor.constraintEqualToAnchor(view.leadingAnchor),
                newMessageArea.trailingAnchor.constraintEqualToAnchor(view.trailingAnchor),
                
                newMessageField.leadingAnchor.constraintEqualToAnchor(photoButton.trailingAnchor,constant:10),
                newMessageField.centerYAnchor.constraintEqualToAnchor(newMessageArea.centerYAnchor),
                sendButton.trailingAnchor.constraintEqualToAnchor(newMessageArea.trailingAnchor, constant:-10),
                newMessageField.trailingAnchor.constraintEqualToAnchor(sendButton.leadingAnchor,constant: -10),
                sendButton.centerYAnchor.constraintEqualToAnchor(newMessageField.centerYAnchor),
                
                photoButton.leadingAnchor.constraintEqualToAnchor(newMessageArea.leadingAnchor, constant: 10),
                
                newMessageField.leadingAnchor.constraintEqualToAnchor(photoButton.trailingAnchor,constant: 10),
                
                photoButton.centerYAnchor.constraintEqualToAnchor(newMessageField.centerYAnchor),
                

                newMessageArea.heightAnchor.constraintEqualToAnchor(newMessageField.heightAnchor, constant:20)

            ]
            
            NSLayoutConstraint.activateConstraints(messageAreaConstraints)
        

        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        tableView.registerClass(MessageCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 85.0
        tableView.rowHeight = UITableViewAutomaticDimension
        //tableView.backgroundView = UIImageView(image: UIImage(named: "MessageBubble"))
        tableView.separatorColor = UIColor.clearColor()
        tableView.sectionHeaderHeight = UITableViewAutomaticDimension
        tableView.estimatedSectionHeaderHeight = 25
        //tableView.rowHeight = UITableViewAutomaticDimension
        //view.addSubview(tableView)
        
        //tableView.translatesAutoresizingMaskIntoConstraints = false
        //view.addSubview(tableView)
        
        let tableViewConstraints: [NSLayoutConstraint] = [
            tableView.topAnchor.constraintEqualToAnchor(topLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraintEqualToAnchor(view.leadingAnchor),
            tableView.trailingAnchor.constraintEqualToAnchor(view.trailingAnchor),
            tableView.bottomAnchor.constraintEqualToAnchor(newMessageArea.topAnchor)
        ]
        
        NSLayoutConstraint.activateConstraints(tableViewConstraints)
        
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: Selector("keyboardWillShow:"),
            name: UIKeyboardWillShowNotification,
            object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: Selector("keyboardWillHide:"),
            name: UIKeyboardWillHideNotification,
            object: nil)
        
        if let mainContext = context?.parentContext ?? context{
            NSNotificationCenter.defaultCenter().addObserver(self,
                selector:Selector("contextUpdated:"),
                name:NSManagedObjectContextObjectsDidChangeNotification,
                object:mainContext)
        }

        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: "handleSingleTap:")
        tapRecognizer.numberOfTapsRequired = 1
        view.addGestureRecognizer(tapRecognizer)


    }
    
    override func viewDidAppear(animated: Bool) {
        tableView.scrollToBottom()
    }
    func btnTouched(sender: UIButton!) {
        
        print("didPressAccessoryButton")
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func keyboardWillShow(notification: NSNotification) {
        updateBottomConstraint(notification)
    }
    
    func keyboardWillHide(notification: NSNotification) {
        updateBottomConstraint(notification)
    }
    
    func handleSingleTap(recognizer: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    func updateBottomConstraint(notification: NSNotification) {
        if let
            userInfo = notification.userInfo,
            frame = userInfo[UIKeyboardFrameEndUserInfoKey]?.CGRectValue,
            animationDuration = userInfo[UIKeyboardAnimationDurationUserInfoKey]?.doubleValue {
                let newFrame = view.convertRect(frame, fromView: (UIApplication.sharedApplication().delegate?.window)!)
                bottomConstraint.constant = newFrame.origin.y - CGRectGetHeight(view.frame)
                UIView.animateWithDuration(animationDuration, animations: {
                    self.view.layoutIfNeeded()
                })
                tableView.scrollToBottom()
        }
        
    }
    func pressedSend(button:UIButton){
        guard let text = newMessageField.text where text.characters.count > 0 else {return}
        checkTemporaryContext()
        guard let context = context else {return}
        guard let message = NSEntityDescription.insertNewObjectForEntityForName("Message", inManagedObjectContext: context) as? Message else{return}

        message.text = text
        message.timestamp = NSDate()
        message.chat = chat
        chat?.lastMessageTime = message.timestamp
        
        
//        if let imageData = contact.imageData {
//            return cell.contactImage.image = UIImage(data: imageData)
//        }else{
//            return cell.imgUser.image =  UIImage(named: "imgUser")
//        }
        
        
        do {
            try context.save()
        }
        catch {
            print("There was a problem saving")
            return
        }
        newMessageField.text = ""
        
        view.endEditing(true)

    }
    
    func addMessage(message:Message){
        guard let date = message.timestamp else {return}
        let calendar = NSCalendar.currentCalendar()
        let startDay = calendar.startOfDayForDate(date)
        //we group messages by the day so we'll use the start of the day
        
        var messages = sections[startDay]
        if  messages == nil{
            dates.append(startDay)
            dates.sortInPlace{$0.earlierDate($1) == $0}
            messages = [Message]()
        }
        messages!.append(message)
        messages!.sortInPlace{$0.timestamp!.earlierDate($1.timestamp!) == $0.timestamp!}
        sections[startDay] = messages

    }
    
    func contextUpdated(notification:NSNotification){
        guard let set = (notification.userInfo![NSInsertedObjectsKey] as? NSSet) else {return}
        let objects = set.allObjects
        
        for obj in objects{
            guard let message = obj as? Message else {continue}
            if message.chat?.objectID == chat?.objectID{
                addMessage(message)
            }
        }
        
        tableView.reloadData()
        tableView.scrollToBottom()
    }
    
    func checkTemporaryContext(){
        if let mainContext = context?.parentContext, chat = chat{
            let tempContext = context
            context = mainContext
            do{
                try tempContext?.save()
            }catch{ print("Error saving tempContext") }
            self.chat = mainContext.objectWithID(chat.objectID) as? Chat
        }
    }
    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

}


//func imagePickerController(picker: UIImagePickerController,
//    didFinishPickingMediaWithInfo info: [String : AnyObject]) {
//        picker.dismissViewControllerAnimated(true, completion:nil)
//        
//        let referenceUrl = info[UIImagePickerControllerReferenceURL] as! NSURL
//        let assets = PHAsset.fetchAssetsWithALAssetURLs([referenceUrl], options: nil)
//        let asset = assets.firstObject
//        asset?.requestContentEditingInputWithOptions(nil, completionHandler: { (contentEditingInput, info) in
//            let imageFile = contentEditingInput?.fullSizeImageURL
//            let filePath = "\(FIRAuth.auth()?.currentUser?.uid)/\(Int(NSDate.timeIntervalSinceReferenceDate() * 1000))/\(referenceUrl.lastPathComponent!)"
//            let metadata = FIRStorageMetadata()
//            metadata.contentType = "image/jpeg"
//            self.storageRef.child(filePath)
//                .putFile(imageFile!, metadata: metadata) { (metadata, error) in
//                    if let error = error {
//                        print("Error uploading: \(error.description)")
//                        return
//                    }
//                    self.sendMessage([Constants.MessageFields.imageUrl: self.storageRef.child((metadata?.path)!).description])
//            }
//        })
//}

extension ChatViewController: UITableViewDataSource {
    
    func getMessages(section: Int)->[Message]{
        let date = dates[section]
        return sections[date]!
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return dates.count
    }


    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getMessages(section).count
}
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath:indexPath) as! MessageCell
        cell.separatorInset = UIEdgeInsetsMake(0, tableView.bounds.size.width, 0, 0)
        
        let messages = getMessages(indexPath.section)
        let message  = messages[indexPath.row]
        cell.messageLabel.text = message.text
        
        cell.incoming(message.isIncoming)
        
        cell.backgroundColor = UIColor.clearColor()
        
//
//        if let imageUrl = imageUrl {
//            if imageUrl.hasPrefix("gs://") {
//                FirebaseStore.storage().referenceForURL(imageUrl).dataWithMaxSize(INT64_MAX){ (data, error) in
//                    if let error = error {
//                        print("Error downloading: \(error)")
//                        return
//                    }
//                    cell.imageView?.image = UIImage.init(data: data!)
//                }
//            } else if let url = NSURL(string:imageUrl), data = NSData(contentsOfURL: url) {
//                cell.imageView?.image = UIImage.init(data: data)
//            } else {
//                cell.imageView?.image = UIImage(named: "ic_account_circle")
//                if let photoUrl = photoUrl, url = NSURL(string:photoUrl), data = NSData(contentsOfURL: url) {
//                    cell!.imageView?.image = UIImage(data: data)
//                
//                }
//            }
//        }
        return cell
    }
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.clearColor()
        let paddingView = UIView()
        view.addSubview(paddingView)
        paddingView.translatesAutoresizingMaskIntoConstraints = false
        let dateLabel = UILabel()
        paddingView.addSubview(dateLabel)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let constraints:[NSLayoutConstraint] = [
            paddingView.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor),
            paddingView.centerYAnchor.constraintEqualToAnchor(view.centerYAnchor),
            dateLabel.centerXAnchor.constraintEqualToAnchor(paddingView.centerXAnchor),
            dateLabel.centerYAnchor.constraintEqualToAnchor(paddingView.centerYAnchor),
            paddingView.heightAnchor.constraintEqualToAnchor(dateLabel.heightAnchor, constant: 5),
            paddingView.widthAnchor.constraintEqualToAnchor(dateLabel.widthAnchor, constant: 10),
            view.heightAnchor.constraintEqualToAnchor(paddingView.heightAnchor)
        ]
        NSLayoutConstraint.activateConstraints(constraints)
        
        let formatter = NSDateFormatter()
        formatter.dateFormat = "MMM dd, YYYY"
        dateLabel.text = formatter.stringFromDate(dates[section])
        dateLabel.font = dateLabel.font.fontWithSize(10)
        
        
        paddingView.layer.cornerRadius = 5
        paddingView.layer.masksToBounds = true
        paddingView.backgroundColor = UIColor(red: 153/255, green: 204/255, blue: 255/255, alpha: 1.0)
        return view
    }
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
}
extension ChatViewController: UITableViewDelegate{
    func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        guard let message = fetchedResultsController?.objectAtIndexPath(indexPath) as? Message else {return}
        context?.deleteObject(message)
    }
        }
extension ChatViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        print("whatever")
        
//        let picture = info[UIImagePickerControllerOriginalImage] as? UIImage
//        let photo = UIImage
//        messages!.append(senderId: senderId, displayName: senderDisplayName, media: picture)
        
    }
//    func deleteAll(){
//        guard let messages = fetchedResultsController?.fetchedObjects as? [Message]else {return}
//        for chat in messages{
//            context?.deleteObject(message)
//        }
//    }
  }
