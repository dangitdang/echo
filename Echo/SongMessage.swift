//
//  SongMessage.swift
//  Echo
//
//  Created by Dang Pham on 4/7/15.
//  Copyright (c) 2015 Quartet. All rights reserved.
//


class SongMessage : JSQMediaItem, JSQMessageMediaData {
    var songURI : String!
    var songName : String!
    
    init(uri:String, name : String) {
        self.songURI = uri
        self.songName = name
        super.init()
        
    }
    
    override init(maskAsOutgoing: Bool) {
        super.init(maskAsOutgoing: maskAsOutgoing)
        setAppliesMediaViewMaskAsOutgoing(maskAsOutgoing)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    
    func setAppliesMediaViewMaskAsOutgoing(appliesMediaViewMaskAsOutgoing : Bool) {
        super.appliesMediaViewMaskAsOutgoing = appliesMediaViewMaskAsOutgoing
    }
    
    override func mediaView() -> UIView! {
        var view = UIView()
        var size = CGSize(width: 100, height: 50)
        view.frame = CGRect(x: 0, y: 0, width: 100, height: 50)
        let button = UIButton()
        button.setTitle("PlayButton", forState: UIControlState.Normal)
        button.addTarget(self, action: "PlaySong", forControlEvents: UIControlEvents.TouchUpInside)
        button.imageView?.image = UIImage(named: "Play")
        button.frame = CGRectMake(10, 10, 40, 40)
        view.addSubview(button)
        //let label = UILabel()
        //label.text = self.songName
        //view.addSubview(label)
        JSQMessagesMediaViewBubbleImageMasker.applyBubbleImageMaskToMediaView(view, isOutgoing: self.appliesMediaViewMaskAsOutgoing)
        println(button)
        //println(label)
        println(view)
        return view
    }
    
    override func mediaHash() -> UInt {
        return UInt(bitPattern: self.hash)
    }
    
    func description() -> String {
        return "(SongMessage with song \(songName) and uri \(self.songURI))"
    }
    
    
    
    
}