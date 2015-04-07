//
//  ChooseSongViewController.swift
//  Echo
//
//  Created by Harini Suresh on 4/5/15.
//  Copyright (c) 2015 Quartet. All rights reserved.
//

import UIKit
import Foundation

class ChooseSongViewController: ViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var songTextField: UITextField!
    var songText: String!
    var searchResults: [[String]]!
    var currentSession:SPTSession?
    var myScraper:Scrapper!
    var match:User!
    
    @IBOutlet weak var songTableView: UITableView!
    
    override func viewDidLoad() {
        println("View Did Load")
        super.viewDidLoad()
        println("loadded")
        let backButton = UIBarButtonItem(title: "<", style: UIBarButtonItemStyle.Plain, target: self, action: "goBack")
        navigationItem.leftBarButtonItem = backButton
        getSession()
//        self.songTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "SongMusicTableViewCell")
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        self.myScraper = appDelegate.scraper
        
        //self.songText = self.songTextField.text
        // Do any additional setup after loading the view.
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        if self.searchResults == nil{
            return 0
        }
        return Int(self.searchResults.count)
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SongMusicTableViewCell", forIndexPath: indexPath) as SongTableViewCell
        cell.songLabel.text = self.searchResults[indexPath.row][0] as String
        
        return cell
    }
    
    @IBAction func songTextFieldChanged(sender: AnyObject) {
        self.myScraper.querySong(self.songTextField.text, completion: {(data:AnyObject!) -> Void in
            println(data)
            self.searchResults = data as [[String]]
            self.songTableView.reloadData()
        })
    
    
    }
    

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Segue is underway, update destination ViewController with value set earlier
        if let vc = segue.destinationViewController as? UINavigationController {
            if let v2 = vc.viewControllers[0] as? SendSongViewController {
                if let index = songTableView.indexPathForSelectedRow()?.row {
                    v2.songInfo = self.searchResults[index]
                    v2.match = self.match
                }

            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getSession() {
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let session = appDelegate.session as SPTSession!
        self.currentSession = session
    }
    
    func goBack() {
        self.dismissViewControllerAnimated(true, completion: nil)
        
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
