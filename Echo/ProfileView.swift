//
//  ProfileView.swift
//  Echo
//
//  Created by Hansa Srinivasan on 4/4/15.
//  Copyright (c) 2015 Quartet. All rights reserved.
//

import UIKit

class ProfileView: ViewControllerWNav, UITextFieldDelegate, UITextViewDelegate {
    
    @IBOutlet weak var profPic: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var locationField: UITextField!
    @IBOutlet weak var ageField: UITextField!
    @IBOutlet weak var checkbox1: UIButton!
    @IBOutlet weak var checkbox2: UIButton!
    @IBOutlet weak var checkbox3: UIButton!
    @IBOutlet weak var blurb: UITextView!
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        checkbox1.setImage(UIImage(named: "CheckedCheckbox"), forState: UIControlState.Selected);
        checkbox2.setImage(UIImage(named: "CheckedCheckbox"), forState: UIControlState.Selected);
        checkbox3.setImage(UIImage(named: "CheckedCheckbox"), forState: UIControlState.Selected);
       
        blurb.layer.borderColor = UIColor.blackColor().CGColor;
        blurb.layer.borderWidth = 0.8
        
        //locationField.returnKeyType = UIReturnKeyDone
        //ageField.returnKeyType = UIReturnKeyDone
        //blurb.returnKeyType = UIReturnKeyDone

        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let user = appDelegate.user as User!
        
        for preference in appDelegate.user!.preferences {
            switch (preference){
            case 0:
                checkbox3.selected = true
                break
            case 1:
                checkbox1.selected = true
                break
            case 2:
                checkbox2.selected = true
                break
            default:
                break
            }
            
        }
        
        if (user.blurb == "") {
            blurb.text = "Type here!"
            blurb.textColor = UIColor.lightGrayColor()
        } else {
            blurb.text = user.blurb
        }
        
        if (user.country == "") {
            locationField.placeholder = "Location"
        } else {
            locationField.placeholder = user.country
        }
        
        if (user.birthdate == "") {
            ageField.placeholder = "Age"
        } else {
            ageField.placeholder = user.birthdate
        }
        
        name.text = user.displayName
        
        let url = user.picURL as NSURL!
        if (url.description != "") {
            let data = NSData(contentsOfURL: url!) //make sure your image in this url does exist, otherwise unwrap in a if letcheck
            profPic.image = UIImage(data: data!)
        }
        
    }
    
    @IBAction func checkbox1(sender: AnyObject) {
        doCheckboxPress(NEARBY, box: checkbox1)
    }
    
    @IBAction func checkbox2(sender: AnyObject) {
        doCheckboxPress(CONCERTS, box: checkbox2)
    }
    
    @IBAction func checkbox3(sender: AnyObject) {
        doCheckboxPress(MUSICIANS, box: checkbox3)
    }
    
    func doCheckboxPress(boxId: Int, box: UIButton) {
        box.selected = !box.selected
        
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        if (box.selected) {
            appDelegate.user?.preferences.append(boxId)
        } else {
            if let index = find(appDelegate.user!.preferences, boxId) {
                appDelegate.user?.preferences.removeAtIndex(index)
            }
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
    
    func textViewDidBeginEditing(textView: UITextView) {
        textView.textColor = UIColor.blackColor()
        if (textView.text == "Type here!"){
            textView.text = ""
        }
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        textView.resignFirstResponder()
    }
}