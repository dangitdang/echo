//
//  Utils.swift
//  Echo
//
//  Created by aivanov on 14.03.15.
//  Copyright (c) 2015 Quartet. All rights reserved.
//

import Foundation


let MUSICIANS = 0
let NEARBY = 1
let CONCERTS = 2

extension Array {
    mutating func removeObject<U: Equatable>(object: U) {
        var index: Int?
        for (idx, objectToCompare) in enumerate(self) {
            if let to = objectToCompare as? U {
                if object == to {
                    index = idx
                }
            }
        }
        
        if(index != nil) {
            self.removeAtIndex(index!)
        }
    }
}

class Date {
    
    class func from(#year:Int, month:Int, day:Int) -> NSDate? {
        var c = NSDateComponents()
        c.year = year
        c.month = month
        c.day = day
        
        var gregorian = NSCalendar(identifier:NSGregorianCalendar)
        var date = gregorian?.dateFromComponents(c)
        return date
    }
    
    class func parse(dateStr:String, format:String="yyyy-MM-dd") -> NSDate? {
        var dateFmt = NSDateFormatter()
        dateFmt.timeZone = NSTimeZone.defaultTimeZone()
        dateFmt.dateFormat = format
        return dateFmt.dateFromString(dateStr)
    }
}
