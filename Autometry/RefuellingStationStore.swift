//
//  StationStore.swift
//  Autometry
//
//  Created by Bradley Spaulding on 3/4/15.
//  Copyright (c) 2015 Motingo. All rights reserved.
//

import Foundation

class RefuellingStationStore {
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
    GoogleMapsAPI.gasStationsNearby(latitude, longitude:longitude, callback:{(data) in
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
    })
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
