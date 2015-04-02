import Foundation
import UIKit

class DashboardViewController : UIViewController {
  @IBOutlet weak var mpgLabel: UILabel!
  @IBOutlet weak var pricePerGallonLabel: UILabel!
  @IBOutlet weak var totalSpentLabel: UILabel!
  @IBOutlet weak var totalMilesLabel: UILabel!
  
  let dashboard = Dashboard()
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
    let refuels = refuelStore.all().sorted(createdDateSorter)

    mpgLabel.text = dashboard.mpg(refuels)
    pricePerGallonLabel.text = dashboard.averagePPG(refuels)
    totalSpentLabel.text = dashboard.totalSpent(refuels)
    totalMilesLabel.text = dashboard.totalMiles(refuels)
  }
}