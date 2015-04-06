//
//  MatchesMusicTableViewController.swift
//  Echo
//
//  Created by Harini Suresh on 4/4/15.
//  Copyright (c) 2015 Quartet. All rights reserved.
//

import UIKit

class MatchesMusicTableViewController: UITableViewController {

    
    
    @IBOutlet var songTableView: UITableView!
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    var matchesMusicData: [String] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backButton = UIBarButtonItem(title: "< Back", style: UIBarButtonItemStyle.Plain, target: self, action: "goBack")
        navigationItem.leftBarButtonItem = backButton
        
        loadInCommonMusic()
        
        //self.tablewView.registerClass:MatchesMusicTableViewCell forCellReuse
//        self.tableView.registerClass(MatchesMusicTableViewCell.classForCoder(), forCellReuseIdentifier: "MatchesMusicTableViewCell")

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    
    
//    @IBAction func closeTab(sender: UIBarButtonItem) {
//        self.dismissViewControllerAnimated(true, completion: nil)
//        
//    }
    
    @IBAction func indexChanged(sender: UISegmentedControl) {
        switch segmentedControl.selectedSegmentIndex
        {
        case 0:
            loadInCommonMusic()
            self.songTableView.reloadData()
        case 1:
            loadUniqueMusic()
            self.songTableView.reloadData()

            //matchesMusicData = ["Britney Spears", "Your Mom", "The Beatles", "Beyonce"]
        default:
            break;
        }
    }
    
    func goBack() {
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func loadInCommonMusic() {
        // makes some request, gets a response
        
        matchesMusicData = ["Pink Floyd", "Taylor Swift", "Forence and the Machine", "Maroon 5"]
    }

    func loadUniqueMusic() {
        // makes some request, gets a response
        
        matchesMusicData = ["Britney Spears", "Your Mom", "The Beatles", "Beyonce"]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return matchesMusicData.count
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var row = indexPath.row
        var musicString = matchesMusicData[row]
        let cell = tableView.dequeueReusableCellWithIdentifier("MatchesMusicTableViewCell", forIndexPath: indexPath) as MatchesMusicTableViewCell
        
        cell.artistNameLabel.text = musicString
        
        
        return cell
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
