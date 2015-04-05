//
//  MusicCollectionTests.swift
//  Echo
//
//  Created by aivanov on 04.04.15.
//  Copyright (c) 2015 Quartet. All rights reserved.
//

import Foundation

import UIKit
import XCTest


class MusicCollectionTests: XCTestCase {
    
    var music_dang = MusicCollection(json: "aaa");
    var music_hansa = MusicCollection(json: "hansa");
    var dang_user = User(displayName: "Dang", email: "dang@gay.com",
        musicCollection: MusicCollection(artists: ["aa"], songCounts: ["aa":3], albums: ["aa":["aa"]]), preferences: [1,2], birthdate: "05/13/1993", country: "USA", picURL: NSURL(string: "https://scontent-ord.xx.fbcdn.net/hphotos-prn2/v/t1.0-9/45948_1264372869465_1329212_n.jpg?oh=c6872f6a9101e56fc9a0381f14b584f8&oe=55A21983"))
    var hansa_user=User(displayName: "Dang", email: "dang@gay.com",
        musicCollection:MusicCollection(json: "hansa"), preferences: [1,2], birthdate: "05/13/1993", country: "USA", picURL: NSURL(string:"https://scontent-ord.xx.fbcdn.net/hphotos-prn2/v/t1.0-9/45948_1264372869465_1329212_n.jpg?oh=c6872f6a9101e56fc9a0381f14b584f8&oe=55A21983"));
    
    override func setUp() {
        super.setUp()
        var artists = ["andrei", "hansa", "dang"]
        var albums = ["andrei": ["benim ol", "pazar kahvaltisi"], "dang":["i'm gay", "i'm high", "bears"], "hansa":["dang,dang", "love", "poop"]]
        var counts = ["andrei": 3, "hansa":15, "dang":6]
        music_dang = MusicCollection(artists: artists, songCounts: counts, albums: albums)
        
        artists = ["andrei", "dang"]
        albums = ["andrei": ["benim ol"], "dang":["i'm gay", "annie poops", "annie pees"]]
        counts = ["andrei": 10, "dang":1]
        music_hansa = MusicCollection(artists: artists, songCounts: counts, albums: albums)
        
        dang_user = User(displayName: "Dang", email: "dang@gay.com", musicCollection:music_dang, preferences: [1,2], birthdate: "05/13/1993", country: "USA", picURL: NSURL(string:"https://scontent-ord.xx.fbcdn.net/hphotos-prn2/v/t1.0-9/45948_1264372869465_1329212_n.jpg?oh=c6872f6a9101e56fc9a0381f14b584f8&oe=55A21983"))
        hansa_user = User(displayName: "Hansa", email: "hansa@gay.com", musicCollection: music_hansa, preferences: [0,1],  birthdate: "02/11/1994", country: "USA", picURL: NSURL(string:"https://scontent-ord.xx.fbcdn.net/hphotos-prn2/v/t1.0-9/555962_316795711748415_1804005466_n.jpg?oh=d271e112f4e7680d88e2ada9ea30ea7c&oe=559CF53F"))
    }
    
    func testJSON(){

        let artists = ["andrei", "hansa", "dang"]
        let albums = ["andrei": ["benim ol", "pazar kahvaltisi"], "dang":["i'm gay"]]

    
    func testFromJSON(){
        let music:String = "{ \"albums\" : { \"dang\" : [\"i'm gay\"],\"andrei\" : [\"benim ol\",\"pazar kahvaltisi\"],\"hansa\" :[\"dang,dang\",\"love\",\"poop\"]},\"songCounts\" : {\"dang\" : 2,\"andrei\" : 3,\"hansa\" : 15},\"artists\" : [\"andrei\",\"hansa\",\"dang\"]}"
        let musiccol = MusicCollection(json: music)
        println(musiccol.toJSON())
    }
    
    func testSaveUser(){
        hansa_user.store()
        dang_user.store()
    }
    
    func testMatches(){
       dang_user.getMatches()
        println(dang_user.matches)
    }
    
    
}

