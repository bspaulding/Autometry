//
//  RefuelStation.swift
//  Autometry
//
//  Created by Bradley Spaulding on 3/4/15.
//  Copyright (c) 2015 Motingo. All rights reserved.
//

import Foundation

struct RefuellingStation {
  let name : String = ""
  let googlePlaceID : String = ""
  let latitude : Double
  let longitude : Double
  
  init(name: String, googlePlaceID: String, latitude:Double, longitude:Double) {
    self.name = name
    self.googlePlaceID = googlePlaceID
    self.latitude = latitude
    self.longitude = longitude
  }
}