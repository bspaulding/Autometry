import Foundation

class Refuel {
  var id : AnyObject?
  var odometer : Int?
  var pricePerGallon : Float?
  var gallons : Float?
  var station : RefuellingStation?
  var octane : Int?
  var createdDate : Date?
  var partial : Bool?
  
  init() {}
  init(id: AnyObject, odometer: Int, pricePerGallon: Float, gallons: Float, octane: Int?, createdDate: Date?, partial: Bool?) {
    self.id = id
    self.odometer = odometer
    self.pricePerGallon = pricePerGallon
    self.gallons = gallons
    self.octane = octane
    self.createdDate = createdDate
    self.partial = partial
  }
  
  func getGallons() -> Float {
    if let gallons = self.gallons {
      return gallons
    }
    
    return 0
  }
  
  func totalSpent() -> Float {
    if let price = pricePerGallon, let gallons = gallons {
      return price * gallons
    }
    
    return 0
  }
  
  func isPartial() -> Bool {
    if let partial = self.partial {
      return partial
    } else {
      return false
    }
  }
}
