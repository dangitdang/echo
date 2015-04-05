import Foundation
import Darwin


class User {
    var id: String = ""
    var birthdate: String?
    var country: String?
    var displayName: String
    var email: String
    var picURL: String?
    var musicCollection: MusicCollection
    var preferences: [Int]
    var matches: [String]
    
    init(
        displayName : String,
        email : String,
        musicCollection: MusicCollection,
        preferences: [Int],
        matches: [String] = [],
        birthdate: String? = nil,
        country: String? = nil,
        picURL: String? =  nil
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
        var user = PFObject(className: "User")
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
    
    /*
    Check if a user with given Spotify ID exists.
    Returns:
        - nil if user doesn't exist
        - User Object if user exists
    */
    class func checkIfUserExists(email: String) -> User? {
        var query = PFQuery(className: "User")
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
                matches: user.valueForKey("matches") as [String],
                birthdate: user.valueForKey("birthdate") as String?,
                country: user.valueForKey("country") as String?,
                picURL: user.valueForKey("picURL") as String?
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


class MusicCollection {
    var artists: [String] // list of artist names
    var songCounts: [String: Int] // Map artist -> song count
    var albums: [String: [String]] // Map artist -> array of albums
    var weights: [String: Float?]
    
    init(artists: [String], songCounts: [String: Int], albums: [String: [String]]){
        self.artists = artists
        self.songCounts = songCounts
        self.albums = albums
        self.weights =  [String: Float?]()
    }
    
    func initializeWeights() -> Void {
        var sum = 0
        for (artist, soungCount) in self.songCounts {
            sum += soungCount
        }
        for (artist, songCount) in self.songCounts {
            self.weights[artist] = Float(songCount)/Float(sum)
        }
    }

    func getWeight(artist:String) -> Float{
        return self.weights[artist]!!
    }
    
    func artistsInCommon(other: MusicCollection) -> [String]{
        var common: [String] = []
        for artist in self.artists{
            if contains(other.artists, artist){
                common.append(artist)
            }
        }
        return common
    }
    
    func albumsInCommon(other: MusicCollection) -> [String: [String]]{
        var commonAlbums = [String: [String]]()
        var commonArtists = self.artistsInCommon(other)
        for artist in commonArtists {
            commonAlbums[artist] = [String]()
            for album in self.albums[artist]! {
                if contains(other.albums[artist]!, album){
                    commonAlbums[artist]!.append(album)
                }
            }
        }
        return commonAlbums
    }
    
    func toJSON() -> String {
        var object: [String: AnyObject] = ["artists": self.artists, "albums": self.albums, "songCounts": self.songCounts]
        var json = JSON(object)
        return json.description
    }
    
    init(json: String){
        let data = json.dataUsingEncoding(NSUTF8StringEncoding)
        var dict = JSON(data:data!)
        self.artists = [String]()
        println(dict["artists"].arrayValue)
        if let artist_array = dict["artists"].arrayValue as [JSON]? {
            println(artist_array)
            for artist in artist_array{
                self.artists.append(artist.stringValue)
            }
        }
        self.albums = [String:[String]]()
        for artist in self.artists {
            self.albums[artist] = [String]()
            if let album_array = dict["albums"][artist].arrayValue as [JSON]?{
                for album in album_array{
                    self.albums[artist]?.append(album.stringValue)
                }
            }
        }
        self.songCounts = [String: Int]()
        for artist in self.artists{
            self.songCounts[artist] = dict["songCounts"][artist].intValue
        }
        self.weights =  [String: Float?]()
        self.initializeWeights()
    }
    
    /*
    Returns a integer - matching score from 0 to 5
    */
//    func match_score(other: MusicCollection) -> Int {
//        var commonArtists = self.artistsInCommon(other)
//        var score1: Float = 0.0; var score2 : Float = 0.0
//        for artist in commonArtists {
//            score1 += self.getWeight(artist)
//            score2 += other.getWeight(artist)
//        }
//        var score = min(score1, score2)
//        var match_score = min(Int(floor(score/0.06)),5)
//        return match_score
//    }
    
  
}
