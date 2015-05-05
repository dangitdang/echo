//
//  MessageInterface.swift
//  Echo
//
//  Created by Hansa Srinivasan on 4/6/15.
//  Copyright (c) 2015 Quartet. All rights reserved.
//

func setupFirebase(user:User) {
    let rootRefURL = "https://quartetecho.firebaseio.com/"
    var reqRef = Firebase(url: "\(rootRefURL)/requests/\(user.id)")
    reqRef.queryLimitedToLast(25).observeEventType(FEventType.ChildAdded, withBlock: { (snapshot) in
        let songName = snapshot.value["songName"] as? String
        let sender = snapshot.value["sender"] as? String
        let timestamp = snapshot.value["time"] as? Double
        let song = snapshot.value["song"] as? String
        println("FIREBASE BABYYYY !@!@#")
        NEW_REQUEST(user, sender!, song!, songName!, NSDate(timeIntervalSince1970: NSTimeInterval(timestamp!)))
        //var message = Message(text: songName, song: song, mine: false, time:time)
       // var message = Message(text: songName!, song: song!, mine: false, time: NSDate(timeIntervalSince1970: NSTimeInterval(timestamp!)))
        //var other_user = User.userFromID(sender!)!
        //self.addRequest(other_user, m: message)
        //println("NEW_REQUEST done")
        
       // self.tableView.reloadData()
    })
}


func NEW_REQUEST(user:User, other_id: String, song:String, songName: String, time:NSDate){
    println("in NEW_REQUEST")
    var other_user = User.userFromID(other_id)!
    var message = user.messenger.addRequest(other_user, song: song, songName: songName, time:time)
    newRequestUpdateUI(user, other_user, message)
}

func newRequestUpdateUI(current_user: User, other_user: User, first_message:Message){
    println("in newRequestUpdateUI")
    //NSNotificationCenter.defaultCenter().postNotificationName(requestsNotificationKey, object: nil)
    //println("sending out notification")
    let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main",bundle: nil)
    var destViewController = mainStoryboard.instantiateViewControllerWithIdentifier("Requests") as RequestsController
    destViewController.addRequest(other_user, m: first_message)
}

func APPROVED_REQUEST(user:User, other_id: String, song: String, songName: String, time: NSDate){
    var other_user = User.userFromID(other_id)!
    var message = user.messenger.approvedRequest(other_user, song: song, songName: songName, time:time)
    println(user.messenger.chats)
    approvedRequestUpdateUI(user, other_user, message)
}

func approvedRequestUpdateUI(current_user: User, other_user: User, first_message:Message){
    //UI FOLKS: TODO
}

func RECEIVED_MESSAGE(user:User, other_id: String, song: String, text:String, time: NSDate){
    var out = user.messenger.addMessage(other_id, text: text, song: song, time: time)
    var other_user = out[0] as User
    var message = out[1] as Message
    receivedMessageUpdateUI(user, other_user, message)
}

func receivedMessageUpdateUI(current_user: User, other_user: User, message:Message){
    //UI FOLKS: TODO
}

