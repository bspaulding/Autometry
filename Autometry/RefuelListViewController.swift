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
    
    tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
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

    refuels = refuelStore.all().sorted(by: createdDateSorter)
    mpgs = calculator.mpgs(refuels)
    milesPerTrip = calculator.milesPerTrip(refuels)
    
    refuelStore.register({
      self.refuels = self.refuelStore.all().sorted(by: createdDateSorter)
      self.mpgs = self.calculator.mpgs(self.refuels)
      self.milesPerTrip = self.calculator.milesPerTrip(self.refuels)
      print(self.calculator.milesPerTrip(self.refuels))
      self.tableView.reloadData()
    })
  }
  
  @IBAction func cancel(_ segue: UIStoryboardSegue) {
  }
  
  @IBAction func save(_ segue: UIStoryboardSegue) {
    let source = segue.source as! RefuelDetailViewController
    if let _ = source.refuel.id {
      refuelStore.update(source.refuel)
    } else {
      refuelStore.create(source.refuel)
    }
  }
  
  override func prepare(for segue:UIStoryboardSegue, sender:Any?) {
    if segue.identifier == "ShowRefuelDetail" {
      let destination = segue.destination as! RefuelDetailViewController
      destination.refuel = selectedRefuel!
    }
  }
  
  // TableViewDataSource interface
  
  override func numberOfSections(in tableView: UITableView) -> NSInteger {
    return 1;
  }
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return refuels.count;
  }
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "RefuelCellIdentifier", for: indexPath) 
    
    let refuel = refuels[indexPath.row]
    var text = ""
    if let date = refuel.createdDate {
      text = formatters.dateFormatter.string(from: date)
    } else {
      text = "Unknown Date"
    }
    (cell.viewWithTag(3000) as! UILabel).text = text
    
    let odometerLabel = cell.viewWithTag(3001) as! UILabel
    var odometerValue = ""
    if indexPath.row > 0 && indexPath.row - 1 < milesPerTrip.count {
      let miles = formatters.numberFormatter.string(from: NSNumber(value: milesPerTrip[indexPath.row - 1]))!
      odometerValue = "\(miles) miles"
    }

    var mpgValue = ""
    if (refuels.count - indexPath.row - 1) < mpgs.count {
      mpgValue = "\(mpgs[refuels.count - indexPath.row - 1]) mpg"
    }
    odometerLabel.text = compact([odometerValue, mpgValue]).joined(separator: ", ")
    odometerLabel.accessibilityValue = odometerValue
    
    (cell.viewWithTag(3002) as! UILabel).text = formatters.currencyFormatter.string(from: NSNumber(value: refuel.pricePerGallon!))
    let total = refuel.totalSpent()
    (cell.viewWithTag(3004) as! UILabel).text = formatters.currencyFormatter.string(from: NSNumber(value: total))

    return cell
  }
  override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    return true
  }
  override func tableView(_ tableView: UITableView, commit editingStyle:UITableViewCellEditingStyle, forRowAt indexPath:IndexPath) {
    if editingStyle == UITableViewCellEditingStyle.delete {
      let refuel = refuels[indexPath.row]
      refuels = refuels.filter({ $0.id as! NSManagedObjectID != refuel.id as! NSManagedObjectID })
      tableView.deleteRows(at: [indexPath], with:UITableViewRowAnimation.fade)
      refuelStore.delete(refuel)
    } else {
      print("Unhandled editing style: ", editingStyle);
    }
  }
  
  // TableViewDelegate protocol
  
  override func tableView(_ tableView:UITableView, didSelectRowAt indexPath:IndexPath) {
    selectedRefuel = refuels[indexPath.row]
    performSegue(withIdentifier: "ShowRefuelDetail", sender: self)
  }
}
