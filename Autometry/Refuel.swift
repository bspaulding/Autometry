//
//  Refuel.swift
//  Autometry
//
//  Created by Bradley Spaulding on 3/2/15.
//  Copyright (c) 2015 Motingo. All rights reserved.
//

import Foundation

class Refuel {
  var id : AnyObject?
  var odometer : Int?
  var pricePerGallon : Float?
  var gallons : Float?
  var station : RefuellingStation?
  var octane : Int?
  
  init() {}
  init(id: AnyObject, odometer: Int, pricePerGallon: Float, gallons: Float, octane: Int) {
    self.id = id
    self.odometer = odometer
    self.pricePerGallon = pricePerGallon
    self.gallons = gallons
    self.octane = octane
  }
}