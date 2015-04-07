//
//  MessengerController.swift
//  Echo
//
//  Created by aivanov on 05.04.15.
//  Copyright (c) 2015 Quartet. All rights reserved.
//

import UIKit

class MessengerController: ViewControllerWNav {
    
    @IBOutlet weak var Button1: UIButton!
    
    var player: SPTAudioStreamingController!
    override func viewDidLoad() {
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        self.player = appDelegate.player
    }
    
    @IBAction func playSong(sender: AnyObject) {
        playSong("spotify:track:5EsUREDLx9m60wzBhyo3Nj")
    }
    func playSong(uri:String) {
        player.playURIs([NSURL(string: uri)!], withOptions: nil, callback: nil)
    }
    

    
}



