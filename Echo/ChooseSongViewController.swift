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

    @IBOutlet weak var songText: UITextField!
    var searchResults: [String] = []
    
//    @IBAction func songInputChanged(sender: UITextField) {
//        STPRequest.performSearchWithQuery(self.songText, queryType:SPTQueryTypeTrack,  offset:1, session:nil, market:nil, callback:{(resultList:SPTListPage) -> Void in self.searchResults = resultList
//        })
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let backButton = UIBarButtonItem(title: "<", style: UIBarButtonItemStyle.Plain, target: self, action: "goBack")
        navigationItem.leftBarButtonItem = backButton

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
