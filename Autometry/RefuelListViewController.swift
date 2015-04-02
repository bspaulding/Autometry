import Foundation
import UIKit

class RefuelListViewController : UITableViewController {
  var refuels : [Refuel] = []
  let refuelStore = RefuelStore.sharedInstance
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
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
    refuels = refuelStore.all().sorted(createdDateSorter)
    refuelStore.register({
      self.refuels = self.refuelStore.all().sorted(createdDateSorter)
      self.tableView.reloadData()
    })
  }
  
  @IBAction func cancel(segue: UIStoryboardSegue) {
  }
  
  @IBAction func save(segue: UIStoryboardSegue) {
    let source = segue.sourceViewController as NewRefuelViewController
    refuelStore.create(source.refuel)
  }
  
  // TableViewDataSource interface
  
  override func numberOfSectionsInTableView(tableView: UITableView) -> NSInteger {
    return 1;
  }
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return refuels.count;
  }
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("RefuelCellIdentifier", forIndexPath: indexPath) as UITableViewCell
    
    let refuel = refuels[indexPath.row]
    var text = ""
    if let date = refuel.createdDate {
      text = formatters.dateFormatter.stringFromDate(date)
    } else {
      text = "Unknown Date"
    }
    (cell.viewWithTag(3000) as UILabel).text = text
    
    let odometerLabel = cell.viewWithTag(3001) as UILabel
    let odometerValue = "\(formatters.numberFormatter.stringFromNumber(refuel.odometer!)!) miles"
    odometerLabel.text = odometerValue
    odometerLabel.accessibilityValue = odometerValue
    
    (cell.viewWithTag(3002) as UILabel).text = formatters.currencyFormatter.stringFromNumber(refuel.pricePerGallon!)
    let total = refuel.totalSpent()
    (cell.viewWithTag(3004) as UILabel).text = formatters.currencyFormatter.stringFromNumber(total)

    return cell
  }
}