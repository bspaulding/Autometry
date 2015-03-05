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
  
  func nearby(latitude:Double, longitude:Double, callback:([RefuellingStation]) -> ()) {
    println("latitude: \(latitude), longitude: \(longitude)")
    let url = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?key=\(api_key)&types=gas_station&rankby=distance&location=\(latitude),\(longitude)"
    Alamofire.request(.GET, url).responseJSON {(request, response, data, error) in
      if data != nil {
        let results = data!.valueForKey("results") as [NSDictionary]
        callback(results.map({ (var result) -> RefuellingStation in
          return RefuellingStation(
            name: result.valueForKey("name") as String,
            googlePlaceID: result.valueForKey("place_id") as String
          )
        }))
      } else {
        callback([])
      }
    }
  }
}
