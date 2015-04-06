//
//  Messenger.swift
//  Echo
//
//  Created by aivanov on 05.04.15.
//  Copyright (c) 2015 Quartet. All rights reserved.
//

import Foundation

class Message {
    var text: String
    var song: String
    var mine: Bool
    
    init(text: String, song: String, mine:Bool){
        self.text = text
        self.song = song
        self.mine = mine
    }
    
    convenience init(text: String, mine:Bool){
        self.init(text: text, song: "", mine: mine)
    }
    
    convenience init(song: String, mine:Bool){
        self.init(text: "", song: song, mine: mine)
    }
    
    init(arr: [Any], my_id: String){
        self.text = arr[0] as String
        self.song = arr[1] as String
        self.mine = (arr[2] as String) == my_id
    }
    
    func toArr(my_id: Int) -> [Any] {
        return [self.text, self.song, my_id]
    }
    
    func isSong() -> Bool {
        return self.text == ""
    }
}


class Messenger {
    var chats: [User: [Message]]
    var requests: [User: Message]
    var chatters: [User]
    var requesters: [User]
    var pn: PubNub
    var user: User?
    init(){
        self.chats = [User:[Message]]()
        self.requests = [User: Message]()
        self.requesters = [User]()
        self.chatters = [User]()
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        self.pn = appDelegate.pubNub! as PubNub
    }
    
    func setUser(user:User){
        self.user = user
        var my_channel = PNChannel.channelWithName(user.id) as PNChannel
        self.pn.subscribeOn([my_channel])
    }
    
    func getOldMessages(){
        var pfo = self.user!.parse
        var convs = pfo?.valueForKey("conversations") as [PFObject]
        for convo in convs {
            var users = convo.valueForKey("users") as [String]
            var other_user : User
            if (users[0] == self.user!.id) {
                other_user = User.userFromID(users[1])!
            } else {
                other_user = User.userFromID(users[0])!
            }
            self.chats[other_user] = [Message]()
            var messages = convo.valueForKey("messages") as [[AnyObject]]
            for message in messages {
                
            }
        }
        
    }
    
    func addRequest(user:User, song: String) -> Message {
        var message = Message(song: song, mine: false)
        self.requests[user] = message
        self.requesters.append(user)
        return message
    }
    
    func approveRequest(user:User)  {
        var message = self.requests.removeValueForKey(user)!
        self.requesters.removeObject(user)
        self.addChat(user, song: message)
        var user_channel = PNChannel.channelWithName(user.id) as PNChannel
        var pn_message = ["type": "approve", "sender": self.user!.id, "song":message.song]
        self.pn.sendMessage(pn_message, toChannel: user_channel)
    }
    
    func approvedRequest(user: User, song: String) -> Message {
        var message = Message(song: song, mine: true)
        self.addChat(user, song: message)
        return message
    }
    
    func declineRequest(user:User){
        self.requests.removeValueForKey(user)
        self.requesters.removeObject(user)
    }
    
    
    func addChat(user:User, song:Message){
        self.chats[user] = [song]
        self.chatters.append(user)
    }
    
    func addMessage(sender: String, text: String="", song: String="") -> [AnyObject]{
        for (user, chat) in self.chats {
            if user.id == sender {
                var message = Message(text: text, song: song, mine: false)
                self.chats[user]?.append(message)
                var arr = [user, message]
                return arr
            }
        }
        return []
    }
    
    func sendRequest(to: User, song: String) {
        self.requests[to] = Message(song: song, mine: true)
        var user_channel = PNChannel.channelWithName(to.id) as PNChannel
        var message = ["type": "request", "sender": self.user!.id, "song": song]
        self.pn.sendMessage(message, toChannel: user_channel)
    }
    
    func sendMyMessage(to: User, text: String="", song: String = ""){
        self.chats[to]!.append(Message(text: text, song: song, mine: true))
        var user_channel = PNChannel.channelWithName(to.id) as PNChannel
        var message = ["type": "message", "sender": self.user!.id, "song": song]
        self.pn.sendMessage(message, toChannel: user_channel)
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
    
    func getRequests() -> [User: Message] {
        return self.requests
    }
    
    func updateRequests() {
        var out = [[String]]()
        for user in self.requesters {
            out.append([user.id, self.requests[user]!.song])
        }
        user?.parse!["requests"] = out
    }
    
    
    func updateConversations(){
        var pfo = self.user!.parse
        var convs = pfo!.valueForKey("conversations") as [PFObject]
        var foundUsers = [User]()
        for convo in convs {
            var out = [[String]]()
            var users = convo.valueForKey("users") as [String]
            var other_id : String
            if (users[0] == self.user!.id) {
                other_id = users[1]
            } else {
                other_id = users[0]
            }
            for (user, chat) in self.chats {
                if user.id == other_id {
                    foundUsers.append(user)
                }
            var messages = convo.valueForKey("messages") as [[AnyObject]]
            for message in messages {
                
            }
        }
        
        for user in self.requesters {
            out.append([user.id, self.requests[user]!.song])
        }
        }
    }
    
}

