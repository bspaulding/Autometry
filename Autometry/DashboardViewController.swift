import Foundation
import UIKit

class DashboardViewController : UIViewController {
  @IBOutlet weak var mpgLabel: UILabel!
  @IBOutlet weak var pricePerGallonLabel: UILabel!
  @IBOutlet weak var totalSpentLabel: UILabel!
  @IBOutlet weak var totalMilesLabel: UILabel!
  
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
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    refuelStore.register({
      self.update()
    })
    update()
  }

  func update() {
    refuels = refuelStore.all().sorted(createdDateSorter)
    
    mpgLabel.text = mpg()
    pricePerGallonLabel.text = averagePPG()
    totalSpentLabel.text = totalSpent()
    totalMilesLabel.text = totalMiles()
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
    return formatters.numberFormatter.stringFromNumber(refuels[0].odometer!)!
  }
}
