//
//  ChatMessageController.swift
//  Echo
//
//  Created by Dang Pham on 4/7/15.
//  Copyright (c) 2015 Quartet. All rights reserved.
//

import Foundation
import UIKit

class ChatMessageController : JSQMessagesViewController {
    var user: User!
    var messages = [JSQMessage]()
    var avatars = [String: JSQMessagesAvatarImage]()
    var outgoingBubbleImageView = JSQMessagesBubbleImageFactory().outgoingMessagesBubbleImageWithColor(UIColor.jsq_messageBubbleLightGrayColor())
    var incomingBubbleImageView = JSQMessagesBubbleImageFactory().incomingMessagesBubbleImageWithColor(UIColor.jsq_messageBubbleGreenColor())
    var senderImage: String!
    var matchID : String!
    var match: User!
    var room : String!
    var batchMessages = true
    var fakeMessages = [String:[Message]]()
    let rootRefURL = "https://quartetecho.firebaseio.com/"
    
    var roomRef : Firebase!
    
    func setupAvatarImage(name: String, imageUrl: String?, incoming: Bool) {
        if let stringUrl = imageUrl {
            if let url = NSURL(string: stringUrl) {
                if let data = NSData(contentsOfURL: url) {
                    let image = UIImage(data: data)
                    let diameter = incoming ? UInt(collectionView.collectionViewLayout.incomingAvatarViewSize.width) : UInt(collectionView.collectionViewLayout.outgoingAvatarViewSize.width)
                    let avatarImage = JSQMessagesAvatarImageFactory.avatarImageWithImage(image, diameter: diameter)
                    avatars[name] = avatarImage
                    return
                }
            }
        }
        
        // At some point, we failed at getting the image (probably broken URL), so default to avatarColor
        setupAvatarColor(name, incoming: incoming)
    }
    
    func setupFirebase() {
        var userRef = Firebase(url:"\(rootRefURL)/user/\(user.id)")
        var messageRef = Firebase(url: "\(rootRefURL)/messages")
        var roomRef = messageRef.childByAppendingPath(room)
        roomRef.queryLimitedToLast(25).observeEventType(FEventType.ChildAdded, withBlock: { (snapshot) in
            let text = snapshot.value["text"] as? String
            let sender = snapshot.value["sender"] as? String
            let senderName = snapshot.value["senderName"] as? String
            let timestamp = snapshot.value["time"] as? Double
            let song = snapshot.value["song"] as? String
            let isSong = snapshot.value["isSong"] as? Bool
            var convertedMessage = JSQMessage(senderId: sender, senderDisplayName: senderName, date: NSDate(timeIntervalSince1970: NSTimeInterval(timestamp!)), text: text)
            self.messages.append(convertedMessage)
            self.finishReceivingMessage()
        })
    }
    
    func sendMessage(text: String = "", song: String = "") {
        user.messenger.sendFirebaseMessage(match, room: room, text: text, song: song)
    }
    
