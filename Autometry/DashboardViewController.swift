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
    
    let borderColor = UIColor(red: 156.0/255.0, green: 156.0/255.0, blue: 156.0/255.0, alpha: 1.0)
    let borderWidth = 0.5
    panels = [totalsPanel, mpgPanel, cpmPanel, ppgPanel]
    panels.map {
      self.addTopBorder($0, width: borderWidth, color: borderColor)
    }
    panels.map {
      self.addBottomBorder($0, width: borderWidth, color: borderColor)
    }
    
    refuelStore.register({
      self.update()
    })
    update()
  }

  func update() {
    let refuels = refuelStore.all().sorted(createdDateSorter)
    
    let contentView = self.view.viewWithTag(7)!
    if refuels.count < 1 {
      panels.map { $0.removeFromSuperview() }
      contentView.addSubview(noDataMessage)
    } else {
      panels.map { contentView.addSubview($0) }
      noDataMessage.removeFromSuperview()
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
  
  func addTopBorder(view : UIView, width : Double, color : UIColor) {
    let viewSize = view.bounds.size
    let border = UIView(frame: CGRectMake(0, 0, viewSize.width, CGFloat(width)))
    border.opaque = true
    border.backgroundColor = color
    border.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleBottomMargin;
    view.addSubview(border)
  }

  func addBottomBorder(view : UIView, width : Double, color : UIColor) {
    let viewSize = view.bounds.size
    let border = UIView(frame: CGRectMake(0, viewSize.height, viewSize.width, CGFloat(width)))
    border.opaque = true
    border.backgroundColor = color
    border.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleBottomMargin;
    view.addSubview(border)
  }
}