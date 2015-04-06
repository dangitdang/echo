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
    var mine: Bool
    
    init(text: String?, song: String?, mine:Bool){
        self.text = text
        self.song = song
        self.mine = mine
    }
    
    convenience init(text: String, mine:Bool){
        self.init(text: text, song: nil, mine: mine)
    }
    
    convenience init(song: String, mine:Bool){
        self.init(text: nil, song: song, mine: mine)
    }
    
    init(arr: [Any], my_index: Int){
        self.text = arr[0] as? String
        self.song = arr[1] as? String
        self.mine = (arr[2] as Int) == my_index
    }
    
    func toArr(my_index: Int) -> [Any] {
        var index = self.mine ? my_index : (my_index+1)%2
        return [self.text, self.song, index]
    }
    
    func isSong() -> Bool {
        return self.text == nil
    }
}


class Messenger {
    var chats: [User: [Message]]
    var requests: [User: String]
    var my_indices: [User: Int]
    init(){
        self.chats = [User:[Message]]()
        self.requests = [User:String]()
        self.my_indices = [User:Int]()
    }
    
    init(user:User) {
        var pfo = user.parse
        var convs = pfo?.valueForKey("conversations") as [PFObject]
        self.chats = [User:[Message]]()
        self.requests = [User:String]()
        self.my_indices = [User:Int]()
        for convo in convs {
            var users = convo.valueForKey("users") as [String]
            var my_index = 0
            var other_user = user
            if (users[0] == user.id) {
                my_index = 0
                other_user = User.userFromID(users[1])!
            } else {
                my_index = 1
                other_user = User.userFromID(users[0])!
            }
            self.chats[other_user] = [Message]()
            self.my_indices[other_user] = my_index
            var messages = convo.valueForKey("messages") as [[AnyObject]]
            for message in messages {
                
            }
        }
        
    }
    
    func addRequest(user:User, song: String){
        self.requests[user] = song
    }
    
    func approveRequest(user:User) {
        var song = self.requests.removeValueForKey(user)!
        self.addChat(user, song: Message(song: song, mine: false))
        //CALL SENDER
    }
    
    func declieRequest(user:User){
        self.requests.removeValueForKey(user)
    }
    
    
    func addChat(user:User, song:Message){
        self.chats[user] = [song]
    }
    
    func addMessage(sender: String, text: String?, song: String?){
        for (user, chat) in self.chats {
            if user.id == sender {
                self.chats[user]?.append(Message(text: text, song: song, mine: false))
            }
        }
    }
    
    func sendRequest(to: User, song: String) {
        self.requests[to] = song
        // CALL SENDER
        
    }
    
    func sendMyMessage(user: User, text: String?, song: String?){
        self.chats[user]?.append(Message(text: text, song: song, mine: true))
        //CALL SENDER
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

