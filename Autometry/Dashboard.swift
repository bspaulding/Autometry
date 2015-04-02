import Foundation

class Dashboard : Observable {
  var refuels : [Refuel] = []
  let refuelStore = RefuelStore.sharedInstance
  let createdDateSorter : (Refuel,Refuel) -> Bool = {(a,b) in
    switch (a.createdDate,b.createdDate) {
    case let (.Some(aDate), .Some(bDate)):
      return aDate.timeIntervalSinceNow > bDate.timeIntervalSinceNow
    case let (.None, .Some(bDate)):
      return false
    case let (.Some(bDate), .None):
      return true
    case let (.None, .None):
      return false
    }
  }

  override init() {
    super.init()
    
    refuels = refuelStore.all().sorted(createdDateSorter)
    refuelStore.register({
      self.refuels = self.refuelStore.all().sorted(self.createdDateSorter)
      self.emitChange()
    })
  }

  func mpg() -> String {
    if refuels.count <= 1 {
      return "N/A"
    }
    
    let gallons : Float = refuels.reduce(0, { $0 + $1.gallons! })
    let miles = Float(refuels[0].odometer!)
    let mpg = Int(miles / gallons)
    
    return "\(mpg)"
  }
  
  func averagePPG() -> String {
    let averagePPG = refuels.reduce(0, { $0 + $1.pricePerGallon! }) / Float(refuels.count)
    return formatters.currencyFormatter.stringFromNumber(averagePPG)!
  }
  
  func totalSpent() -> String {
    let totalSpent = refuels.reduce(0, { $0 + $1.totalSpent() })
    return formatters.currencyFormatter.stringFromNumber(totalSpent)!
  }
  
  func totalMiles() -> String {
    if refuels.count == 0 {
      return "0"
    }
    
    return formatters.numberFormatter.stringFromNumber(refuels[0].odometer!)!
  }
}