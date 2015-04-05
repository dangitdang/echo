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
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let session = appDelegate.session
        
        SPTRequest.userInformationForUserInSession(session, callback:
            {(error: NSError!, userInfo: AnyObject!) -> Void in
//                self.user = userInfo as SPTUser
//                println(self.user.displayName)
//                println(self.user.followerCount)
//                //println(self.user.largestImage.imageURL)
        })
        
//        let url = NSURL(string: image.url)
//        let data = NSData(contentsOfURL: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check
//        profPic.image = UIImage(data: data!)
    }
    
}