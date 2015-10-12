import UIKit

class RefuelDetailViewController : UITableViewController {
  var refuel : Refuel?
  
  @IBOutlet weak var odometerLabel: UILabel!
  @IBOutlet weak var locationNameLabel: UILabel!
  @IBOutlet weak var fullLabel: UILabel!
  @IBOutlet weak var octaneLabel: UILabel!
  @IBOutlet weak var pricePerGallonLabel: UILabel!
  @IBOutlet weak var gallonsLabel: UILabel!
  @IBOutlet weak var totalLabel: UILabel!
  
  override func viewDidLoad() {
    let refuel = self.refuel!
    
    if let odometer = refuel.odometer {
      odometerLabel.text = formatters.numberFormatter.stringFromNumber(odometer)
    }
    
    if let station = refuel.station {
      locationNameLabel.text = station.name
    } else {
      locationNameLabel.text = ""
    }
    
    if refuel.isPartial() {
      fullLabel.text = "No"
    } else {
      fullLabel.text = "Yes"
    }
    
    if let octane = refuel.octane {
      octaneLabel.text = formatters.numberFormatter.stringFromNumber(octane)
    }
    
    if let pricePerGallon = refuel.pricePerGallon {
      pricePerGallonLabel.text = formatters.currencyFormatter.stringFromNumber(pricePerGallon)
    }
    
    if let gallons = refuel.gallons {
      gallonsLabel.text = formatters.numberFormatter.stringFromNumber(gallons)
    }
    
    totalLabel.text = formatters.currencyFormatter.stringFromNumber(refuel.totalSpent())
  }
}