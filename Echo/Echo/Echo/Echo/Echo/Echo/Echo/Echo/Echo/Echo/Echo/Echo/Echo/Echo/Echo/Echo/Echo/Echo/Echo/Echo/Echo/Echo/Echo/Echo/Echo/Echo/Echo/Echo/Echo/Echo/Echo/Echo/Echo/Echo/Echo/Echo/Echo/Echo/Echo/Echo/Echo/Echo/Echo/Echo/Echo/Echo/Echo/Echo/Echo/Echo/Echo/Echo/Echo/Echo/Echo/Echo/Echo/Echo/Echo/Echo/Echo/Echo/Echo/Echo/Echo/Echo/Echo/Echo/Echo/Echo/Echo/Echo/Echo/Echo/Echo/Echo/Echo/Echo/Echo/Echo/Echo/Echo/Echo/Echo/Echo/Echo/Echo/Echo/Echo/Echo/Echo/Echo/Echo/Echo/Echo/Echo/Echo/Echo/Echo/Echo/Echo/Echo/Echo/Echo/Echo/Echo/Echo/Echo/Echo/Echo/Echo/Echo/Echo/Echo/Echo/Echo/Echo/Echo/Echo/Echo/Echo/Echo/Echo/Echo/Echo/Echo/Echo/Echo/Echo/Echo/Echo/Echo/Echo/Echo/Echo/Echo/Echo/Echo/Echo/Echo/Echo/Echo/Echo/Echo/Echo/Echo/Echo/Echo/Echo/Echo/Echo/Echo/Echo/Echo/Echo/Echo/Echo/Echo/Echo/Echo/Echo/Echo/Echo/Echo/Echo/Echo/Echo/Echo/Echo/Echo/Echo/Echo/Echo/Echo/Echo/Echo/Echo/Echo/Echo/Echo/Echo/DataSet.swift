//
//  DataSet.swift
//  Echo
//
//  Created by Hansa Srinivasan on 4/4/15.
//  Copyright (c) 2015 Quartet. All rights reserved.
//

var instance: DataSet?
class DataSet {
    
    var session:SPTSession!
    var user: SPTUser!
    
    class var sharedInstance: DataSet {
        struct Static {
            static var instance: DataSet?
            static var token: dispatch_once_t = 0
        }
        
        dispatch_once(&Static.token) {
            Static.instance = DataSet()
        }
        
        return Static.instance
    }
}