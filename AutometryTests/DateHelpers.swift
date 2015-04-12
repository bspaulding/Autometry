//
//  DateHelpers.swift
//  Autometry
//
//  Created by Bradley Spaulding on 3/8/15.
//  Copyright (c) 2015 Motingo. All rights reserved.
//

import Foundation

class DateHelpers {
  class var calendar : NSCalendar? {
    return NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
  }
  
  class func dateWithYear(year:Int, month:Int, day:Int, hour:Int, minute:Int, tz:String) -> NSDate? {
    let components = NSDateComponents()
    components.year = year
    components.month = month
    components.day = day
    components.hour = hour
    components.minute = minute
    components.timeZone = NSTimeZone(abbreviation:tz)!
    return calendar!.dateFromComponents(components)
  }
}