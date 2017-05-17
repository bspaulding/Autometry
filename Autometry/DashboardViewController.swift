import Foundation
import UIKit

class DashboardViewController : UIViewController {
  @IBOutlet weak var mpgAverageLabel: UILabel!
  @IBOutlet weak var mpgBestLabel: UILabel!
  @IBOutlet weak var mpgWorstLabel: UILabel!
  
  @IBOutlet weak var cpmAverageLabel: UILabel!
  @IBOutlet weak var cpmBestLabel: UILabel!
  @IBOutlet weak var cpmWorstLabel: UILabel!
  
  @IBOutlet weak var ppgAverageLabel: UILabel!
  @IBOutlet weak var ppgBestLabel: UILabel!
  @IBOutlet weak var ppgWorstLabel: UILabel!
  
  @IBOutlet weak var totalMilesLabel: UILabel!
  @IBOutlet weak var totalSpentLabel: UILabel!
  
  @IBOutlet weak var mpgPanel: UIView!
  @IBOutlet weak var ppgPanel: UIView!
  @IBOutlet weak var cpmPanel: UIView!
  @IBOutlet weak var totalsPanel: UIView!
  
  @IBOutlet weak var noDataMessage: UILabel!

  var panels : [UIView] = []
  
  let dashboard = Dashboard()
  let refuelStore = RefuelStore.sharedInstance
  let createdDateSorter : (Refuel,Refuel) -> Bool = {(a,b) in
    switch (a.createdDate,b.createdDate) {
    case let (.some(aDate), .some(bDate)):
      return aDate.timeIntervalSinceNow > bDate.timeIntervalSinceNow
    case (.none, .some(_)):
      return false
    case (.some(_), .none):
      return true
    case (.none, .none):
      return false
    }
  }
    
  override func viewDidLoad() {
    super.viewDidLoad()
    
    if let image = UIImage(named: "BarGraphIconSelected.png") {
      tabBarItem.selectedImage = image
    }
    
    let borderColor = UIColor(red: 156.0/255.0, green: 156.0/255.0, blue: 156.0/255.0, alpha: 1.0)
    let borderWidth = 0.5
    panels = [totalsPanel, mpgPanel, cpmPanel, ppgPanel]
    panels.forEach {
      self.addTopBorder($0, width: borderWidth, color: borderColor)
    }
    panels.forEach {
      self.addBottomBorder($0, width: borderWidth, color: borderColor)
    }
    
    refuelStore.register({
      self.update()
    })
    update()
  }

  func update() {
    let refuels = refuelStore.all().sorted(by: createdDateSorter)
    
    if refuels.count < 1 {
      panels.forEach { $0.isHidden = true }
      noDataMessage.isHidden = false
      view.isUserInteractionEnabled = false
    } else {
      panels.forEach { $0.isHidden = false }
      noDataMessage.isHidden = true
      view.isUserInteractionEnabled = true
    }

    mpgAverageLabel.text = dashboard.mpgAverage(refuels)
    mpgBestLabel.text = dashboard.mpgBest(refuels)
    mpgWorstLabel.text = dashboard.mpgWorst(refuels)
    
    cpmAverageLabel.text = dashboard.costPerMile(refuels)
    cpmBestLabel.text = dashboard.costPerMileBest(refuels)
    cpmWorstLabel.text = dashboard.costPerMileWorst(refuels)
    
    ppgAverageLabel.text = dashboard.averagePPG(refuels)
    ppgBestLabel.text = dashboard.pricePerGallonBest(refuels)
    ppgWorstLabel.text = dashboard.pricePerGallonWorst(refuels)
    
    totalSpentLabel.text = dashboard.totalSpent(refuels)
    totalMilesLabel.text = dashboard.totalMiles(refuels)
  }
  
  // helpers
  
  func addTopBorder(_ view : UIView, width : Double, color : UIColor) {
    let viewSize = view.bounds.size
    let border = UIView(frame: CGRect(x: 0, y: 0, width: viewSize.width, height: CGFloat(width)))
    border.isOpaque = true
    border.backgroundColor = color
    border.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleBottomMargin];
    view.addSubview(border)
  }

  func addBottomBorder(_ view : UIView, width : Double, color : UIColor) {
    let viewSize = view.bounds.size
    let border = UIView(frame: CGRect(x: 0, y: viewSize.height, width: viewSize.width, height: CGFloat(width)))
    border.isOpaque = true
    border.backgroundColor = color
    border.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleBottomMargin];
    view.addSubview(border)
  }
}
