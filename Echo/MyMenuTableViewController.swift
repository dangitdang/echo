//
//  MyMenuTableViewController.swift
//  SwiftSideMenu
//
//  Created by Evgeny Nazarov on 29.09.14.
//  Copyright (c) 2014 Evgeny Nazarov. All rights reserved.
//

import UIKit

class MyMenuTableViewController: UITableViewController {
    var selectedMenuItem : Int = 0
    ///var refreshControl:UIRefreshControl!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.refreshControl = UIRefreshControl()
        //self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        //self.refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        //self.tableView.addSubview(refreshControl)
        
        // Customize apperance of table view
        tableView.contentInset = UIEdgeInsetsMake(64.0, 0, 0, 0) //
        tableView.separatorStyle = .None
        tableView.backgroundColor = UIColor.clearColor()
        tableView.scrollsToTop = false
        
        // Preserve selection between presentations
        self.clearsSelectionOnViewWillAppear = false
        
        tableView.selectRowAtIndexPath(NSIndexPath(forRow: selectedMenuItem, inSection: 0), animated: false, scrollPosition: .Middle)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return 4
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("CELL") as? UITableViewCell
        
        if (cell == nil) {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "CELL")
            cell!.backgroundColor = UIColor.clearColor()
            cell!.textLabel?.textColor = UIColor.darkGrayColor()
            let selectedBackgroundView = UIView(frame: CGRectMake(0, 0, cell!.frame.size.width, cell!.frame.size.height))
            selectedBackgroundView.backgroundColor = UIColor.grayColor().colorWithAlphaComponent(0.2)
            cell!.selectedBackgroundView = selectedBackgroundView
        }
        
        switch (indexPath.row) {
            
        case 0:
            cell!.textLabel?.text = "Matches"
            break
        case 1:
            cell!.textLabel?.text = "Messages"
            break
        case 2:
            //cell!.imageView?.image = UIImage(named: "notification")
            //let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
            //println(appDelegate.notification)
            //if (appDelegate.notification.boolValue == true) {
            //    cell!.imageView?.image = UIImage(named: "notification")
            //}
            cell!.textLabel?.text = "Requests"
            break
        case 3:
            cell!.textLabel?.text = "Profile"
            break
        default:
            cell!.textLabel?.text = "Matches"
            break
        }
        //cell!.textLabel?.text = "ViewController #\(indexPath.row+1)"
        
        return cell!
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50.0
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        println("did select row: \(indexPath.row)")
        
        println(indexPath.row)
        println(selectedMenuItem)
        if (indexPath.row == selectedMenuItem) {
            println("in NOT GONNA DO SHIT")
            sideMenuController()?.sideMenu?.hideSideMenu()
            return
        }
        selectedMenuItem = indexPath.row
        
        //Present new view controller
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main",bundle: nil)
        var destViewController : UIViewController
        switch (indexPath.row) {
        case 0:
            destViewController = mainStoryboard.instantiateViewControllerWithIdentifier("Matches")as UIViewController
            sideMenuController()?.setContentViewController(destViewController)
            break
        case 1:
            destViewController = mainStoryboard.instantiateViewControllerWithIdentifier("Messages")as UIViewController
            sideMenuController()?.setContentViewController(destViewController)
            break
        case 2:
            let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
            appDelegate.notification = false
            destViewController = mainStoryboard.instantiateViewControllerWithIdentifier("Requests")as UIViewController
            sideMenuController()?.setContentViewController(destViewController)
            break
        case 3:
            destViewController = mainStoryboard.instantiateViewControllerWithIdentifier("Profile")as UIViewController
            sideMenuController()?.setContentViewController(destViewController)
            break
        default:
            destViewController = mainStoryboard.instantiateViewControllerWithIdentifier("Matches") as UIViewController
            sideMenuController()?.setContentViewController(destViewController)
            break
        }
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
