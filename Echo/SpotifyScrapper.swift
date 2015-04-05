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
    var playlists: SPTPlaylistList = SPTPlaylistList()
    var savedSongs: SPTListPage = SPTListPage()
    var starred: SPTPlaylistSnapshot = SPTPlaylistSnapshot()
    var artists: [String] = [String]() // list of artist names
    var songCounts: [String: Int] = [String : Int]() // Map artist -> song count
    var albums: [String: [String]] = [String: [String]]() // Artist -> albums
    
    init(session: SPTSession, user:SPTUser){
        self.session = session
        self.user = user
//        self.retrievePlaylists()
//        self.retrieveSavedSongs()
//        self.retrieveStarred()
    }
    
    func retrievePlaylists() -> Void {
        SPTRequest.playlistsForUserInSession(self.session, callback: {
            (error:NSError!, playlists:AnyObject!) -> Void in
            if error != nil {
                println("error retrieving playlist")
            } else {
                self.playlists = playlists as SPTPlaylistList
                self.extractArtistsFromPlaylists()
            }
        })
    }
    func getArtists() -> [String] {
        return self.artists
    }
    func getSongCounts() -> [String:Int] {
        return self.songCounts
    }
    
    
    func retrieveSavedSongs() -> Void {
        SPTRequest.savedTracksForUserInSession(self.session, callback: {
            (error:NSError!, saved:AnyObject!) -> Void in
            if error != nil {
                println("error retrieving saved songs")
            } else {
                self.savedSongs = saved as SPTListPage
                self.savedSongs.requestNextPageWithSession(self.session, callback: {(error: NSError!, savedtracks: AnyObject!) -> Void in
                    self.savedSongs = savedtracks as SPTListPage
                    self.extractArtistsFromSaved()
                })
            }
        })
    }
    func updateSongsCount(artist: SPTPartialArtist) -> Void {
        var id = artist.identifier
        if !contains(artists,id) {
            artists.append(id)
        }
        
        var count = songCounts[id]
        if count != nil {
            songCounts[id] = count! + 1
        } else {
            songCounts[id] = 0
        }
    }
    
    func scrapePlaylist(playlist: SPTPlaylistSnapshot) -> Void {
        println(playlist)
        var firstTracks = playlist.firstTrackPage
        var songs = firstTracks as SPTListPage
        for song in songs.items {
            var track = song as SPTPartialTrack
            for artist in track.artists {
                updateSongsCount(artist as SPTPartialArtist)
            }
        }
    }
//    
//    func retrieveStarred() -> Void {
//        SPTRequest.sta(self.session, callback: { (error:NSError!, starred: AnyObject!) -> Void in
//            if error != nil {
//                println("error retrieving starred playlist")
//            } else {
//                self.starred = starred as SPTPlaylistSnapshot
//                self.extractStarredSongs()
//            }
//        })
//    }
    
    func extractArtistsFromSaved() -> Void {
        println(savedSongs)
        
        var savedItems = savedSongs
        println(savedItems.range)
        for item in savedItems.items{
            var song = item as SPTSavedTrack
            var songArtists = song.artists
            for singer in songArtists {
                var current = singer as SPTPartialArtist
                updateSongsCount(current)
            }
        }
        if savedSongs.hasNextPage {
            savedSongs.requestNextPageWithSession(session, callback: {(error: NSError!, nextSaved: AnyObject!) -> Void in
                if error != nil {
                    println("error retrieving next saved songs")
                } else {
                    self.savedSongs = nextSaved as SPTListPage
                    self.extractArtistsFromSaved()
                }
            })
        }
    }
    
    func extractArtistsFromPlaylists() -> Void {
        var userPlaylists = playlists.items
        println(userPlaylists)
        for item in userPlaylists {
            var curItem = item as SPTPartialPlaylist
            SPTRequest.requestItemFromPartialObject(curItem, withSession: session, callback:
                {( error: NSError! , fullPlaylist: AnyObject!) -> Void in
                    if error != nil {
                        println("error retrieving playlist")
                    } else {
                        self.scrapePlaylist(fullPlaylist as SPTPlaylistSnapshot)
                    }
            })
        }
    }
    
    func extractStarredSongs() -> Void {
        self.scrapePlaylist(self.starred)
    }
}