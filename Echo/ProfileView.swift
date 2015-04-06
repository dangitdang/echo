//
//  ProfileView.swift
//  Echo
//
//  Created by Hansa Srinivasan on 4/4/15.
//  Copyright (c) 2015 Quartet. All rights reserved.
//

import UIKit

class ProfileView: ViewControllerWNav, UITextFieldDelegate {
    
    @IBOutlet weak var profPic: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var locationField: UITextField!
    @IBOutlet weak var ageField: UITextField!
    @IBOutlet weak var checkbox1: UIButton!
    @IBOutlet weak var checkbox2: UIButton!
    @IBOutlet weak var checkbox3: UIButton!
    
    @IBAction func checkbox1(sender: AnyObject) {
        checkbox1.selected = !checkbox1.selected
    }
    
    @IBAction func checkbox2(sender: AnyObject) {
        checkbox2.selected = !checkbox2.selected
    }
    
    @IBAction func checkbox3(sender: AnyObject) {
        checkbox3.selected = !checkbox3.selected
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        checkbox1.setImage(UIImage(named: "CheckedCheckbox"), forState: UIControlState.Selected);
        checkbox2.setImage(UIImage(named: "CheckedCheckbox"), forState: UIControlState.Selected);
        checkbox3.setImage(UIImage(named: "CheckedCheckbox"), forState: UIControlState.Selected);

        
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let user = appDelegate.user as User!
        
        if (user.country == nil) {
            locationField.placeholder = "Location"
        } else {
            locationField.placeholder = user.country
        }
        
        if (user.birthdate == nil) {
            ageField.placeholder = "Age"
        } else {
            ageField.placeholder = user.birthdate
        }
        
        name.text = user.displayName
        
        let url = user.picURL as NSURL!
        if (url != nil) {
            let data = NSData(contentsOfURL: url!) //make sure your image in this url does exist, otherwise unwrap in a if letcheck
            profPic.image = UIImage(data: data!)
        }
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        //let user = appDelegate.user as User!
        
        if (textField == locationField) {
            println("LOCATIONFIELD")
            println(textField.text)
            locationField.placeholder = textField.text
            appDelegate.user?.country = textField.text
            println(appDelegate.user?.country)
        }
        if (textField == ageField) {
            println("AGEFIELD")
            println(textField.text)
            ageField.placeholder = textField.text
            appDelegate.user?.birthdate = textField.text
            println(appDelegate.user?.birthdate)
        }
        return false
    }
    
}