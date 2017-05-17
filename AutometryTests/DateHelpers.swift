//
//  DateHelpers.swift
//  Autometry
//
//  Created by Bradley Spaulding on 3/8/15.
//  Copyright (c) 2015 Motingo. All rights reserved.
//

import Foundation

class DateHelpers {
  class var calendar : Calendar? {
    return Calendar(identifier: Calendar.Identifier.gregorian)
  }
  
  class func dateWithYear(_ year:Int, month:Int, day:Int, hour:Int, minute:Int, tz:String) -> Date? {
    var components = DateComponents()
    components.year = year
    components.month = month
    components.day = day
    components.hour = hour
    components.minute = minute
    (components as NSDateComponents).timeZone = TimeZone(abbreviation:tz)!
    return calendar!.date(from: components)
  }
}