    func tempSendMessage(text: String = "", song: String = "") {
        let tempMess = JSQMessage(senderId: user.id, senderDisplayName: user.displayName, date: NSDate() , text: text)
        messages.append(tempMess)
    }
    
//    func getMessages() {
//        //var rawMessages = user.messenger.getMessages(match)
//        var rawMessages = messages[match.displayName]
//        for message in rawMessages! {
//            var tempSender = message.mine ? user : match
//            var convertedMessage = JSQMessage(senderId: tempSender.id, senderDisplayName: tempSender.displayName, date: message.time, text: message.text)
//            self.messages.append(convertedMessage)
//        }
//        self.finishReceivingMessage()
//    }
    func setupAvatarColor(name: String, incoming: Bool) {
        let diameter = incoming ? UInt(collectionView.collectionViewLayout.incomingAvatarViewSize.width) : UInt(collectionView.collectionViewLayout.outgoingAvatarViewSize.width)
        
        let rgbValue = name.hash
        let r = CGFloat(Float((rgbValue & 0xFF0000) >> 16)/255.0)
        let g = CGFloat(Float((rgbValue & 0xFF00) >> 8)/255.0)
        let b = CGFloat(Float(rgbValue & 0xFF)/255.0)
        let color = UIColor(red: r, green: g, blue: b, alpha: 0.5)
        
        let nameLength = countElements(name)
        let initials : String? = name.substringToIndex(advance(name.startIndex, min(3, nameLength)))
        let userImage = JSQMessagesAvatarImageFactory.avatarImageWithUserInitials(initials, backgroundColor: color, textColor: UIColor.blackColor(), font: UIFont.systemFontOfSize(CGFloat(13)), diameter: diameter)
        
        avatars[name] = userImage
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        match = User.userFromID(matchID)
        self.title = match.displayName
        automaticallyScrollsToMostRecentMessage = true
        senderDisplayName = user.displayName
        senderId = user.id
        var sendSong = UIButton()
        sendSong.setImage(UIImage(named: "sendSongChat") , forState: UIControlState.Normal)
        sendSong.targetForAction("didPressAccessoryButton", withSender: self)
        self.inputToolbar.contentView.leftBarButtonItem = sendSong
        self.inputToolbar.contentView.rightBarButtonItem.setImage(UIImage(named: "sendMessage"), forState:UIControlState.Normal)
        
        let profileImageUrl = user.picURL?.description
        if let urlString = profileImageUrl {
            setupAvatarImage(senderDisplayName, imageUrl: urlString, incoming: false)
        } else {
            setupAvatarColor(senderDisplayName, incoming: false)
        }
        setupFirebase()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        collectionView.collectionViewLayout.springinessEnabled = true
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func didPressSendButton(button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: NSDate!) {
        sendMessage(text: text)
        finishSendingMessage()
    }
    
    override func didPressAccessoryButton(sender: UIButton!) {
        //TODO Music button pressed!
        println("pressed!")
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageData! {
        return messages[indexPath.item]
    }
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageBubbleImageDataSource! {
            let message = messages[indexPath.item]
            
            if message.senderDisplayName == senderDisplayName {
                return outgoingBubbleImageView
            }
            
            return incomingBubbleImageView
    }
    override func collectionView(collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageAvatarImageDataSource! {
        let message = messages[indexPath.item]
        if let avatar = avatars[message.senderDisplayName] {
            return avatar
        } else {
            if message.senderDisplayName == senderDisplayName {
                setupAvatarImage(senderDisplayName, imageUrl: user.picURL?.description, incoming:true)
                return avatars[senderDisplayName]
            } else {
                setupAvatarImage(message.senderDisplayName, imageUrl: match.picURL?.description, incoming:true)
                return avatars[message.senderDisplayName]
            }
        }
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAtIndexPath: indexPath) as JSQMessagesCollectionViewCell
        
        let message = messages[indexPath.item]
        if message.senderDisplayName == senderDisplayName{
            cell.textView.textColor = UIColor.blackColor()
        } else {
            cell.textView.textColor = UIColor.whiteColor()
        }
        
        let attributes : [NSObject:AnyObject] = [NSForegroundColorAttributeName:cell.textView.textColor, NSUnderlineStyleAttributeName: 1]
        cell.textView.linkTextAttributes = attributes
        
        return cell
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, attributedTextForMessageBubbleTopLabelAtIndexPath indexPath: NSIndexPath!) -> NSAttributedString! {
        let message = messages[indexPath.item];
        
        // Sent by me, skip
        if message.senderDisplayName == senderDisplayName {
            return nil;
        }
        
        // Same as previous sender, skip
        if indexPath.item > 0 {
            let previousMessage = messages[indexPath.item - 1];
            if previousMessage.senderDisplayName == message.senderDisplayName {
                return nil;
            }
        }
        
        return NSAttributedString(string:message.senderDisplayName)
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForMessageBubbleTopLabelAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        let message = messages[indexPath.item]
        
        // Sent by me, skip
        if message.senderDisplayName == senderDisplayName {
            return CGFloat(0.0);
        }
        
        // Same as previous sender, skip
        if indexPath.item > 0 {
            let previousMessage = messages[indexPath.item - 1];
            if previousMessage.senderDisplayName == message.senderDisplayName {
                return CGFloat(0.0);
            }
        }
        
        return kJSQMessagesCollectionViewCellLabelHeightDefault
    }
    
}