//
//  ViewController.swift
//  Echo
//
//  Created by Dang Pham on 3/1/15.
//  Copyright (c) 2015 Quartet. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, SPTAuthViewDelegate, SPTAudioStreamingPlaybackDelegate {
    
    
    let ClientID = "782ed7079eef47cdb3d0d21df4cc9db3"
    let CallbackURL = "echo://returnAfterLogin"
    let kTokenSwapURL = "http://mysterious-waters-9692.herokuapp.com/swap"
    let kTokenRefreshServiceURL = "http://mysterious-waters-9692.herokuapp.com/refresh"
    let auth = SPTAuth.defaultInstance()
    
    @IBOutlet weak var loginButton: UIButton!
    
    
    var session:SPTSession!
    var user: SPTUser!
    var collection: MusicCollection!
    var player: SPTAudioStreamingController!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func updateAfterFirstLogin () {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        
        if let sessionObj:AnyObject = userDefaults.objectForKey("SpotifySession") {
            let sessionDataObj = sessionObj as NSData
            let firstTimeSession = NSKeyedUnarchiver.unarchiveObjectWithData(sessionDataObj) as SPTSession
            self.session = firstTimeSession
            SPTRequest.userInformationForUserInSession(self.session, callback:
                {(error: NSError!, userInfo: AnyObject!) -> Void in
                    self.user = userInfo as SPTUser
                    println(self.user)
                    println(self.user.displayName)
                    println(self.user.followerCount)
                    //println(self.user.largestImage.imageURL)
                    
                    })
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @IBAction func loginWithSpotify(sender: AnyObject) {
        auth.clientID = ClientID
        auth.requestedScopes = [SPTAuthStreamingScope,SPTAuthUserReadEmailScope,SPTAuthUserLibraryReadScope,SPTAuthUserReadPrivateScope,SPTAuthPlaylistReadPrivateScope,SPTAuthPlaylistModifyPrivateScope,SPTAuthPlaylistModifyPublicScope]
        auth.redirectURL = NSURL(string: CallbackURL)
        auth.tokenSwapURL = NSURL(string: kTokenSwapURL)
        auth.tokenRefreshURL = NSURL(string: kTokenRefreshServiceURL)
        
        let authView = SPTAuthViewController.authenticationViewController()
        authView.delegate = self
        authView.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
        authView.definesPresentationContext = true
        presentViewController(authView, animated: false, completion: nil)
    }
    
    func authenticationViewController(authenticationViewController: SPTAuthViewController!, didLoginWithSession session: SPTSession!) {
        self.session = session
        println("session valid")
        SPTRequest.userInformationForUserInSession(self.session, callback: {(error: NSError!, user: AnyObject!) -> Void in
            if error != nil {
                println("error lmao")
            } else {
                self.user = user as SPTUser
                println(self.user.emailAddress)
                var scrapper = Scrapper(session: self.session, user: self.user)
                
                //var scrapper = Scrapper(session: self.session, user: self.user)
                //scrapper.retrievePlaylists()
                
                let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
                appDelegate.scraper = scrapper
                appDelegate.session = self.session
                var prefs: [Int] = []
                var a: [String] = []
                var sc: [String: Int] = ["":0]
                var alb: [String: [String]] = ["":[]]
                var musicCollec = MusicCollection(artists: a, songCounts: sc, albums: alb);
                println(self.user.emailAddress)
                
                var username: String
                if (self.user.displayName == nil || self.user.displayName == "<null>") {
                    println("here")
                    println(self.user.canonicalUserName)
                    username = self.user.canonicalUserName
                } else {
                    username = self.user.displayName
                }
                
                
                
                appDelegate.user = User(displayName: username, email: self.user.emailAddress, preferences: prefs)
                if (self.user.largestImage != nil){
                    appDelegate.user?.picURL = self.user.largestImage.imageURL
                }

                
                var userOb = User.checkIfUserExists(self.user.emailAddress) as User?
                if (userOb == nil) {
                    println("DOESNT EXIST")
                    appDelegate.user?.newUser = true
                    scrapper.scrape(appDelegate.user)
                } else {
                    println("Exists")
                    appDelegate.user?.newUser = false
                    appDelegate.user = userOb
                }
                self.performSegueWithIdentifier("leaveLogIn", sender: nil)
                println(self.user.product)
                appDelegate.product = self.user.product
                if self.user.product == SPTProduct.Premium {
                    self.setupSpotifyPlayer()
                    appDelegate.player = self.player
                    self.loginWithSpotifySession(self.session)
                }
                
                
            }
        })
    }
    
    func authenticationViewControllerDidCancelLogin(authenticationViewController: SPTAuthViewController!) {
        println("login cancelled")
    }
    
    func authenticationViewController(authenticationViewController: SPTAuthViewController!, didFailToLogin error: NSError!) {
        println("login failed")
    }
    
    
    func setupSpotifyPlayer() {
        self.player = SPTAudioStreamingController(clientId: ClientID)
        self.player!.playbackDelegate = self
        self.player!.diskCache = SPTDiskCache(capacity: 1024 * 1024 * 64)
    }
    
    func loginWithSpotifySession(session: SPTSession) {
        self.player!.loginWithSession(session, callback: { (error: NSError!) in

            if error != nil {
                println("Couldn't login with session: \(error)")
                return
            }
            //self.useLoggedInPermissions()
        })
    }
    
    func useLoggedInPermissions() {
        let spotifyURI = "spotify:track:1WJk986df8mpqpktoktlce"
        player!.playURIs([NSURL(string: spotifyURI)!], withOptions: nil, callback: nil)
    }
}

