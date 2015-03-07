import Foundation
import UIKit
import MessageUI

class RefuelListViewController : UITableViewController, MFMailComposeViewControllerDelegate {
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
  
  var picker : MFMailComposeViewController?
  
  @IBAction func export(sender: AnyObject) {
    let picker = MFMailComposeViewController()
    self.picker = picker
    picker.mailComposeDelegate = self
    picker.setSubject("Hello, Mail")
    picker.setMessageBody("Autometry data export", isHTML: false)
    
    refuels.map({RefuelCSVWrapper.wrap($0)})
    
    presentViewController(picker, animated:true, completion:nil)
  }
  
  func mailComposeController(controller: MFMailComposeViewController!,
    didFinishWithResult result: MFMailComposeResult,
    error: NSError!) {
    if let picker = self.picker {
      picker.dismissViewControllerAnimated(true, completion:nil)
    }
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