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
    
    let mpg = mpgs(refuels).maxElement()!
    return "\(mpg)"
  }
  
  func mpgWorst(refuels: [Refuel]) -> String {
    if refuels.count <= 1 {
      return "N/A"
    }
    
    let mpg = mpgs(refuels).minElement()!
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
    
    let ppg = refuels.map { $0.pricePerGallon! }.minElement()!
    return formatters.currencyFormatter.stringFromNumber(ppg)!
  }
  
  func pricePerGallonWorst(refuels:[Refuel]) -> String {
    if refuels.count < 1 {
      return "N/A"
    }
    
    let ppg = refuels.map { $0.pricePerGallon! }.maxElement()!
    return formatters.currencyFormatter.stringFromNumber(ppg)!
  }
  
  func totalSpent(refuels : [Refuel]) -> String {
    return formatters.currencyFormatter.stringFromNumber(totalSpent(refuels))!
  }
  
  func totalSpentBest(refuels:[Refuel]) -> String {
    if refuels.count < 1 {
      return "$0.00"
    }
    
    let cost = refuels.map({ $0.totalSpent() }).minElement()!
    return formatters.currencyFormatter.stringFromNumber(cost)!
  }
  
  func totalSpentWorst(refuels:[Refuel]) -> String {
    if refuels.count < 1 {
      return "$0.00"
    }
    
    let cost = refuels.map({ $0.totalSpent() }).maxElement()!
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
    
    let miles = milesPerTrip(refuels).maxElement()!
    return formatters.numberFormatter.stringFromNumber(miles)!
  }
  
  func totalMilesShortest(refuels:[Refuel]) -> String {
    if refuels.count <= 1 {
      return "0"
    }
    
    let miles = milesPerTrip(refuels).minElement()!
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
    
    let cpm = cpms(refuels).minElement()!
    return formatters.currencyFormatter.stringFromNumber(cpm)!
  }
  
  func costPerMileWorst(refuels: [Refuel]) -> String {
    if refuels.count <= 1 {
      return "$0.00"
    }
    
    let cpm = cpms(refuels).maxElement()!
    return formatters.currencyFormatter.stringFromNumber(cpm)!
  }
  
  // Helpers
  
  func mpgs(refuels: [Refuel]) -> [Int] {
    if refuels.count <= 1 {
      return []
    }
    
    return refuels[0...refuels.count - 2].enumerate().map({ (index, refuel) in
      let previous = refuels[index + 1]
      let miles = Float(refuel.odometer! - previous.odometer!)
      
      return Int(miles / refuel.gallons!)
    })
  }
  
  private func cpms(refuels: [Refuel]) -> [Float] {
    return refuels[0...refuels.count - 2].enumerate().map({ (index, refuel) in
      let previous = refuels[index+1]
      let cost = previous.totalSpent()
      let miles = Float(refuel.odometer! - previous.odometer!)
      return cost / miles
    })
  }
 
  private func miles(refuels: [Refuel]) -> Float {
    return Float(refuels[0].odometer! - refuels[refuels.count-1].odometer!)
  }
  
  func milesPerTrip(refuels: [Refuel]) -> [Int] {
    if refuels.count <= 1 {
      return []
    }
    
    return refuels[0...refuels.count - 2].enumerate().map({(index,refuel) in
      return Int(refuel.odometer!) - Int(refuels[index+1].odometer!)
    })
  }
  
  private func totalSpent(refuels: [Refuel]) -> Float {
    return refuels.reduce(0, combine: { $0 + $1.totalSpent() })
  }
}