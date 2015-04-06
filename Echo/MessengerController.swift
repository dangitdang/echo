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
        self.matchesArr = self.user.messenger.getPeopleTalkingTo()
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
        let cell = tableView.dequeueReusableCellWithIdentifier("EchoMatches", forIndexPath: indexPath) as MatchesMusicTableViewCell
        return cell
    }

    
}


func NEW_REQUEST(user:User, other_id: String, song:String){
    var other_user = User.userFromID(other_id)!
    user.messenger.addRequest(other_user, song: song)
    var messages = user.messenger.chats[other_user]!
    newRequestUpdateUI(user, other_user, user.messenger.chats[other_user]![0])
}

func newRequestUpdateUI(current_user: User, other_user: User, first_message:Message){
    // UI FOLKS: TODO
}

func APPROVED_REQUEST(user:User, other_id: String, song: String){
    var other_user = User.userFromID(other_id)!
    var message = user.messenger.approvedRequest(other_user, song: song)
    println(user.messenger.chats)
    approvedRequestUpdateUI(user, other_user, message)
}

func approvedRequestUpdateUI(current_user: User, other_user: User, first_message:Message){
    //UI FOLKS: TODO
}

func RECEIVED_MESSAGE(user:User, other_id: String, song: String, text:String){
    var out = user.messenger.addMessage(other_id, text: text, song: song)
    var other_user = out[0] as User
    var message = out[1] as Message
    receivedMessageUpdateUI(user, other_user, message)
}

func receivedMessageUpdateUI(current_user: User, other_user: User, message:Message){
    //UI FOLKS: TODO
}

