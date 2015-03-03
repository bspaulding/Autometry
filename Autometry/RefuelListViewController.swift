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
  let refuelStore = RefuelStore()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    refuels = refuelStore.all()
  }
  
  @IBAction func cancel(segue: UIStoryboardSegue) {
  }
  
  @IBAction func save(segue: UIStoryboardSegue) {
    let source = segue.sourceViewController as NewRefuelViewController
    refuels.append(source.refuel)
    refuelStore.create(source.refuel)
    self.tableView.reloadData()
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
    
    let refuel = refuels[indexPath.row];
    cell.textLabel!.text = String(refuel.odometer!);

    return cell;
  }
}