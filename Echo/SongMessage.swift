//
//  SongMessage.swift
//  Echo
//
//  Created by Dang Pham on 4/7/15.
//  Copyright (c) 2015 Quartet. All rights reserved.
//


class SongMessage: JSQMediaItem {
    var songURI : String!
    var songName : String!
    
    init(uri:String, name : String) {
        super.init()
        self.songURI = uri
        self.songName = name
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setAppliesMediaViewMaskAsOutgoing(appliesMediaViewMaskAsOutgoing : Bool) {
        super.appliesMediaViewMaskAsOutgoing = appliesMediaViewMaskAsOutgoing
    }
    
    override func mediaView() -> UIView! {
        var view = UIView()
        var size = self.mediaViewDisplaySize()
        let button = UIButton()
        button.setTitle("PlayButton", forState: UIControlState.Normal)
        button.addTarget(self, action: "PlaySong", forControlEvents: UIControlEvents.TouchUpInside)
        button.imageView?.image = UIImage(named: "Play")
        view.addSubview(button)
        let label = UILabel()
        label.text = self.songName
        view.addSubview(label)
        JSQMessagesMediaViewBubbleImageMasker.applyBubbleImageMaskToMediaView(view, isOutgoing: self.appliesMediaViewMaskAsOutgoing)
        return view
    }
    
    override func mediaHash() -> UInt {
        return UInt(bitPattern: self.hash)
    }
    
    func description() -> String {
        return "(SongMessage with song \(songName) and uri \(self.songURI))"
    }
    
    
    
    
}