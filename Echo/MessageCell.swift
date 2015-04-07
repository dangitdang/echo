//
//  MessageCell.swift
//  Echo
//
//  Created by Dang Pham on 4/6/15.
//  Copyright (c) 2015 Quartet. All rights reserved.
//
import UIKit
import Foundation

class MessageCell : UITableViewCell {
    
    @IBOutlet weak var userMessage: UILabel!
    
    @IBOutlet weak var otherMessage: UILabel!
    
    @IBOutlet weak var userPic: UIImageView!
    @IBOutlet weak var otherPic: UIView!
    var user : User!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}