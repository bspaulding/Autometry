//
//  RefuelCSVWrapper.swift
//  Autometry
//
//  Created by Bradley Spaulding on 3/7/15.
//  Copyright (c) 2015 Motingo. All rights reserved.
//

import Foundation

class RefuelCSVWrapper {
  class var dateFormatter : DateFormatter {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mmZ"
    return formatter
  }
  class var currencyFormatter : NumberFormatter {
    let formatter = NumberFormatter()
    formatter.numberStyle = .currency
    return formatter
  }
  
  class var header : String {
    return ["Date", "Odometer", "Price Per Gallon", "Gallons", "Octane", "Partial", "Location Name", "Latitude", "Longtidue", "Google Place ID"].joined(separator: ",")
  }
  
  class func wrapAll(_ refuels:[Refuel]) -> String {
    return ([header] + refuels.map(wrap)).joined(separator: "\n")
  }
  
  class func wrap(_ refuel:Refuel) -> String {
    var values : [String] = []
    
    if let createdDate = refuel.createdDate {
      values.append(dateFormatter.string(from: createdDate as Date))
    } else { values.append("") }
    
    if let odometer = refuel.odometer {
      values.append(String(odometer))
    } else { values.append("") }
    
    if let pricePerGallon = refuel.pricePerGallon {
      values.append("\(currencyFormatter.currencySymbol!)\(pricePerGallon)")
    } else { values.append("") }
    
    if let gallons = refuel.gallons {
      values.append("\(gallons)")
    } else { values.append("") }
    
    if let octane = refuel.octane {
      values.append(String(octane))
    } else { values.append("") }
    
    if let partial = refuel.partial {
      values.append("\(partial)")
    } else { values.append("false") }
    
    if let station = refuel.station {
      values.append(station.name)
      values.append("\(station.latitude)")
      values.append("\(station.longitude)")
      values.append(station.googlePlaceID)
    } else {
      values.append("")
      values.append("")
      values.append("")
      values.append("")
    }
    
    return values.joined(separator: ",")
  }
}
