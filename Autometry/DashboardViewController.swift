import Foundation
import UIKit

class DashboardViewController : UIViewController {
  @IBOutlet weak var mpgAverageLabel: UILabel!
  @IBOutlet weak var cpmAverageLabel: UILabel!
  @IBOutlet weak var ppgAverageLabel: UILabel!
  @IBOutlet weak var totalMilesLabel: UILabel!
  @IBOutlet weak var totalSpentLabel: UILabel!
  
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
    
    if let image = UIImage(named: "BarGraphIconSelected.png") {
      tabBarItem.selectedImage = image
    }
    
    refuelStore.register({
      self.update()
    })
    update()
  }

  func update() {
    let refuels = refuelStore.all().sorted(createdDateSorter)

    mpgAverageLabel.text = dashboard.mpgAverage(refuels)
    ppgAverageLabel.text = dashboard.averagePPG(refuels)
    totalSpentLabel.text = dashboard.totalSpent(refuels)
    totalMilesLabel.text = dashboard.totalMiles(refuels)
  }
}