//
//  SpotifyScrapper.swift
//  Echo
//
//  Created by Dang Pham on 3/16/15.
//  Copyright (c) 2015 Quartet. All rights reserved.
//

import Foundation


class Scapper {
    var session:SPTSession
    var user:SPTUser
    
    init(session: SPTSession, user:SPTUser){
        self.session = session
        self.user = user
    }
    
//    func getPlaylists() -> SPTPlaylistList {
//        SPTRequest.playlistsForUserInSession(self.session, callback:{
//            (error:NSError!, playlists: !AnyObject) -> SPTPlaylistList
//            
//        })
//    }
//    
    
}