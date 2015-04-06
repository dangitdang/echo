import Foundation
import Darwin

func ==(lhs:User, rhs:User) -> Bool {
    return lhs.id == rhs.id
}
class User: Hashable {
    var id: String = ""
    var birthdate: String
    var country: String
    var displayName: String
    var email: String
    var picURL: NSURL?
    var musicCollection: MusicCollection?
    var preferences: [Int]
    var matches: [String: [String]]!
    var messenger: Messenger
    var parse: PFObject?
    var blurb: String
    var lastLogOut: NSDate
    var newUser: Bool
    
    var hashValue: Int {
        get{ return id.hashValue}
    }
    init(
        displayName : String,
        email : String,
        preferences: [Int],
        matches: [String: [String]] = ["1":[], "2":[], "3":[], "4":[], "5":[]],
        birthdate: String = "",
        country: String = "",
        picURL: NSURL =  NSURL(string:"")!,
        blurb: String = "",
        lastLogOut: NSDate = Date.from(year: 2000, month: 1, day: 1)!,
        newUser: Bool = true
    ){
        self.displayName = displayName
        self.email = email
        self.birthdate = birthdate
        self.country = country
        self.picURL = picURL
        self.matches = matches
        self.preferences = preferences
        self.messenger = Messenger()
        self.blurb = blurb
        self.lastLogOut = lastLogOut
        self.newUser = newUser
    }
    
    convenience init(pfo: PFObject) {
        var user = pfo
        var music = MusicCollection(obj: user.valueForKey("musicCollection") as [String:AnyObject])
        self.init(displayName: user.valueForKey("displayName") as String,
            email: user["email"] as String,
            preferences: user["preferences"] as [Int],
            matches: user["matches"] as [String:[String]],
            birthdate: user["birthdate"] as String,
            country: user["country"] as String,
            picURL: NSURL(string: user["picURL"] as String)!,
            blurb: user["blurb"] as String,
            lastLogOut: user["lastLogOut"] as NSDate)
        self.id = user.objectId
        self.setMusicCollection(music)
        self.parse = user
        self.messenger.setUser(self)
        
    }
    
    func setMusicCollection(m:MusicCollection){
        self.musicCollection = m
    }
    /*
    Saves the user to the 
        database
    */
    func store() -> Void {
        var user = PFObject(className: "EchoUser")
        user.setObject(self.displayName, forKey: "display_name")
        user.setObject(self.email, forKey: "email")
        user.setObject(self.birthdate, forKey: "birthdate")
        user.setObject(self.country, forKey: "country")
        user.setObject(self.matches, forKey: "mathces")
        user.setObject(self.preferences, forKey: "preferences")
        user.setObject([], forKey: "requests")
        user.setObject([], forKey: "conversations")
        user.setObject(self.blurb, forKey: "blurb")
        user.setObject(Date.from(year: 2000, month: 1, day: 1), forKey: "lastTimeMatched")
        user.setObject(self.lastLogOut, forKey: "lastLogOut")
        var musicJSON = self.musicCollection?.toObject()
        
        user.setObject(musicJSON, forKey: "music")
        
        user.setObject(self.picURL?.description, forKey: "pic")
        
        user.save()
        self.id = user.objectId
        self.parse = user
        self.messenger.setUser(self)
    }
    
    func save() {
        self.parse!["display_name"] = self.displayName
        self.parse!["email"] = self.email
        self.parse!["birthdate"] = self.birthdate
        self.parse!["country"] = self.country
        self.parse!["matches"] = self.matches
        self.parse!["preferences"] = self.preferences
        self.parse!["blurb"] = self.blurb
        self.parse!["lastLogOut"] = NSDate()
    }
    
    func isMatchesEmpty() ->Bool {
        for (score, list) in self.matches {
            if (!list.isEmpty) {
                return false
            }
        }
        return true
    }
    
    func getLatestMatch() -> User? {
        var scores = ["5","4","3","2","1"]
        for score in scores {
            var arr = self.matches[score]!
            if let id = arr[0] as String? {
                return User.userFromID(id)            }
        }
        return nil
    }
    
    func removeLastMatch(){
        var scores = ["5","4","3","2","1"]
        for score in scores {
            self.matches[score]!.removeAtIndex(0)
        }
    }
    
    func getMatches() -> Void {
        var output: NSArray = PFCloud.callFunction("findMatches", withParameters: ["email": self.email]) as NSArray
       
        for element in output {
             println(element)
            var user_id = element[0] as String
            var score = element[1] as String
            self.matches[score]?.append(user_id)
        }
        self.parse?.setValue(self.matches, forKey: "matches")
        self.parse?.saveInBackground()
    }
    /*
    Check if a user with given Spotify ID exists.
    Returns:
        - nil if user doesn't exist
        - User Object if user exists
    */
    class func checkIfUserExists(email: String) -> User? {
        var query = PFQuery(className: "EchoUser")
        query.whereKey("email", equalTo: email)
        var objects = query.findObjects()
        if (objects.count == 0) {
            return nil
        } else {
            var user = objects[0] as PFObject
            return User(pfo:user)
        }
    }
    
    class func userFromID(id: String) -> User? {
        var query = PFQuery(className: "EchoUser")
        var user = query.getObjectWithId(id)
        return User(pfo:user)
    }
    
    
    
}


