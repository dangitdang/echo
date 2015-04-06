//
//  ChooseSongViewController.swift
//  Echo
//
//  Created by Harini Suresh on 4/5/15.
//  Copyright (c) 2015 Quartet. All rights reserved.
//

import UIKit
import Foundation

class ChooseSongViewController: ViewController {

    @IBOutlet weak var songTextField: UITextField!
    var songText: String!
    var searchResults: SPTListPage!
    var currentSession:SPTSession?
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        let backButton = UIBarButtonItem(title: "<", style: UIBarButtonItemStyle.Plain, target: self, action: "goBack")
        navigationItem.leftBarButtonItem = backButton
        getSession()
        self.songText = self.songTextField.text
        // Do any additional setup after loading the view.
    }

    
    @IBAction func songInputChanged(sender: UITextField) {
        SPTRequest.performSearchWithQuery(self.songText, queryType:SPTSearchQueryType.QueryTypeTrack,  offset:1, session:currentSession, market:nil, callback:{(error:NSError!, resultList:AnyObject!) -> Void in if error != nil {
            println("error sadface")
        } else {
            self.searchResults = resultList as SPTListPage
            }
        })
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
