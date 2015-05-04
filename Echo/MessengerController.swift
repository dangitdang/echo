//
//  MessengerController.swift
//  Echo
//
//  Created by aivanov on 05.04.15.
//  Copyright (c) 2015 Quartet. All rights reserved.
//


import UIKit

class MessengerController: ViewControllerWNav, UITableViewDataSource {
    

    @IBOutlet weak var Button1: UIButton!
    
    @IBOutlet weak var Matches: UITableView!
    
    var player: SPTAudioStreamingController!
    var user: User!
    var matchesArr : [[String]] = []
    var messages = [String : Message]()
    var activeDialogViewController : ChatMessageController!
    let rootRefURL = "https://quartetecho.firebaseio.com/"
    let messagesRef = Firebase(url: "https://quartetecho.firebaseio.com/messages")
    var roomsRef : Firebase!
    var matchPics = [String : NSURL]()
    
    override func viewDidLoad() {
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        self.player = appDelegate.player
        self.user = appDelegate.user
        self.title = "Messages"
        //self.matchesArr = self.user.messenger.getPeopleTalkingTo()
        self.activeDialogViewController = nil
        Matches.dataSource = self
    }
    func setupFirebase() {
        self.messages.removeAll(keepCapacity: false)
        self.matchesArr = []
        roomsRef = Firebase(url: "\(rootRefURL)/users/\(self.user!.id)/rooms")
        roomsRef.queryOrderedByChild("updated").queryLimitedToLast(25).observeSingleEventOfType(FEventType.Value, withBlock: { snapshot in
                var childs = snapshot.children
                for snap in childs.allObjects {
                    var tempSnap = snap as FDataSnapshot
                    var roomID = tempSnap.key
                    var messageSnapshot = tempSnap.childSnapshotForPath("last")
                    var matchID = tempSnap.value["match"] as String
                    let timestamp = messageSnapshot.value["time"] as? Double
                    let text = messageSnapshot.value["text"] as? String
                    let song = messageSnapshot.value["song"] as? String
                    let senderName = messageSnapshot.value["senderName"] as? String
                    var message = Message(text: text!, song: song!, mine: false, time: NSDate(timeIntervalSince1970: NSTimeInterval(timestamp!)))
                    var name = tempSnap.value["matchName"] as? String
                    var match = User.userFromID(matchID)!
                    self.matchPics[match.displayName] = match.picURL
                    self.messages[name!] = message
                    self.matchesArr.insert([matchID, name! , roomID!], atIndex: 0)
                }
                self.Matches.reloadData()
        })
    }
    
    override func viewWillAppear(animated: Bool) {
        setupFirebase()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.matchesArr.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var row = indexPath.row
        var match = matchesArr[row]
        //var messages = self.user.messenger.getMessages(match)
        //        if messages.last?.isSong() != true {
        //            lastMessage = messages.last!.text
        //        }
        var cell = tableView.dequeueReusableCellWithIdentifier("EchoMatchesCell", forIndexPath: indexPath) as EchoMatchesCell
        cell.matchName.text = match[1]
        cell.lastMessage.text = self.messages[match[1]]?.text
        if matchPics[match[1]] == "" {
            cell.matchIMG.image = UIImage(named: "userIcon")
        } else {
            let dataPic = NSData(contentsOfURL: matchPics[match[1]]!)
            if dataPic == nil {
               cell.matchIMG.image = UIImage(named: "userIcon")
                return cell
            }
            var img = UIImage(data: dataPic!)
            if (img != nil){
                cell.matchIMG.image = UIImage(data: NSData(contentsOfURL: self.matchPics[match[1]]!)!)
            } else {
                cell.matchIMG.image = UIImage(named: "userIcon")
            }
        }
        return cell
    }
    
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "OpenDialogSegue"){
            self.activeDialogViewController = segue.destinationViewController as ChatMessageController;
            var matchIndex = Matches.indexPathForCell(sender as EchoMatchesCell)?.row
            println(self.matchesArr[matchIndex!][0])
            println(self.matchesArr[matchIndex!][2])
            self.activeDialogViewController.matchID = self.matchesArr[matchIndex!][0]
            self.activeDialogViewController.room = self.matchesArr[matchIndex!][2]
            self.activeDialogViewController.user = self.user!
        }
//        if ([segue.identifier isEqualToString:@"OpenDialogSegue"]) {
//            self.activeDialogViewController = segue.destinationViewController;
//            NSInteger chatMateIndex = [[self.tableView indexPathForCell:(UITableViewCell *)sender] row];
//            self.activeDialogViewController.chatMateId = self.chatMatesArray[chatMateIndex];
//        return;
    }

}

