//
//  RefuelCSVWrapper.swift
//  Autometry
//
//  Created by Bradley Spaulding on 3/7/15.
//  Copyright (c) 2015 Motingo. All rights reserved.
//

import Foundation

class RefuelCSVWrapper {
  class var header : String {
    return ",".join(["Date", "Odometer", "Price Per Gallon", "Gallons", "Octane", "Latitude", "Longtidue"])
  }
  
  class func wrap(refuel:Refuel) -> String {
    var values : [String] = []
    
    if let createdDate = refuel.createdDate {
      values.append("TODO DateFormatting")
    } else { values.append("") }
    
    if let odometer = refuel.odometer {
      values.append(String(odometer))
    } else { values.append("") }
    
    if let pricePerGallon = refuel.pricePerGallon {
      values.append("TODO NumberFormatting")
    } else { values.append("") }
    
    if let gallons = refuel.gallons {
      values.append("TODO NumberFormatting")
    } else { values.append("") }
    
    if let octane = refuel.octane {
      values.append(String(octane))
    } else { values.append("") }
    
    if let station = refuel.station {
      values.append(NSString(format: "%.5f", station.latitude))
      values.append(NSString(format: "%.5f", station.longitude))
    } else {
      values.append("")
      values.append("")
    }
    
    return ",".join(values)
  }
}
