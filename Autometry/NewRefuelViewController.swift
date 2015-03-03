//
//  NewRefuelViewController.swift
//  Autometry
//
//  Created by Bradley Spaulding on 3/2/15.
//  Copyright (c) 2015 Motingo. All rights reserved.
//

import Foundation
import UIKit

class NewRefuelViewController : UITableViewController {
  @IBOutlet weak var odometerField: UITextField!
  @IBOutlet weak var pricePerGallonField: UITextField!
  @IBOutlet weak var gallonsField: UITextField!
  
  let refuel = Refuel()
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender:AnyObject?) {
    refuel.odometer = odometerField.text.toInt()
    refuel.pricePerGallon = (pricePerGallonField.text as NSString).floatValue
    refuel.gallons = gallonsField.text.toInt()
  }
}