import Foundation
import Darwin


class User {
    var id: String = ""
    var birthdate: String?
    var country: String?
    var displayName: String
    var email: String
    var picURL: NSURL?
    var musicCollection: MusicCollection
    var preferences: [Int]
    var matches: [Int: [String]]
    
    init(
        displayName : String,
        email : String,
        musicCollection: MusicCollection,
        preferences: [Int],
        matches: [Int: [String]] = [Int: [String]](),
        birthdate: String? = nil,
        country: String? = nil,
        picURL: NSURL? =  nil
    ){
        self.displayName = displayName
        self.email = email
        self.musicCollection = musicCollection
        self.birthdate = birthdate
        self.country = country
        self.picURL = picURL
        self.matches = matches
        self.preferences = preferences
    }
    
    /*
    Saves the user to the database
    */
    func store() -> Void {
        var user = PFObject(className: "EchoUser")
        user.setObject(self.displayName, forKey: "display_name")
        
        user.setObject(self.email, forKey: "email")
        user.setObject(self.birthdate, forKey: "birthdate")
        user.setObject(self.country, forKey: "country")
        user.setObject(self.matches, forKey: "mathces")
        user.setObject(self.preferences, forKey: "preferences")
        user.setObject(Date.from(year: 2000, month: 1, day: 1), forKey: "lastTimeMatched")
        var musicJSON = self.musicCollection.toJSON()
        user.setObject(musicJSON, forKey: "music")
        
        user.setObject(self.picURL, forKey: "pic")
        
        user.save()
        
    }
    
    func isMatchesEmpty() ->Bool {
        for (score, list) in self.matches {
            if (!list.isEmpty) {
                return false
            }
        }
        return true
    }
    
    func getMatches() -> Void {
        var output: NSArray = PFCloud.callFunction("findMatches", withParameters: ["email": self.email]) as NSArray
        for element in output {
            var user_id = element[0] as String
            var score = element[1] as Int
            if self.matches[score] == nil {
                self.matches[score] = [user_id]
            } else {
                self.matches[score]?.append(user_id)
            }
        }
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
            var music = MusicCollection(json: user.valueForKey("musicCollection") as String)
            return User(displayName: user.valueForKey("displayName") as String,
                email: user.valueForKey("email") as String,
                musicCollection: music,
                preferences: user.valueForKey("preferences") as [Int],
                matches: user.valueForKey("matches") as [Int:[String]],
                birthdate: user.valueForKey("birthdate") as String?,
                country: user.valueForKey("country") as String?,
                picURL: user.valueForKey("picURL") as NSURL?
            )
        }
    }
    
    
}


//func spotifyToUser(spotifyUser: SPTUser) -> User {
//    return User(
//        displayName: spotifyUser.displayName,
//        email: spotifyUser.emailAddress,
//        spid: spotifyUser.uri,
//        musicCollection: <#MusicCollection#>,
//        birthdate: <#String?#>,
//        country: spotifyUser.territory,
//        pic: spotifyUser.largestImage.imageURL)
//}


