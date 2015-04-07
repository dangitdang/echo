//
//  ProfileView.swift
//  Echo
//
//  Created by Hansa Srinivasan on 4/4/15.
//  Copyright (c) 2015 Quartet. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
}

class ProfileView: ViewControllerWNav, UITextFieldDelegate, UITextViewDelegate, UIScrollViewDelegate {
    
    @IBOutlet weak var profPic: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var locationField: UITextField!
    @IBOutlet weak var ageField: UITextField!
    @IBOutlet weak var checkbox1: UIButton!
    @IBOutlet weak var checkbox2: UIButton!
    @IBOutlet weak var checkbox3: UIButton!
    @IBOutlet weak var blurb: UITextView!
    @IBOutlet weak var scrollView: UIScrollView!

    var currentPreferences: [Int] = []
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        var point = CGPoint(x: 0.0, y: 0.0)
        scrollView.contentOffset = point

        checkbox1.setImage(UIImage(named: "CheckedCheckbox"), forState: UIControlState.Selected);
        checkbox2.setImage(UIImage(named: "CheckedCheckbox"), forState: UIControlState.Selected);
        checkbox3.setImage(UIImage(named: "CheckedCheckbox"), forState: UIControlState.Selected);
       
        blurb.layer.borderColor = UIColor(red: 0xC8, green: 0xC9, blue: 0xC8).CGColor
        blurb.layer.borderWidth = 0.8
        blurb.layer.cornerRadius = 7
        
        blurb.returnKeyType = UIReturnKeyType.Done
        
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let user = appDelegate.user as User!
        
        currentPreferences = appDelegate.user.preferences
        
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
            locationField.text = user.country
        }
        
        if (user.birthdate == "") {
            ageField.placeholder = "Age"
        } else {
            ageField.text = user.birthdate
        }
        
        name.text = user.displayName
        
        let url = user.picURL as NSURL!
        if (url.description != "") {
            let data = NSData(contentsOfURL: url!) //make sure your image in this url does exist, otherwise unwrap in a if letcheck
            profPic.image = UIImage(data: data!)
        }
        
    }
    
    @IBAction func saveAllpreferences(sender: AnyObject) {
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        if (blurb.text != "Type here!") {
            appDelegate.user.blurb = blurb.text
        }
        if (ageField.text != "Age") {
            appDelegate.user.birthdate = ageField.text
        }
        if (locationField.text != "Location") {
            appDelegate.user.country = locationField.text
        }
        
        appDelegate.user.preferences = currentPreferences
        println("BEFORE SEMAPHORE")
        dispatch_semaphore_wait(appDelegate.semaphore, DISPATCH_TIME_FOREVER)
        println("AFTER_SEMAPHORE")
        appDelegate.user.store()
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
        
        if (box.selected) {
            currentPreferences.append(boxId)
        } else {
            if let index = find(currentPreferences, boxId) {
                currentPreferences.removeAtIndex(index)
            }
        }
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }
        
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        //let user = appDelegate.user as User!
        
        if (textField == locationField) {
            locationField.text = textField.text
        }
        if (textField == ageField) {
            ageField.text = textField.text

        }
        return false
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        var point = checkbox1.frame.origin as CGPoint
        scrollView.contentOffset = point
        textView.textColor = UIColor.blackColor()
        if (textView.text == "Type here!"){
            textView.text = ""
        }
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        if (textView.text == ""){
            textView.text = "Type here!"
            blurb.textColor = UIColor.lightGrayColor()
        }
        var point = CGPoint(x: 0.0, y: 0.0)
        scrollView.contentOffset = point
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        self.view.endEditing(true)
        blurb.resignFirstResponder()
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n"){
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
}