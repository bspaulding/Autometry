//
//  RefuelStation.swift
//  Autometry
//
//  Created by Bradley Spaulding on 3/4/15.
//  Copyright (c) 2015 Motingo. All rights reserved.
//

import Foundation

struct RefuellingStation {
  var name : String = ""
  var googlePlaceID : String = ""
  
  init(name: String, googlePlaceID: String) {
    self.name = name
    self.googlePlaceID = googlePlaceID
  }
}