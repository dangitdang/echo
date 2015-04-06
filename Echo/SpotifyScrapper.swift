//
//  SpotifyScrapper.swift
//  Echo
//
//  Created by Dang Pham on 3/16/15.
//  Copyright (c) 2015 Quartet. All rights reserved.
//

import Foundation


class Scrapper {
    var session:SPTSession
    var user:SPTUser
    var playlists:[String:String] = [String:String]()
    var savedSongs: SPTListPage = SPTListPage()
    var starred: SPTPlaylistSnapshot = SPTPlaylistSnapshot()
    var artists: [String] = [String]() // list of artist names
    var songCounts: [String: Int] = [String : Int]() // Map artist -> song count
    var albums: [String: [String]] = [String: [String]]() // Artist -> albums
    var JSONSerializationError: NSError? = nil
    var accessToken :String
    var userID:String
    var lastKey:String?
    var collection: MusicCollection?
    let spotifyURL = NSURL(string: "https://api.spotify.com/v1/")!
    

    init(session: SPTSession, user:SPTUser){
        self.session = session
        self.user = user
        self.accessToken = session.accessToken
        self.userID = user.canonicalUserName
//        self.retrievePlaylists()
//        self.retrieveSavedSongs()
//        self.retrieveStarred()
    }
    
    func getArtists() -> [String] {
        return self.artists
    }
    
    func getSongCounts() -> [String:Int] {
        return self.songCounts
    }
    
    func updateAlbum(artist:String, album:String) -> Void {
        objc_sync_enter(self.albums[artist])
        var albumsList = self.albums[artist]
        if albumsList != nil {
            if !contains(albumsList!, album) {
            albumsList?.append(album)
            self.albums[artist] = albumsList
            }
        } else {
            self.albums[artist] = [album]
        }
        objc_sync_exit(self.albums[artist])
    }
    func retrieveSavedSongsHelper(url:NSURL, user:User) -> Void {
        var mutableURLRequest = NSMutableURLRequest(URL: url)
        mutableURLRequest.HTTPMethod = "GET"
        mutableURLRequest.setValue("Bearer \(self.accessToken)", forHTTPHeaderField: "Authorization")
        request(mutableURLRequest).responseJSON{(request,response,data,error) in
            var raw = JSON(data!)
            if let songs=raw["items"].arrayValue as [JSON]? {
                for song in songs {
                    var name = song["track"]["name"].stringValue
                    var album = song["track"]["album"]["name"].stringValue
                    var allArtists:[String] = []
                    if let artists = song["track"]["artists"].arrayValue as [JSON]?{
                        for artist in artists {
                            var artistName = artist["name"].stringValue
                            allArtists.append(artistName)
                        }
                    }
                    self.updateAlbum(allArtists[0], album: album)
                    var artistString = " ".join(allArtists)
                    self.updateSongsCount(allArtists)
                }
            }
            if raw["next"].stringValue != "" {
                var nextString = raw["next"].stringValue
                var nextURL = NSURL(string: nextString)
                self.retrieveSavedSongsHelper(nextURL!, user: user)
            } else {
                println(self.artists)
                self.retrievePlaylist(user)
            }
        }
    }
    func retrieveSavedSongs(user: User) -> Void {
        var savedSongsURL = NSURL(string: "me/tracks", relativeToURL: spotifyURL)
        retrieveSavedSongsHelper(savedSongsURL!, user: user)
    }

    func updateSongsCount(artistsArr: [String]) -> Void {
        objc_sync_enter(artists)
        for artist in artistsArr {
            if !contains(artists,artist) {
                artists.append(artist)
            }
            var count = songCounts[artist]
            if count != nil {
                songCounts[artist] = count! + 1
            } else {
                songCounts[artist] = 1
            }
        }
        objc_sync_exit(artists)

    }
    
    func getTracksHelper(url: NSURL, ID: String,user:User) ->Void {
        var mutableURLRequest = NSMutableURLRequest(URL: url)
        mutableURLRequest.HTTPMethod = "GET"
        mutableURLRequest.setValue("Bearer \(self.accessToken)", forHTTPHeaderField: "Authorization")
        request(mutableURLRequest).responseJSON{(request,response,data,error) in
            var raw = JSON(data!)
            if let songs=raw["items"].arrayValue as [JSON]? {
                for song in songs {
                    var name = song["track"]["name"].stringValue
                    var album = song["track"]["album"]["name"].stringValue
                    var allArtists:[String] = []
                    if let artists = song["track"]["artists"].arrayValue as [JSON]?{
                        for artist in artists {
                            var artistName = artist["name"].stringValue
                            allArtists.append(artistName)
                        }
                    }
                    self.updateAlbum(allArtists[0], album: album)
                    var artistString = " ".join(allArtists)
                    self.updateSongsCount(allArtists)
                }
            }
            if raw["next"].stringValue != "" {
                var nextString = raw["next"].stringValue
                var nextURL = NSURL(string: nextString)
                    self.getTracksHelper(nextURL!, ID: ID,user :user)
            } else {
                    if ID == self.lastKey {
                        println(self.artists)
                        self.collection = self.createCollection()
                        user.musicCollection = self.collection!
                    }
            }

        }
        
    }

    func getTracks(id: String, owner: String, user:User) -> Void {
        var playlistTracksURL = NSURL(string: "users/\(owner)/playlists/\(id)/tracks", relativeToURL: spotifyURL)
        self.getTracksHelper(playlistTracksURL!, ID: id, user: user)
    }
    func updateCollectionFromPlaylist(user: User) -> Void {
        for key in self.playlists.keys {
            getTracks(key, owner: self.playlists[key]!,user: user)
        }
    }
    func retrievePlaylistsHelper(url: NSURL, user:User) -> Void {
        var mutableURLRequest = NSMutableURLRequest(URL: url)
        mutableURLRequest.HTTPMethod = "GET"
        mutableURLRequest.setValue("Bearer \(self.accessToken)", forHTTPHeaderField: "Authorization")
        request(mutableURLRequest).responseJSON{(request,response,data,error) in
            var raw = JSON(data!)
            if let playlists = raw["items"].arrayValue as [JSON]? {
                for playlist in playlists {
                    var playlistID = playlist["id"].stringValue
                    var owner = playlist["owner"]["id"].stringValue
                    self.playlists[playlistID] = owner
                }
            }
            
            if raw["next"].stringValue != "" {
                var nextString = raw["next"].stringValue
                var nextURL = NSURL(string: nextString)
                self.retrievePlaylistsHelper(nextURL!,user: user)
            } else {
                //TODO: Update run playlist
                self.lastKey = self.playlists.keys.last!
                self.updateCollectionFromPlaylist(user)
            }
        }

    }
    
    func scrape(user: User) -> Void {
        self.retrieveSavedSongs(user)
    }
    
    func retrievePlaylist(user: User) -> Void {
        var playlistsURL = NSURL(string: "users/\(self.userID)/playlists", relativeToURL: spotifyURL)
        retrievePlaylistsHelper(playlistsURL!, user: user)
    }
    func createCollection() -> MusicCollection{
            return MusicCollection(artists: artists, songCounts: songCounts, albums: albums)
    }

}