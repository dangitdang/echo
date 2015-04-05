//
//  ProfileView.swift
//  Echo
//
//  Created by Hansa Srinivasan on 4/4/15.
//  Copyright (c) 2015 Quartet. All rights reserved.
//

import UIKit

class ProfileView: ViewControllerWNav{
    
    @IBOutlet weak var profPic: UIImageView!
    
    @IBOutlet weak var name: UILabel!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let user = appDelegate.user as User!
        
        name.text = user.displayName
        
        let url = user.picURL as NSURL!
        if (url != nil) {
            let data = NSData(contentsOfURL: url!) //make sure your image in this url does exist, otherwise unwrap in a if letcheck
            profPic.image = UIImage(data: data!)
        }
        
    }
    
}