//
//  EchoMatchesCell.swift
//  Echo
//
//  Created by Hansa Srinivasan on 4/6/15.
//  Copyright (c) 2015 Quartet. All rights reserved.
//

import UIKit
import Foundation

class EchoMatchesCell : UITableViewCell {
    
    @IBOutlet weak var matchName: UILabel!
    
    @IBOutlet weak var lastMessage: UILabel!
    
    @IBOutlet weak var matchIMG: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
