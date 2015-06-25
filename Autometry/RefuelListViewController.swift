import Foundation
import UIKit
import CoreData

class RefuelListViewController : UITableViewController {
  var refuels : [Refuel] = []
  var mpgs : [Int] = []
  var milesPerTrip : [Int] = []
  var selectedRefuel : Refuel? = nil
  let refuelStore = RefuelStore.sharedInstance
  let calculator = Dashboard()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.autoresizingMask = .FlexibleWidth | .FlexibleHeight
        
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
    mpgs = calculator.mpgs(refuels)
    milesPerTrip = calculator.milesPerTrip(refuels)
    
    refuelStore.register({
      self.refuels = self.refuelStore.all().sorted(createdDateSorter)
      self.mpgs = self.calculator.mpgs(self.refuels)
      self.milesPerTrip = self.calculator.milesPerTrip(self.refuels)
      println(self.calculator.milesPerTrip(self.refuels))
      self.tableView.reloadData()
    })
  }
  
  @IBAction func cancel(segue: UIStoryboardSegue) {
  }
  
  @IBAction func save(segue: UIStoryboardSegue) {
    let source = segue.sourceViewController as! NewRefuelViewController
    refuelStore.create(source.refuel)
  }
  
  override func prepareForSegue(segue:UIStoryboardSegue, sender:AnyObject?) {
    if segue.identifier == "ShowRefuelDetail" {
      let destination = segue.destinationViewController as! RefuelDetailViewController
      destination.refuel = selectedRefuel!
    }
  }
  
  // TableViewDataSource interface
  
  override func numberOfSectionsInTableView(tableView: UITableView) -> NSInteger {
    return 1;
  }
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return refuels.count;
  }
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("RefuelCellIdentifier", forIndexPath: indexPath) as! UITableViewCell
    
    let refuel = refuels[indexPath.row]
    var text = ""
    if let date = refuel.createdDate {
      text = formatters.dateFormatter.stringFromDate(date)
    } else {
      text = "Unknown Date"
    }
    (cell.viewWithTag(3000) as! UILabel).text = text
    
    let odometerLabel = cell.viewWithTag(3001) as! UILabel
    var odometerValue = ""
    if indexPath.row > 0 && indexPath.row - 1 < milesPerTrip.count {
      let miles = formatters.numberFormatter.stringFromNumber(milesPerTrip[indexPath.row - 1])!
      odometerValue = "\(miles) miles"
    }

    var mpgValue = ""
    if indexPath.row > 0 {
      mpgValue = "\(mpgs[indexPath.row - 1]) mpg"
    }
    odometerLabel.text = ", ".join(compact([odometerValue, mpgValue]))
    odometerLabel.accessibilityValue = odometerValue
    
    (cell.viewWithTag(3002) as! UILabel).text = formatters.currencyFormatter.stringFromNumber(refuel.pricePerGallon!)
    let total = refuel.totalSpent()
    (cell.viewWithTag(3004) as! UILabel).text = formatters.currencyFormatter.stringFromNumber(total)

    return cell
  }
  override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    return true
  }
  override func tableView(tableView: UITableView, commitEditingStyle editingStyle:UITableViewCellEditingStyle, forRowAtIndexPath indexPath:NSIndexPath) {
    if editingStyle == UITableViewCellEditingStyle.Delete {
      let refuel = refuels[indexPath.row]
      refuels = refuels.filter({ $0.id as! NSManagedObjectID != refuel.id as! NSManagedObjectID })
      tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation:UITableViewRowAnimation.Fade)
      refuelStore.delete(refuel)
    } else {
      println("Unhandled editing style: ", editingStyle);
    }
  }
  
  // TableViewDelegate protocol
  
  override func tableView(tableView:UITableView, didSelectRowAtIndexPath indexPath:NSIndexPath) {
    selectedRefuel = refuels[indexPath.row]
    performSegueWithIdentifier("ShowRefuelDetail", sender: self)
  }
}