//
//  MessengerController.swift
//  Echo
//
//  Created by aivanov on 05.04.15.
//  Copyright (c) 2015 Quartet. All rights reserved.
//

//import UIKit
//
//class MessengerController: ViewControllerWNav, UITableViewDataSource {
//    
//    @IBOutlet weak var Button1: UIButton!
//    
//    @IBOutlet weak var Matches: UITableView!
//    
//    var player: SPTAudioStreamingController!
//    var user: User!
//    var matchesArr: [User]!
//    
//    override func viewDidLoad() {
//        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
//        self.player = appDelegate.player
//        self.user = appDelegate.user
//        self.matchesArr = self.user.messenger.getPeopleTalkingTo()
//        Matches.dataSource = self
//    }
//    @IBAction func playSong(sender: AnyObject) {
//        playSong("spotify:track:5EsUREDLx9m60wzBhyo3Nj")
//    }
//    func playSong(uri:String) {
//        player.playURIs([NSURL(string: uri)!], withOptions: nil, callback: nil)
//    }
//    
//    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        return 1
//    }
//    
//
//    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return self.matchesArr.count
//    }
//    
////    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
////        var row = indexPath.row
////        var match = self.matchesArr[row]
////        let cell = nil //tableView.dequeueReusableCellWithIdentifier("EchoMatches", forIndexPath: indexPath) as MatchesMusicTableViewCell
////        return cell
////    }
//
//}
