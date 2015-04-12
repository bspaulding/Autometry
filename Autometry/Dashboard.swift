import Foundation

class Dashboard {
  func mpgAverage(refuels : [Refuel]) -> String {
    if refuels.count <= 1 {
      return "N/A"
    }
    
    let gallons : Float = refuels[1...refuels.count - 1].reduce(0, combine: { $0 + $1.gallons! })
    let mpg = Int(miles(refuels) / gallons)
    
    return "\(mpg)"
  }
  
  func mpgBest(refuels: [Refuel]) -> String {
    if refuels.count <= 1 {
      return "N/A"
    }
    
    let mpg = maxElement(mpgs(refuels))
    return "\(mpg)"
  }
  
  func mpgWorst(refuels: [Refuel]) -> String {
    if refuels.count <= 1 {
      return "N/A"
    }
    
    let mpg = minElement(mpgs(refuels))
    return "\(mpg)"
  }
  
  func averagePPG(refuels : [Refuel]) -> String {
    let averagePPG = refuels.reduce(0, combine: { $0 + $1.pricePerGallon! }) / Float(refuels.count)
    return formatters.currencyFormatter.stringFromNumber(averagePPG)!
  }
  
  func totalSpent(refuels : [Refuel]) -> String {
    let totalSpent = refuels.reduce(0, combine: { $0 + $1.totalSpent() })
    return formatters.currencyFormatter.stringFromNumber(totalSpent)!
  }
  
  func totalMiles(refuels : [Refuel]) -> String {
    if refuels.count <= 1 {
      return "0"
    }

    return formatters.numberFormatter.stringFromNumber(miles(refuels))!
  }
  
  // Helpers
  
  private func mpgs(refuels: [Refuel]) -> [Int] {
    return map(enumerate(refuels[1...refuels.count - 1])) { (index, refuel) in
      let previous = refuels[index]
      let miles = Float(previous.odometer! - refuel.odometer!)
      
      return Int(miles / refuel.gallons!)
    }
  }
 
  private func miles(refuels: [Refuel]) -> Float {
    return Float(refuels[0].odometer! - refuels[refuels.count-1].odometer!)
  }
}