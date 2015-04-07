//
//  RequestsController.swift
//  Echo
//
//  Created by Hansa Srinivasan on 4/6/15.
//  Copyright (c) 2015 Quartet. All rights reserved.
//

import UIKit

class RequestsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var personPic: UIImageView!
    
    @IBOutlet weak var personName: UILabel!
    
    @IBOutlet weak var playPauseButton: UIButton!
    
    @IBOutlet weak var songName: UILabel!
    
    @IBOutlet weak var acceptButton: UIButton!
    
    @IBOutlet weak var declineButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}

class RequestsController: ViewControllerWNav, UITableViewDataSource, UITableViewDelegate {
    var userList: [User] = []
    var songList = [User: Message]()
    
    var player: SPTAudioStreamingController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        
        userList = appDelegate.user.messenger.getPeopleRequested()
        songList = appDelegate.user.messenger.getRequests()
        
        if (appDelegate.product == SPTProduct.Premium) {
            self.player = appDelegate.player
        }
        
//        //andrei: aivanov@mit.edu harini: harinisuresh94@yahoo.com dang: dpham279@gmail.com hansa: agent.candykid@gmail.com
//        var andrei = User.checkIfUserExists("aivanov@mit.edu") as User!
//        var harini = User.checkIfUserExists("harinisuresh94@yahoo.com") as User!
//        var dang = User.checkIfUserExists("dpham279@gmail.com") as User!
//        var hansa = User.checkIfUserExists("agent.candykid@gmail.com") as User!
//        
//        if (andrei != nil) {
//            userList.append(andrei)
//            songList[andrei] = Message(text:"Often", song: "4AILWMTyKIlicSfDVNtZQD", mine: false, time: NSDate())
//        }
//        if (harini != nil) {
//            userList.append(harini)
//            songList[harini] = Message(text: "Irrisistable", song: "3znPiywA0q1VK2jgAZFDoI", mine: false, time: NSDate())
//        }
//        if (dang != nil) {
//            userList.append(dang)
//            songList[dang] = Message(text: "Novocaine", song: "5F0bmCjKUufNz1bHXfgRwe", mine: false, time: NSDate())
//        }
//        if (hansa != nil) {
//            userList.append(hansa)
//            songList[hansa] = Message(text: "Just One Yesterday", song: "0l2p5mDOP3czJ2FpD6zWie", mine: false, time: NSDate())
//        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userList.count
    }
 
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var row = indexPath.row
        let cell = tableView.dequeueReusableCellWithIdentifier("RequestsTableViewCell") as RequestsTableViewCell
        var currUser = userList[row]
        let url = currUser.picURL as NSURL!
        if (url != "") {
            let dataForPic = NSData(contentsOfURL: url!)
            var image = UIImage(data: dataForPic!)
            if (image != nil) {
              cell.personPic.image = image!
            }
        }
        cell.personName.text = currUser.displayName
        var message = songList[userList[row]] as Message!
        cell.songName.text = message.text
        
        cell.playPauseButton.tag = row
        cell.playPauseButton.targetForAction("playOrPause", withSender: self)
        cell.playPauseButton.addTarget(self, action: "playOrPause:", forControlEvents: .TouchUpInside)
        cell.playPauseButton.setImage(UIImage(named: "Pause"), forState: UIControlState.Selected);

        //println(cell.playPauseButton.tag)
        
        cell.acceptButton.tag = row
        cell.playPauseButton.targetForAction("acceptRequest", withSender: self)
        cell.playPauseButton.addTarget(self, action: "acceptRequest:", forControlEvents: .TouchUpInside)
        
        
        cell.declineButton.tag = row
        cell.playPauseButton.targetForAction("declineRequest", withSender: self)
        cell.playPauseButton.addTarget(self, action: "declineRequest:", forControlEvents: .TouchUpInside)
        
        return cell
    }
    
    func addRequest(user: User, m: Message) {
        println("ADDING REQUEST")
        //var obj = sender?
        //println(obj)
        //userList.append(user)
        //songList[user] = message
    }
    
    func playOrPause(sender: UIButton!) {
        
        var buttonTag = sender.tag
        //println(buttonTag)
        sender.selected = !sender.selected
        var songMessage = songList[userList[buttonTag]] as Message!
        //println(songMessage.song)
        
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        if (appDelegate.product == SPTProduct.Premium) {
            if (sender.selected) {
                var url = "spotify:track:" + songMessage.song
                self.player.playURIs([NSURL(string: url)!], withOptions: nil, callback: nil)
            } else {
                self.player.stop({ (error:NSError!) -> Void in
                    if error != nil {
                        println("error stopping")
                    }
                })
            }
        }
    }
    
    func acceptRequest(sender: UIButton!) {
        var buttonTag = sender.tag
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        appDelegate.user.messenger.approveRequest(userList[buttonTag])
        songList.removeValueForKey(userList[buttonTag])
        userList.removeObject(userList[buttonTag])
        
    }
    
    func declineRequest(sender: UIButton!) {
        var buttonTag = sender.tag
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        appDelegate.user.messenger.approveRequest(userList[buttonTag])
        songList.removeValueForKey(userList[buttonTag])
        userList.removeObject(userList[buttonTag])
    }
    
}