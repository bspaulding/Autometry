//
//  RefuelList.swift
//  Autometry
//
//  Created by Bradley Spaulding on 3/2/15.
//  Copyright (c) 2015 Motingo. All rights reserved.
//

import Foundation
import UIKit

class RefuelListViewController : UITableViewController {
  var refuels : [Refuel] = []
  let refuelStore = RefuelStore.sharedInstance
  let dateFormatter = NSDateFormatter()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
    
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
    (cell.viewWithTag(3001) as UILabel).text = "\(refuel.odometer!) miles"

    return cell
  }
}