//
//  AppDelegate.swift
//  Echo
//
//  Created by Dang Pham on 3/1/15.
//  Copyright (c) 2015 Quartet. All rights reserved.
//

import UIKit



@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, PNDelegate {
    
    var pubNub: PubNub?
    var session:SPTSession?
    var user: User!
    var product: SPTProduct?
    var player: SPTAudioStreamingController?
    var scraper: Scrapper!
    var semaphore: dispatch_semaphore_t!
    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        Parse.setApplicationId("MUJzfsX8Y7z6xm4PsXrwyr3GTCRHPnJmVOF4lhDf", clientKey: "ywrNxXXEcg2gUnbSgZJwozopJfWRjyGp1fdUONfk")

        self.pubNub = PubNub.connectingClientWithConfiguration(PNConfiguration.defaultConfiguration(), delegate: self, andSuccessBlock: {(orign) -> Void in println("connected to Pubnub")}, errorBlock: {(error) -> Void in println("pubNub error")})

        PNLogger.loggerEnabled(false)
        self.semaphore = dispatch_semaphore_create(0)
        return true
    }

    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        self.user?.save()
        println("saving user")
    }
    func playSong(uri: String) {
        var url = "spotify:track:" + uri
        player?.playURIs([NSURL(string: url)!], withOptions: nil, callback: nil)
    }
    
    func pubnubClient(client: PubNub!, didReceiveMessage message: PNMessage!) {
//        println("GOOOOOOOOOOOOOOT A MESSAAAAAAAAGE####$$!!!!!!!!")
//        if (self.user != nil && message.channel.name == self.user.id) {
//            println(message.message)
//            var sender = message.message.valueForKey("sender") as String
//            var type = message.message.valueForKey("type") as String
//            var song = message.message.valueForKey("song") as String
//            var text = message.message.valueForKey("text") as String
//            var time = NSDate(timeIntervalSince1970: message.message.valueForKey("time") as Double)
//            if (type == "request") {
//                NEW_REQUEST(self.user!, sender, song, text, time)
//            } else if (type == "approve") {
//                APPROVED_REQUEST(self.user!, sender, song, text, time)
//            } else if (type == "message") {
//                
//                RECEIVED_MESSAGE(self.user!, sender, song, text, time)
//            }
//        }
    }

}

