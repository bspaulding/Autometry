import Foundation

class Dashboard {
  func mpg(refuels : [Refuel]) -> String {
    if refuels.count <= 1 {
      return "N/A"
    }
    
    let gallons : Float = refuels[1...refuels.count - 1].reduce(0, { $0 + $1.gallons! })
    let miles = Float(refuels[0].odometer! - refuels[refuels.count-1].odometer!)
    let mpg = Int(miles / gallons)
    
    return "\(mpg)"
  }
  
  func averagePPG(refuels : [Refuel]) -> String {
    let averagePPG = refuels.reduce(0, { $0 + $1.pricePerGallon! }) / Float(refuels.count)
    return formatters.currencyFormatter.stringFromNumber(averagePPG)!
  }
  
  func totalSpent(refuels : [Refuel]) -> String {
    let totalSpent = refuels.reduce(0, { $0 + $1.totalSpent() })
    return formatters.currencyFormatter.stringFromNumber(totalSpent)!
  }
  
  func totalMiles(refuels : [Refuel]) -> String {
    if refuels.count == 0 {
      return "0"
    }
    
    return formatters.numberFormatter.stringFromNumber(refuels[0].odometer!)!
  }
}