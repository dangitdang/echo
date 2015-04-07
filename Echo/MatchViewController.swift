//
//  MatchViewController.swift
//  Echo
//
//  Created by Harini Suresh on 4/4/15.
//  Copyright (c) 2015 Quartet. All rights reserved.
//

import UIKit

class MatchViewController: ViewControllerWNav {
    
    
    @IBOutlet weak var mainAlbum: UIImageView!
    @IBOutlet weak var albumOne: UIImageView!
    
    @IBOutlet weak var albumTwo: UIImageView!
    
    
    @IBOutlet weak var albumThree: UIImageView!
    
    @IBOutlet weak var passButton: UIButton!
    
    @IBOutlet weak var matchNameLabel: UILabel!
    
    var user: User!
    
    @IBOutlet weak var matchBlurbLabel: UILabel!
    
    @IBOutlet weak var matchPicture: UIImageView!
    
    @IBOutlet weak var musicButton: UIButton!
    
    @IBOutlet weak var matchValBar: UIProgressView!
    
    @IBOutlet weak var matchValLabel: UILabel!
    
    
    var currentMatch: User!
    var backgroundImages:[String]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        matchValBar.progressTintColor = UIColor(red: 0.9, green: 0.2, blue: 0.2, alpha: 1.0)
        matchValBar.trackTintColor = UIColor.darkGrayColor()
        
        
        
        backgroundImages = ["blur1", "blur2", "blur3", "blur4"]
        setUser()
        getCurrentMatch()
        var score = self.user.getScore(self.currentMatch)
        println("SCORE" + score)
        var scoreFlt = (score as NSString).floatValue
        println(self.user.matches)
        setAlbumArt()
        if self.currentMatch == nil {
            self.matchNameLabel.text = "No Match"
            self.matchBlurbLabel.text = "No Match"
            self.musicButton.setTitle("No Match", forState: UIControlState.Normal)
            self.matchValBar.progress = 0.0
            self.matchValLabel.text = "No Match"

        } else{
            self.matchValBar.progress = (scoreFlt/5.0)
            var myIntValue:Int = Int(scoreFlt)
            var stringForm = String(myIntValue)
            self.matchValLabel.text = "Match: " + stringForm + "/5"
            println(self.matchValLabel.text)
            self.matchNameLabel.text = self.currentMatch.displayName
            self.matchBlurbLabel.text = self.currentMatch.blurb
            self.musicButton.setTitle(self.currentMatch.displayName + "'s Music", forState: UIControlState.Normal)
            let url = self.currentMatch.picURL as NSURL!
            if (url.description != "") {
                let data = NSData(contentsOfURL: url!) //make sure your image in this url does exist, otherwise unwrap in a if letcheck
                matchPicture.image = UIImage(data: data!)
            } else {
                
                matchPicture.image = UIImage(named: "userIcon")
            }
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
    
    
    func getMatchFirstName() -> String {
        var fullName = self.currentMatch.displayName
        var fullNameArr = split(fullName) {$0 == " "}
        var firstName: String = fullNameArr[0]
        return firstName
    }
    
    @IBAction func passMatch(sender: AnyObject) {
        
        //getNextMatch
        
        if self.currentMatch == nil {
            self.matchNameLabel.text = "No Match"
            self.matchBlurbLabel.text = "No Match"
            self.musicButton.setTitle("No Match", forState: UIControlState.Normal)
            self.matchValBar.progress = 0.0
            self.matchValLabel.text = "No Match"
        } else {
            self.user.removeLastMatch(self.currentMatch.id)
            self.currentMatch = self.user.getLatestMatch()
            var score = self.user.getScore(self.currentMatch)
            println("SCORE" + score)
            var scoreFlt = (score as NSString).floatValue
            
            if self.currentMatch == nil {
                self.matchValBar.progress = 0.0
                self.matchValLabel.text = "No Match"
                self.matchNameLabel.text = "No Match"
                self.matchBlurbLabel.text = "No Match"
                self.musicButton.setTitle("No Match", forState: UIControlState.Normal)
                matchPicture.image = UIImage(named: "userIcon")
                
                
            } else {
            
            self.matchValBar.progress = (scoreFlt/5.0)
            var myIntValue:Int = Int(scoreFlt)
            var stringForm = String(myIntValue)
            self.matchValLabel.text = "Match: " + stringForm + "/5"
            println(self.matchValLabel.text)
            self.matchNameLabel.text = self.currentMatch.displayName
            self.matchBlurbLabel.text = self.currentMatch.blurb
            self.musicButton.setTitle(getMatchFirstName() + "'s Music", forState: UIControlState.Normal)
            let url = self.currentMatch.picURL as NSURL!
            if (url.description != "") {
                let data = NSData(contentsOfURL: url!) //make sure your image in this url does exist, otherwise unwrap in a if letcheck
                matchPicture.image = UIImage(data: data!)
            } else {
                
                matchPicture.image = UIImage(named: "userIcon")
                }
            setAlbumArt()

            }
            
        }

    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Segue is underway, update destination ViewController with value set earlier
        if let vc = segue.destinationViewController as? UINavigationController {
            if let v2 = vc.viewControllers[0] as? MatchesMusicTableViewController {
                v2.match = self.currentMatch;
            } else if let v2 = vc.viewControllers[0] as? ChooseSongViewController {
                self.user.removeLastMatch(self.currentMatch.id)
                v2.match = self.currentMatch
                println("here")
            }
        }
    }
    
    @IBAction func sendASong(sender: AnyObject) {
        //self.user.removeLastMatch(self.currentMatch.id)
        //self.currentMatch = self.user.getLatestMatch()
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
    
    
    func setAlbumArt() {
        if self.currentMatch == nil {
            albumOne.image = UIImage(named: "userIcon")
            albumTwo.image = UIImage(named: "userIcon")
            albumThree.image = UIImage(named: "userIcon")
            mainAlbum.backgroundColor = UIColor.darkGrayColor()
            
        } else {
            var threeAlbums = self.currentMatch.musicCollection?.getAlbumCovers()
            let url = NSURL(string: threeAlbums![0])
            let data = NSData(contentsOfURL: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check
            albumOne.image = UIImage(data: data!)
            
            let url2 = NSURL(string: threeAlbums![1])
            let data2 = NSData(contentsOfURL: url2!) //make sure your image in this url does exist, otherwise unwrap in a if let check
            albumTwo.image = UIImage(data: data2!)
            
            let url3 = NSURL(string: threeAlbums![2])
            let data3 = NSData(contentsOfURL: url3!) //make sure your image in this url does exist, otherwise unwrap in a if let check
            albumThree.image = UIImage(data: data3!)

            let randomIndex = Int(arc4random_uniform(UInt32(backgroundImages.count)))
            mainAlbum.image = UIImage(named: backgroundImages[randomIndex])
            
        }
        
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
