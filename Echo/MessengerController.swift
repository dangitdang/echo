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
    var matchesArr: [User]!
    
    override func viewDidLoad() {
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        self.player = appDelegate.player
        self.user = appDelegate.user
        var dang_user = User(displayName: "Dang", email: "dang@gay.com", preferences: [1,2], birthdate: "05/13/1993", country: "USA", picURL: NSURL(string:"https://scontent-ord.xx.fbcdn.net/hphotos-prn2/v/t1.0-9/45948_1264372869465_1329212_n.jpg?oh=c6872f6a9101e56fc9a0381f14b584f8&oe=55A21983")!)
        var hansa_user = User(displayName: "Hansa", email: "hansa@gay.com",  preferences: [0,1],  birthdate: "02/11/1994", country: "USA", picURL: NSURL(string:"https://scontent-ord.xx.fbcdn.net/hphotos-prn2/v/t1.0-9/555962_316795711748415_1804005466_n.jpg?oh=d271e112f4e7680d88e2ada9ea30ea7c&oe=559CF53F")!)
        //self.matchesArr = self.user.messenger.getPeopleTalkingTo()
        self.matchesArr = [dang_user,hansa_user]
        Matches.dataSource = self
    }
    @IBAction func playSong(sender: AnyObject) {
        playSong("spotify:track:5EsUREDLx9m60wzBhyo3Nj")
    }
    func playSong(uri:String) {
        player.playURIs([NSURL(string: uri)!], withOptions: nil, callback: nil)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.matchesArr.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var row = indexPath.row
        var match = self.matchesArr[row]
        //var messages = self.user.messenger.getMessages(match)
        var lastMessage = "Fuck this nigga"
        //        if messages.last?.isSong() != true {
        //            lastMessage = messages.last!.text
        //        }
        var cell = tableView.dequeueReusableCellWithIdentifier("EchoMatchesCell", forIndexPath: indexPath) as EchoMatchesCell
        cell.matchName.text = match.displayName
        cell.lastMessage.text = lastMessage
        return cell
    }

}

