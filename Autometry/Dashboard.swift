import Foundation

class Dashboard {    
  func toDictionary(_ refuels: [Refuel]) -> [String : String] {
    return [
      "totalMiles": totalMiles(refuels),
      "totalSpent": totalSpent(refuels),
      "mpgAverage": mpgAverage(refuels),
      "mpgBest": mpgBest(refuels),
      "mpgWorst": mpgWorst(refuels),
      "cpmAverage": costPerMile(refuels),
      "cpmBest": costPerMileBest(refuels),
      "cpmWorst": costPerMileWorst(refuels),
      "ppgAverage": averagePPG(refuels),
      "ppgBest": pricePerGallonBest(refuels),
      "ppgWorst": pricePerGallonWorst(refuels)
    ];
  }
  
  func mpgAverage(_ refuels : [Refuel]) -> String {
    if refuels.count <= 1 {
      return "N/A"
    }
    
    let gallons : Float = refuels[1...refuels.count - 1].reduce(0, { $0 + $1.gallons! })
    let mpg = Int(miles(refuels) / gallons)
    
    return "\(mpg)"
  }
  
  func mpgBest(_ refuels: [Refuel]) -> String {
    if refuels.count <= 1 {
      return "N/A"
    }
    
    let mpg = mpgs(refuels).max()!
    return "\(mpg)"
  }
  
  func mpgWorst(_ refuels: [Refuel]) -> String {
    if refuels.count <= 1 {
      return "N/A"
    }
    
    let mpg = mpgs(refuels).min()!
    return "\(mpg)"
  }
  
  func averagePPG(_ refuels : [Refuel]) -> String {
    if refuels.count < 1 {
      return "N/A"
    }
    
    let averagePPG = refuels.reduce(0, { $0 + $1.pricePerGallon! }) / Float(refuels.count)
    return formatters.currencyFormatter.string(from: NSNumber(value: averagePPG))!
  }
  
  func pricePerGallonBest(_ refuels:[Refuel]) -> String {
    if refuels.count < 1 {
      return "N/A"
    }
    
    let ppg = refuels.map { $0.pricePerGallon! }.min()!
    return formatters.currencyFormatter.string(from: NSNumber(value: ppg))!
  }
  
  func pricePerGallonWorst(_ refuels:[Refuel]) -> String {
    if refuels.count < 1 {
      return "N/A"
    }
    
    let ppg = refuels.map { $0.pricePerGallon! }.max()!
    return formatters.currencyFormatter.string(from: NSNumber(value: ppg))!
  }
  
  func totalSpent(_ refuels : [Refuel]) -> String {
    return formatters.currencyFormatter.string(from: NSNumber(value: totalSpent(refuels)))!
  }
  
  func totalSpentBest(_ refuels:[Refuel]) -> String {
    if refuels.count < 1 {
      return "$0.00"
    }
    
    let cost = refuels.map({ $0.totalSpent() }).min()!
    return formatters.currencyFormatter.string(from: NSNumber(value: cost))!
  }
  
  func totalSpentWorst(_ refuels:[Refuel]) -> String {
    if refuels.count < 1 {
      return "$0.00"
    }
    
    let cost = refuels.map({ $0.totalSpent() }).max()!
    return formatters.currencyFormatter.string(from: NSNumber(value: cost))!
  }
  
  func totalMiles(_ refuels : [Refuel]) -> String {
    if refuels.count <= 1 {
      return "0"
    }

    return formatters.numberFormatter.string(from: NSNumber(value: miles(refuels)))!
  }
  
  func totalMilesLongest(_ refuels:[Refuel]) -> String {
    if refuels.count <= 1 {
      return "0"
    }
    
    let miles = milesPerTrip(refuels).max()!
    return formatters.numberFormatter.string(from: NSNumber(value: miles))!
  }
  
  func totalMilesShortest(_ refuels:[Refuel]) -> String {
    if refuels.count <= 1 {
      return "0"
    }
    
    let miles = milesPerTrip(refuels).min()!
    return formatters.numberFormatter.string(from: NSNumber(value: miles))!
  }
  
  func costPerMile(_ refuels: [Refuel]) -> String {
    if refuels.count <= 1 {
      return "$0.00"
    }
    
    let _cpms = cpms(refuels)
    let cpm = _cpms.reduce(0.0, { $0 + $1 }) / Float(_cpms.count)
    return formatters.currencyFormatter.string(from: NSNumber(value: cpm))!
  }
  
