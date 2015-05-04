//
//  MessageInterface.swift
//  Echo
//
//  Created by Hansa Srinivasan on 4/6/15.
//  Copyright (c) 2015 Quartet. All rights reserved.
//


func NEW_REQUEST(user:User, other_id: String, song:String, songName: String, time:NSDate){
    var other_user = User.userFromID(other_id)!
    var message = user.messenger.addRequest(other_user, song: song, songName: songName, time:time)
    //newRequestUpdateUI(user, other_user, message)
}

func newRequestUpdateUI(current_user: User, other_user: User, first_message:Message){
    //NSNotificationCenter.defaultCenter().postNotificationName(requestsNotificationKey, object: nil)
    //println("sending out notification")
    let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main",bundle: nil)
    var destViewController = mainStoryboard.instantiateViewControllerWithIdentifier("Requests") as RequestsController
    //destViewController.addRequest(other_user, m: first_message)
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

