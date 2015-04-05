//
//  ViewController.swift
//  Echo
//
//  Created by Dang Pham on 3/1/15.
//  Copyright (c) 2015 Quartet. All rights reserved.
//

import UIKit




class ViewController: UIViewController {
    
    
    let ClientID = "782ed7079eef47cdb3d0d21df4cc9db3"
    let CallbackURL = "echo://returnAfterLogin"
    let kTokenSwapURL = "http://mysterious-waters-9692.herokuapp.com/swap"
    let kTokenRefreshServiceURL = "http://mysterious-waters-9692.herokuapp.com/refresh"
    
    @IBOutlet weak var loginButton: UIButton!
    
    
    var session:SPTSession!
    var user: SPTUser!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateAfterFirstLogin", name: "loginSuccessfull", object: nil)
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        
        if let sessionObj:AnyObject = userDefaults.objectForKey("SpotifySession") { // session available
            let sessionDataObj = sessionObj as NSData
            
            let session = NSKeyedUnarchiver.unarchiveObjectWithData(sessionDataObj) as SPTSession
            
            if !session.isValid() {
                SPTAuth.defaultInstance().renewSession(session, withServiceEndpointAtURL: NSURL(string: kTokenRefreshServiceURL), callback: { (error:NSError!, renewdSession:SPTSession!) -> Void in
                    if error == nil {
                        let sessionData = NSKeyedArchiver.archivedDataWithRootObject(session)
                        userDefaults.setObject(sessionData, forKey: "SpotifySession")
                        userDefaults.synchronize()
                        self.session = renewdSession
                    }else{
                        println("error refreshing session")
                    }
                })
            }else{
                println("session valid")
                self.session = session
            }
        }else{
        }
        
        
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
                    println(self.user.displayName)
                    println(self.user.followerCount)
                    //println(self.user.largestImage.imageURL)
                    
                    
                    let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
                    appDelegate.session = self.session
                    var prefs: [Int] = []
                    var a: [String] = []
                    var sc: [String: Int] = ["":0]
                    var alb: [String: [String]] = ["":[]]
                    var musicCollec = MusicCollection(artists: a, songCounts: sc, albums: alb);
                    appDelegate.user = User(displayName: self.user.displayName, email: self.user.emailAddress, musicCollection: musicCollec, preferences: prefs);
                    
                    if (self.user.largestImage.imageURL != nil){
                        appDelegate.user?.picURL = self.user.largestImage.imageURL
                    }
                })

            performSegueWithIdentifier("leaveLogIn", sender: nil)
            
            
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func loginWithSpotify(sender: AnyObject) {
        let auth = SPTAuth.defaultInstance()
        
        let loginURL = auth.loginURLForClientId(ClientID, declaredRedirectURL: NSURL(string: CallbackURL), scopes: [SPTAuthStreamingScope,SPTAuthUserReadEmailScope,SPTAuthUserLibraryReadScope,SPTAuthUserReadPrivateScope,SPTAuthPlaylistReadPrivateScope])
        
        UIApplication.sharedApplication().openURL(loginURL)
    }



}

