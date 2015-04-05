//
//  Messenger.swift
//  Echo
//
//  Created by aivanov on 05.04.15.
//  Copyright (c) 2015 Quartet. All rights reserved.
//

import Foundation

class Message {
    var text: String?
    var song: String?
    var sender: User?
    
    init(text: String, sender: User){
        self.text = text
        self.sender = sender
        self.song = nil
    }
    
    init(song: String, sender:User){
        self.text = nil
        self.sender = sender
        self.song = song
    }
    
    init(arr: [String]){
        self.text = arr[0]
        self.song = arr[1]
        self.sender = User.userFromID(arr[2])
    }
    
    func isSong() -> Bool {
        return self.text == nil
    }
}

class Messenger {
    var chats: [User: [Message]]
    var requests: [User: Message]
    
    init(){
        self.chats = [User:[Message]]()
        self.requests = [User:Message]()
    }
    
    func addRequest(user:User, request:Message){
        self.requests[user] = request
    }
    
    func approveRequest(user:User) {
        self.addChat(user, request: self.requests.removeValueForKey(user)!)
    }
    
    func declieRequest(user:User){
        self.requests.removeValueForKey(user)
    }
    
    
    func addChat(user:User, request:Message){
        self.chats[user] = [request]
    }
    
    func addMessage(message:Message){
        self.chats[message.sender!]?.append(message)
    }
    
    func getMessages(user:User) -> [Message]{
        return self.chats[user]!
    }
    
    func blockUser(user:User){
        self.chats.removeValueForKey(user)
    }
    
    func getPeopleTalkingTo() -> [User]{
        return self.chats.keys.array
    }
    
    func getPeopleRequested() -> [User]{
        return self.requests.keys.array
    }
}