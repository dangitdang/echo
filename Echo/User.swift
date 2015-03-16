//
//  User.swift
//  Echo
//
//  Created by aivanov on 14.03.15.
//  Copyright (c) 2015 Quartet. All rights reserved.
//

import Foundation
import Darwin

class User {
    var id: String = ""
    var birthdate: String?
    var country: String?
    var displayName: String
    var email: String
    var spid: String
    var pic: UIImage?
    var musicCollection: MusicCollection
    
    init(
        displayName : String,
        email : String,
        spid: String,
        musicCollection: MusicCollection,
        birthdate: String? = nil,
        country: String? = nil,
        pic: UIImage? = nil
    ){
        self.displayName = displayName
        self.email = email
        self.spid = spid
        self.musicCollection = musicCollection
        self.birthdate = birthdate
        self.country = country
        self.pic = pic
    }
    
    /*
    Saves the user to the database
    */
    func store() -> Void {
        var user = PFObject(className: "User")
        user.setObject(self.displayName, forKey: "display_name")
        
        user.setObject(self.email, forKey: "email")
        user.setObject(self.spid, forKey: "spid")
        user.setObject(self.birthdate, forKey: "birthdate")
        user.setObject(self.country, forKey: "country")
        
        var music_data = NSKeyedArchiver.archivedDataWithRootObject(self.musicCollection)
        user.setObject(music_data, forKey: "music_collection")
        //save image
        var imageData = UIImageJPEGRepresentation(self.pic, 0.8);
        var picFile = PFFile(data: imageData)
        picFile.saveInBackground()
        user.setObject(picFile, forKey: "pic")
        
        user.saveInBackground()
    }
    
    /*
    Check if a user with given Spotify ID exists.
    Returns:
        - nil if user doesn't exist
        - User Object if user exists
    */
    class func checkIfUserExists(spid: String) -> User? {
        var query = PFQuery(className: "User")
        query.whereKey("spid", equalTo: spid)
        var objects = query.findObjects()
        if (objects.count == 0) {
            return nil
        } else {
            var user = objects[0] as PFObject
            var picFile = user.valueForKey("pic") as PFFile
            var pic = UIImage(data: picFile.getData())
            return User(displayName: user.valueForKey("displayName") as String,
                email: user.valueForKey("email") as String,
                spid: user.valueForKey("spid") as String,
                musicCollection: user.valueForKey("musicCollection") as MusicCollection,
                birthdate: user.valueForKey("birthdate") as String?,
                country: user.valueForKey("country") as String?,
                pic: pic)
            
        }
    }
    
    
}


class MusicCollection {
    var artists: [String] // list of artist names
    var songCounts: [String: Int] // Map artist -> song count
    var albums: [String: [String]] // Map artist -> array of albums
    var weights: [String: Float?]
    
    init(artists: [String], songCounts: [String: Int], albums: [String: [String]]){
        self.artists = artists
        self.songCounts = songCounts
        self.albums = albums
        
        var sum = 0
        for (artist, soungCount) in self.songCounts {
            sum += soungCount
        }
        self.weights =  [String: Float?]()
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
    
    /*
    Returns a integer - matching score from 0 to 5
    */
    func match_score(other: MusicCollection) -> Int {
        var commonArtists = self.artistsInCommon(other)
        var score1: Float = 0.0; var score2 : Float = 0.0
        for artist in commonArtists {
            score1 += self.getWeight(artist)
            score2 += other.getWeight(artist)
        }
        var score = min(score1, score2)
        var match_score = min(Int(floor(score/0.06)),5)
        return match_score
    }
    
    func encodeWithCoder(aCoder: NSCoder) -> Void {
        aCoder.encodeObject(artists)
    }
    //class Func
}