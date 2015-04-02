import Foundation
import UIKit

class DashboardViewController : UIViewController {
  @IBOutlet weak var mpgLabel: UILabel!
  @IBOutlet weak var pricePerGallonLabel: UILabel!
  @IBOutlet weak var totalSpentLabel: UILabel!
  @IBOutlet weak var totalMilesLabel: UILabel!
  
  let dashboard = Dashboard()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    dashboard.register({
      self.update()
    })
    update()
  }

  func update() {
    mpgLabel.text = dashboard.mpg()
    pricePerGallonLabel.text = dashboard.averagePPG()
    totalSpentLabel.text = dashboard.totalSpent()
    totalMilesLabel.text = dashboard.totalMiles()
  }
}