//
//  MessengerController.swift
//  Echo
//
//  Created by aivanov on 05.04.15.
//  Copyright (c) 2015 Quartet. All rights reserved.
//

import Foundation


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
