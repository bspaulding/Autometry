import Foundation
import UIKit

class RefuelListViewController : UITableViewController {
  var refuels : [Refuel] = []
  let refuelStore = RefuelStore.sharedInstance
  let dateFormatter = NSDateFormatter()
  let currencyFormatter = NSNumberFormatter()
  let numberFormatter = NSNumberFormatter()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
    currencyFormatter.numberStyle = .CurrencyStyle
    numberFormatter.numberStyle = .DecimalStyle
    
    refuels = refuelStore.all()
    refuelStore.register({
      self.refuels = self.refuelStore.all()
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
      text = dateFormatter.stringFromDate(date)
    } else {
      text = "Unknown Date"
    }
    (cell.viewWithTag(3000) as UILabel).text = text
    (cell.viewWithTag(3001) as UILabel).text = "\(numberFormatter.stringFromNumber(refuel.odometer!)!) miles"
    (cell.viewWithTag(3002) as UILabel).text = currencyFormatter.stringFromNumber(refuel.pricePerGallon!)

    return cell
  }
}