  func costPerMileBest(_ refuels: [Refuel]) -> String {
    if refuels.count <= 1 {
      return "$0.00"
    }
    
    let cpm = cpms(refuels).min()!
    return formatters.currencyFormatter.string(from: NSNumber(value: cpm))!
  }
  
  func costPerMileWorst(_ refuels: [Refuel]) -> String {
    if refuels.count <= 1 {
      return "$0.00"
    }
    
    let cpm = cpms(refuels).max()!
    return formatters.currencyFormatter.string(from: NSNumber(value: cpm))!
  }
  
  // Helpers
  
  func arrayFind<T>(_ f: (T) -> Bool, xs: [T]) -> T? {
    for (_, x) in xs.enumerated() {
      if f(x) {
        return x;
      }
    }
    
    return nil
  }
  
  func arrayFindRight<T>(_ f: (T) -> Bool, xs: [T]) -> T? {
    for i in (0...(xs.count - 1)).reversed() {
      if f(xs[i]) {
        return xs[i];
      }
    }
    
    return nil
  }
  
  func arraySliceFindRight<T>(_ f: (T) -> Bool, xs: ArraySlice<T>) -> T? {
    for i in (0...(xs.count - 1)).reversed() {
      if f(xs[i]) {
        return xs[i];
      }
    }
    
    return nil
  }
  
  func arraySliceFind<T>(_ f: (T) -> Bool, xs: ArraySlice<T>) -> T? {
    for (_, x) in xs.enumerated() {
      if f(x) {
        return x;
      }
    }
    
    return nil
  }
  
  let isFull: (Refuel) -> Bool = { !$0.isPartial() }
  
  func tripEnd(_ refuels: [Refuel], currentRefuel: Refuel) -> Refuel? {
    if let currentRefuelIndex = refuels.index(where: { $0 === currentRefuel }) {
      return arraySliceFindRight(isFull,
        xs: refuels[0...currentRefuelIndex]
      )
    }
    
    return refuels[0]
  }
  
  func tripStart(_ refuels: [Refuel], currentRefuel: Refuel) -> Refuel {
    if let currentRefuelIndex = refuels.index(where: { $0 === currentRefuel }) {
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
  
  func mpgs(_ refuels: [Refuel]) -> [Int] {
    if refuels.count <= 1 {
      return []
    }
    
    var firstFullRefuelIndex = 0
    if let firstFullRefuel = arrayFind(isFull, xs: refuels) {
      firstFullRefuelIndex = refuels.index(where: { $0 === firstFullRefuel })!
    }
    
    return refuels[firstFullRefuelIndex...refuels.count - 2].enumerated().map({ (index, refuel) in
      let start = tripStart(refuels, currentRefuel: refuel)
      let end = tripEnd(refuels, currentRefuel: refuel)!
      let miles = Float(end.odometer! - start.odometer!)
      
      let startIndex = refuels.index(where: { $0 === start })!
      let endIndex = refuels.index(where: { $0 === end })!
      let gallons = refuels[endIndex...startIndex - 1]
        .map({ $0.getGallons() })
        .reduce(0, +)
      
      return Int(miles / gallons)
    })
  }
  
  fileprivate func cpms(_ refuels: [Refuel]) -> [Float] {
    return refuels[0...refuels.count - 2].enumerated().map({ (index, refuel) in
      let previous = refuels[index+1]
      let cost = previous.totalSpent()
      let miles = Float(refuel.odometer! - previous.odometer!)
      return cost / miles
    })
  }
 
  fileprivate func miles(_ refuels: [Refuel]) -> Float {
    return Float(refuels[0].odometer! - refuels[refuels.count-1].odometer!)
  }
  
  func milesPerTrip(_ refuels: [Refuel]) -> [Int] {
    if refuels.count <= 1 {
      return []
    }
    
    return refuels[0...refuels.count - 2].enumerated().map({(index,refuel) in
      return Int(refuel.odometer!) - Int(refuels[index+1].odometer!)
    })
  }
  
  fileprivate func totalSpent(_ refuels: [Refuel]) -> Float {
    return refuels.reduce(0, { $0 + $1.totalSpent() })
  }
}
