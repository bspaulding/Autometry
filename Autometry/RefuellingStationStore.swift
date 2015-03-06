//
//  StationStore.swift
//  Autometry
//
//  Created by Bradley Spaulding on 3/4/15.
//  Copyright (c) 2015 Motingo. All rights reserved.
//

import Foundation
import Alamofire

class RefuellingStationStore {
  let api_key = "AIzaSyCwOkPKuzciYQeHo3ICajljmmf6uFMBcOk"
  private var currentRefuellingStation : RefuellingStation?
  var listeners : [() -> ()] = []
  
  private init() {}
  
  func register(callback:()->()) {
    listeners.append(callback)
  }
  
  func getCurrentRefuellingStation() -> RefuellingStation? {
    return self.currentRefuellingStation
  }
  func setCurrentRefuellingStation(station:RefuellingStation) {
    self.currentRefuellingStation = station
    for listener in listeners {
      listener()
    }
  }
  
  func nearby(latitude:Double, longitude:Double, callback:([RefuellingStation]) -> ()) {
    println("latitude: \(latitude), longitude: \(longitude)")
    let url = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?key=\(api_key)&types=gas_station&rankby=distance&location=\(latitude),\(longitude)"
    Alamofire.request(.GET, url).responseJSON {(request, response, data, error) in
      if data != nil {
        let results = data!.valueForKey("results") as [NSDictionary]
        callback(results.map({ (var result) -> RefuellingStation in
          let geometry = result.valueForKey("geometry") as NSDictionary
          let location = geometry.valueForKey("location") as NSDictionary
          
          return RefuellingStation(
            name: result.valueForKey("name") as String,
            googlePlaceID: result.valueForKey("place_id") as String,
            latitude: location.valueForKey("lat") as Double,
            longitude: location.valueForKey("lng") as Double
          )
        }))
      } else {
        callback([])
      }
    }
  }
  
  // Singleton Pattern
  
  class var sharedInstance: RefuellingStationStore {
    struct Static {
      static var instance: RefuellingStationStore?
      static var token: dispatch_once_t = 0
    }
    
    dispatch_once(&Static.token) {
      Static.instance = RefuellingStationStore()
    }
    
    return Static.instance!
  }
}
