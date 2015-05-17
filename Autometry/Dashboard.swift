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
    if refuels.count < 1 {
      return "N/A"
    }
    
    let averagePPG = refuels.reduce(0, combine: { $0 + $1.pricePerGallon! }) / Float(refuels.count)
    return formatters.currencyFormatter.stringFromNumber(averagePPG)!
  }
  
  func pricePerGallonBest(refuels:[Refuel]) -> String {
    if refuels.count < 1 {
      return "N/A"
    }
    
    let ppg = minElement(refuels.map { $0.pricePerGallon! })
    return formatters.currencyFormatter.stringFromNumber(ppg)!
  }
  
  func pricePerGallonWorst(refuels:[Refuel]) -> String {
    if refuels.count < 1 {
      return "N/A"
    }
    
    let ppg = maxElement(refuels.map { $0.pricePerGallon! })
    return formatters.currencyFormatter.stringFromNumber(ppg)!
  }
  
  func totalSpent(refuels : [Refuel]) -> String {
    return formatters.currencyFormatter.stringFromNumber(totalSpent(refuels))!
  }
  
  func totalSpentBest(refuels:[Refuel]) -> String {
    if refuels.count < 1 {
      return "$0.00"
    }
    
    let cost = minElement(refuels.map({ $0.totalSpent() }))
    return formatters.currencyFormatter.stringFromNumber(cost)!
  }
  
  func totalSpentWorst(refuels:[Refuel]) -> String {
    if refuels.count < 1 {
      return "$0.00"
    }
    
    let cost = maxElement(refuels.map({ $0.totalSpent() }))
    return formatters.currencyFormatter.stringFromNumber(cost)!
  }
  
  func totalMiles(refuels : [Refuel]) -> String {
    if refuels.count <= 1 {
      return "0"
    }

    return formatters.numberFormatter.stringFromNumber(miles(refuels))!
  }
  
  func totalMilesLongest(refuels:[Refuel]) -> String {
    if refuels.count <= 1 {
      return "0"
    }
    
    let miles = maxElement(milesPerTrip(refuels))
    return formatters.numberFormatter.stringFromNumber(miles)!
  }
  
  func totalMilesShortest(refuels:[Refuel]) -> String {
    if refuels.count <= 1 {
      return "0"
    }
    
    let miles = minElement(milesPerTrip(refuels))
    return formatters.numberFormatter.stringFromNumber(miles)!
  }
  
  func costPerMile(refuels: [Refuel]) -> String {
    if refuels.count <= 1 {
      return "$0.00"
    }
    
    let _cpms = cpms(refuels)
    let cpm = _cpms.reduce(0.0, combine: { $0 + $1 }) / Float(_cpms.count)
    return formatters.currencyFormatter.stringFromNumber(cpm)!
  }
  
  func costPerMileBest(refuels: [Refuel]) -> String {
    if refuels.count <= 1 {
      return "$0.00"
    }
    
    let cpm = minElement(cpms(refuels))
    return formatters.currencyFormatter.stringFromNumber(cpm)!
  }
  
  func costPerMileWorst(refuels: [Refuel]) -> String {
    if refuels.count <= 1 {
      return "$0.00"
    }
    
    let cpm = maxElement(cpms(refuels))
    return formatters.currencyFormatter.stringFromNumber(cpm)!
  }
  
  // Helpers
  
  func mpgs(refuels: [Refuel]) -> [Int] {
    return map(enumerate(refuels[1...refuels.count - 1])) { (index, refuel) in
      let previous = refuels[index]
      let miles = Float(previous.odometer! - refuel.odometer!)
      
      return Int(miles / refuel.gallons!)
    }
  }
  
  private func cpms(refuels: [Refuel]) -> [Float] {
    return map(enumerate(refuels[0...refuels.count - 2])) { (index, refuel) in
      let previous = refuels[index+1]
      let cost = previous.totalSpent()
      let miles = Float(refuel.odometer! - previous.odometer!)
      return cost / miles
    }
  }
 
  private func miles(refuels: [Refuel]) -> Float {
    return Float(refuels[0].odometer! - refuels[refuels.count-1].odometer!)
  }
  
  func milesPerTrip(refuels: [Refuel]) -> [Int] {
    return map(enumerate(refuels[0...refuels.count - 2])) {(index,refuel) in
      return refuel.odometer! - refuels[index+1].odometer!
    }
  }
  
  private func totalSpent(refuels: [Refuel]) -> Float {
    return refuels.reduce(0, combine: { $0 + $1.totalSpent() })
  }
}