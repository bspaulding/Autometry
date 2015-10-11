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
  
  func arrayFind<T>(f: T -> Bool, xs: [T]) -> T? {
    for (_, x) in xs.enumerate() {
      if f(x) {
        return x;
      }
    }
    
    return nil
  }
  
  func arrayFindRight<T>(f: T -> Bool, xs: [T]) -> T? {
    for (var i = xs.count - 1; i >= 0; i -= 1) {
      if f(xs[i]) {
        return xs[i];
      }
    }
    
    return nil
  }
  
  func arraySliceFindRight<T>(f: T -> Bool, xs: ArraySlice<T>) -> T? {
    for (var i = xs.count - 1; i >= 0; i -= 1) {
      if f(xs[i]) {
        return xs[i];
      }
    }
    
    return nil
  }
  
  func arraySliceFind<T>(f: T -> Bool, xs: ArraySlice<T>) -> T? {
    for (_, x) in xs.enumerate() {
      if f(x) {
        return x;
      }
    }
    
    return nil
  }
  
  let isFull: Refuel -> Bool = { !$0.isPartial() }
  
  func tripEnd(refuels: [Refuel], currentRefuel: Refuel) -> Refuel? {
    if let currentRefuelIndex = refuels.indexOf({ $0 === currentRefuel }) {
      return arraySliceFindRight(isFull,
        xs: refuels[0...currentRefuelIndex]
      )
    }
    
    return refuels[0]
  }
  
  func tripStart(refuels: [Refuel], currentRefuel: Refuel) -> Refuel {
    if let currentRefuelIndex = refuels.indexOf({ $0 === currentRefuel }) {
      let lastFull = arraySliceFind(isFull,
        xs: refuels[currentRefuelIndex + 1...refuels.count - 1]
      )
      if let last = lastFull {
        return last
      } else {
        return refuels.last!
      }
    }
    
    return refuels.last!
  }
  
  func mpgs(refuels: [Refuel]) -> [Int] {
    if refuels.count <= 1 {
      return []
    }
    
    var firstFullRefuelIndex = 0
    if let firstFullRefuel = arrayFind(isFull, xs: refuels) {
      firstFullRefuelIndex = refuels.indexOf({ $0 === firstFullRefuel })!
    }
    
    return refuels[firstFullRefuelIndex...refuels.count - 2].enumerate().map({ (index, refuel) in
      let start = tripStart(refuels, currentRefuel: refuel)
      let end = tripEnd(refuels, currentRefuel: refuel)!
      let miles = Float(end.odometer! - start.odometer!)
      
      let startIndex = refuels.indexOf({ $0 === start })!
      let endIndex = refuels.indexOf({ $0 === end })!
      let gallons = refuels[endIndex...startIndex - 1]
        .map({ $0.getGallons() })
        .reduce(0, combine: +)
      
      return Int(miles / gallons)
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