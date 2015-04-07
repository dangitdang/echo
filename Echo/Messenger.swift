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
    var time: NSDate
    
    init(text: String, song: String, mine:Bool, time: NSDate){
        self.text = text
        self.song = song
        self.mine = mine
        self.time = time
    }
    
    convenience init(text: String, mine:Bool, time:NSDate){
        self.init(text: text, song: "", mine: mine, time:time)
    }
    
    convenience init(song: String, mine:Bool, time:NSDate){
        self.init(text: "", song: song, mine: mine, time:time)
    }
    
    init(arr: [Any], my_id: String, time:NSDate){
        self.text = arr[0] as String
        self.song = arr[1] as String
        self.mine = (arr[2] as String) == my_id
        self.time = arr[3] as NSDate
    }
    
    func toArr(my_id: Int) -> [Any] {
        return [self.text, self.song, my_id, self.time]
    }
    
    func isSong() -> Bool {
        return self.song != ""
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
    
    func addRequest(user:User, song: String, songName: String, time:NSDate) -> Message {
        var message = Message(text: songName, song: song, mine: false, time:time)
        self.requests[user] = message
        self.requesters.append(user)
        return message
    }
    
    func approveRequest(user:User)  {
        var message = self.requests.removeValueForKey(user)!
        self.requesters.removeObject(user)
        self.addChat(user, song: message)
        var user_channel = PNChannel.channelWithName(user.id) as PNChannel
        var pn_message = ["type": "approve", "sender": self.user!.id, "song":message.song, "time": message.time.timeIntervalSince1970 as Double, "text": message.text]
        self.pn.sendMessage(pn_message, toChannel: user_channel)
    }
    
    func approvedRequest(user: User, song: String, songName:String, time: NSDate) -> Message {
        var message = Message(text: songName, song: song, mine: true, time:time)
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
    
    func addMessage(sender: String, text: String="", song: String="", time:NSDate) -> [AnyObject]{
        for (user, chat) in self.chats {
            if user.id == sender {
                var message = Message(text: text, song: song, mine: false, time:time)
                self.chats[user]?.append(message)
                var arr = [user, message]
                return arr
            }
        }
        return []
    }
    
    func sendRequest(to: User, song: String, songName: String, time:NSDate) {
        self.requests[to] = Message(text: songName, song: song, mine: true, time:time)
        var user_channel = PNChannel.channelWithName(to.id) as PNChannel
        var message = ["type": "request", "sender": self.user!.id, "song": song, "text":songName,"time":time.timeIntervalSince1970 as Double]
        self.pn.sendMessage(message, toChannel: user_channel)
    }
    
    func sendMessage(to: User, text: String="", song: String = "", time:NSDate){
        self.chats[to]!.append(Message(text: text, song: song, mine: true, time:time))
        var user_channel = PNChannel.channelWithName(to.id) as PNChannel
        var message = ["type": "message", "sender": self.user!.id, "song": song, "text":text, "time":time.timeIntervalSince1970 as Double]
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
                    var messages = []
                    for message in chat{
                        
                    }
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

