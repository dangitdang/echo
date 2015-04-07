//
//  SendSongViewController.swift
//  Echo
//
//  Created by Harini Suresh on 4/7/15.
//  Copyright (c) 2015 Quartet. All rights reserved.
//

import UIKit

class SendSongViewController: ViewController {

    @IBOutlet weak var songNameLabel: UILabel!
    var songInfo: [String]!
    var match: User!
    
    @IBOutlet weak var sendSongLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.songNameLabel.text = songInfo[0]
        self.sendSongLabel.text = "Send Song to " + match.displayName + "?"
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func sendSongButtonPressed(sender: AnyObject) {
        let messenger = Messenger()
        messenger.sendRequest(self.match, song: self.songInfo[2], songName: self.songInfo[0], time:NSDate())
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
