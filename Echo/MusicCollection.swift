//
//  MusicCollection.swift
//  Echo
//
//  Created by aivanov on 05.04.15.
//  Copyright (c) 2015 Quartet. All rights reserved.
//

import Foundation

class MusicCollection {
    var artists: [String] // list of artist names
    var songCounts: [String: Int] // Map artist -> song count
    var albums: [String: [String]] // Map artist -> array of albums
    var weights: [String: Float?]
    var albumCovers: [String: String]?
    var artistPhotos: [String:String]?
    init(artists: [String], songCounts: [String: Int], albums: [String: [String]]){
        self.artists = artists
        self.songCounts = songCounts
        self.albums = albums
        self.weights =  [String: Float?]()
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
    
    init( obj: [String:AnyObject]) {
        self.artists = obj["artists"] as [String]
        self.albums = obj["albums"] as [String: [String]]
        self.songCounts = obj["songCounts"] as [String: Int]
        self.artistPhotos = obj["artistPhotos"] as [String:String]?
        self.albumCovers = obj["albumCovers"] as [String: String]?
        self.weights =  [String: Float?]()
        
    }
    func addPhotos(artists: [String:String], albums: [String:String]){
        self.artistPhotos = artists
        self.albumCovers = albums
        self.initializeWeights()
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
    func toObject() -> [String:AnyObject] {
        var object: [String: AnyObject] = ["artists": self.artists, "albums": self.albums, "songCounts": self.songCounts, "artistPhotos": self.artistPhotos!, "albumCovers": self.albumCovers!]
        return object
    }
    
    func toJSON() -> String {
        var object: [String: AnyObject] = ["artists": self.artists, "albums": self.albums, "songCounts": self.songCounts]
        var json = JSON(object)
        return json.description
    }
    
}
