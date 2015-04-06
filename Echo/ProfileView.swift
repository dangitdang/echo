//
//  ProfileView.swift
//  Echo
//
//  Created by Hansa Srinivasan on 4/4/15.
//  Copyright (c) 2015 Quartet. All rights reserved.
//

import UIKit

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

    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        checkbox1.setImage(UIImage(named: "CheckedCheckbox"), forState: UIControlState.Selected);
        checkbox2.setImage(UIImage(named: "CheckedCheckbox"), forState: UIControlState.Selected);
        checkbox3.setImage(UIImage(named: "CheckedCheckbox"), forState: UIControlState.Selected);
       
        blurb.layer.borderColor = UIColor.lightGrayColor().CGColor;
        blurb.layer.borderWidth = 0.8
        blurb.layer.cornerRadius = 1
        
        blurb.returnKeyType = UIReturnKeyType.Done
        
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
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        self.view.endEditing(true)
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
        }
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        self.view.endEditing(true)
        blurb.resignFirstResponder()
    }
    
//    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
//        if (textField.text == "\n"){
//            textField.resignFirstResponder()
//        }
//        return false
//    }
    
}