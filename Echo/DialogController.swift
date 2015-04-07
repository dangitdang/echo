//
//  DialogController.swift
//  Echo
//
//  Created by Dang Pham on 4/6/15.
//  Copyright (c) 2015 Quartet. All rights reserved.
//

import Foundation
import UIKit

class DialogController : UIViewController, UITableViewDataSource {
    
    var player: SPTAudioStreamingController!
    var user: User!
    var match: User!
    var messages: [Message]!
    var fakeMessages = [String:[Message]]()
    
    var activeTextField : UITextField!
    @IBOutlet weak var messagesView: UITableView!
    
    @IBOutlet weak var textInput: UITextField!
    
    
    override func viewDidLoad() {
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        self.player = appDelegate.player
        self.user = appDelegate.user
        //self.messagesView.rowHeight = UITableViewAutomaticDimension;
        var message1 = Message(text: "Hello Hansa!", mine: true, time: NSDate())
        var message2 = Message(text: "Sup my nigga", mine: false, time: NSDate())
        
        var message3 = Message(text: "OMG YOU BITCH", mine:false, time: NSDate())
        var message4 = Message(text: "haha yup", mine: true, time: NSDate())
        self.fakeMessages["Hansa"] = [message1,message2]
        self.fakeMessages["Dang"] = [message3,message4]
        messagesView.dataSource = self
        self.getMessages()
    }
    override func viewWillAppear(animated: Bool) {

    }
    @IBAction func playSong(sender: AnyObject) {
        playSong("spotify:track:5EsUREDLx9m60wzBhyo3Nj")
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.messages.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var row = indexPath.row
        //var messages = self.user.messenger.getMessages(match)
        var cell = tableView.dequeueReusableCellWithIdentifier("MessageCell", forIndexPath: indexPath) as MessageCell
        if messages[row].mine {
            cell.userMessage.text = messages[row].text
            cell.otherMessage.hidden = true
            cell.otherPic.hidden = true
        } else {
            cell.otherMessage.text = messages[row].text
            cell.userMessage.hidden = true
            cell.userPic.hidden = true
        }
        return cell
    }
    
    func getMessages() -> Void {
        self.messages = self.fakeMessages[match.displayName]
        //self.messages = self.user.messenger.getMessages(match)
        messagesView.reloadData()
    }
    
}

