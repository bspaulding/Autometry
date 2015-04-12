import Foundation

class Refuel {
  var id : AnyObject?
  var odometer : Int?
  var pricePerGallon : Float?
  var gallons : Float?
  var station : RefuellingStation?
  var octane : Int?
  var createdDate : NSDate?
  
  init() {}
  init(id: AnyObject, odometer: Int, pricePerGallon: Float, gallons: Float, octane: Int?, createdDate: NSDate?) {
    self.id = id
    self.odometer = odometer
    self.pricePerGallon = pricePerGallon
    self.gallons = gallons
    self.octane = octane
    self.createdDate = createdDate
  }
  
  func totalSpent() -> Float {
    if let price = pricePerGallon, gallons = gallons {
      return price * gallons
    }
    
    return 0
  }
}