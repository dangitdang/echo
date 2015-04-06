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
    
    @IBOutlet weak var musicButton: UIButton!
    
    var user: User!
    
    var currentMatch: User!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //setUser()
        //getCurrentMatch()
        //self.matchNameLabel.text = self.currentMatch.displayName
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main",bundle: nil)
        var destViewController : UIViewController
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate

        if (appDelegate.user.newUser) {
            appDelegate.user.newUser = false
            destViewController = mainStoryboard.instantiateViewControllerWithIdentifier("Profile") as UIViewController
            sideMenuController()?.setContentViewController(destViewController)
        }
        
        //self.musicButton.setTitle(self.currentMatch.displayName + "'s Music", forState: UIControlState.Normal)
        
        self.matchNameLabel.text = "Match's Name"
        self.musicButton.setTitle("Match's Music", forState: UIControlState.Normal)
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func passMatch(sender: AnyObject) {
        
        //getNextMatch
        
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
