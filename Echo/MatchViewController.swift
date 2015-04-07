//
//  MatchViewController.swift
//  Echo
//
//  Created by Harini Suresh on 4/4/15.
//  Copyright (c) 2015 Quartet. All rights reserved.
//

import UIKit

class MatchViewController: ViewControllerWNav {
    
    
    
    @IBOutlet weak var passButton: UIButton!
    
    @IBOutlet weak var matchNameLabel: UILabel!
    
    var user: User!
    
    @IBOutlet weak var matchBlurbLabel: UILabel!
    
    @IBOutlet weak var matchPicture: UIImageView!
    
    @IBOutlet weak var musicButton: UIButton!
    
    var currentMatch: User!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUser()
        getCurrentMatch()
        println(self.user.matches)
        
        if self.currentMatch == nil {
            self.matchNameLabel.text = "No Match"
            self.matchBlurbLabel.text = "No Match"
            self.musicButton.setTitle("No Match", forState: UIControlState.Normal)
            
        } else{
            self.matchNameLabel.text = self.currentMatch.displayName
            self.matchBlurbLabel.text = self.currentMatch.blurb
            self.musicButton.setTitle(self.currentMatch.displayName + "'s Music", forState: UIControlState.Normal)
            let url = self.currentMatch.picURL as NSURL!
            if (url.description != "") {
                let data = NSData(contentsOfURL: url!) //make sure your image in this url does exist, otherwise unwrap in a if letcheck
                matchPicture.image = UIImage(data: data!)
        }
        
        
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main",bundle: nil)
        var destViewController : UIViewController
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        
        if (appDelegate.user.newUser) {
            appDelegate.user.newUser = false
            destViewController = mainStoryboard.instantiateViewControllerWithIdentifier("Profile") as UIViewController
            sideMenuController()?.setContentViewController(destViewController)
            sideMenuController()?.sideMenu?.hideSideMenu()
        }
        
        
        
        
        //self.matchNameLabel.text = "Match's Name"
        //self.musicButton.setTitle("Match's Music", forState: UIControlState.Normal)
        // Do any additional setup after loading the view.
        

        }
    }
    
    
    @IBAction func passMatch(sender: AnyObject) {
        
        //getNextMatch
        
        if self.currentMatch == nil {
            self.matchNameLabel.text = "No Match"
            self.matchBlurbLabel.text = "No Match"
            self.musicButton.setTitle("No Match", forState: UIControlState.Normal)
            
        } else {
            self.user.removeLastMatch(self.currentMatch.id)
            self.currentMatch = self.user.getLatestMatch()
            
            if self.currentMatch == nil {
                self.matchNameLabel.text = "No Match"
                self.matchBlurbLabel.text = "No Match"
                self.musicButton.setTitle("No Match", forState: UIControlState.Normal)
            } else {
            
            
            self.matchNameLabel.text = self.currentMatch.displayName
            self.matchBlurbLabel.text = self.currentMatch.blurb
            self.musicButton.setTitle(self.currentMatch.displayName + "'s Music", forState: UIControlState.Normal)
            let url = self.currentMatch.picURL as NSURL!
            if (url.description != "") {
                let data = NSData(contentsOfURL: url!) //make sure your image in this url does exist, otherwise unwrap in a if letcheck
                matchPicture.image = UIImage(data: data!)
                }
            }
            
        }

    }
    
    
    @IBAction func sendASong(sender: AnyObject) {
    }
    
    
    func getCurrentMatch() {
        self.currentMatch = self.user.getLatestMatch()
        
    }
    
    func setUser() {
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        self.user = appDelegate.user as User!
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func musicButtonPressed(sender: AnyObject) {
        //let vc = MatchesMusicTableViewController() //change this to your class name
        //self.presentViewController(vc, animated: true, completion: nil)
        
        
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
