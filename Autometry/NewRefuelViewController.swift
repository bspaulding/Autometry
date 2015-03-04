//
//  NewRefuelViewController.swift
//  Autometry
//
//  Created by Bradley Spaulding on 3/2/15.
//  Copyright (c) 2015 Motingo. All rights reserved.
//

import Foundation
import UIKit

class NewRefuelViewController : UITableViewController, UITextFieldDelegate {
  @IBOutlet weak var odometerField: UITextField!
  @IBOutlet weak var pricePerGallonField: UITextField!
  @IBOutlet weak var gallonsField: UITextField!
  @IBOutlet weak var saveButton: UIBarButtonItem!
  
  let refuel = Refuel()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    odometerField.delegate = self
    pricePerGallonField.delegate = self
    gallonsField.delegate = self
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender:AnyObject?) {
    refuel.odometer = odometerField.text.toInt()
    refuel.pricePerGallon = (pricePerGallonField.text as NSString).floatValue
    refuel.gallons = (gallonsField.text as NSString).floatValue
  }
  
  func canSave() -> Bool {
    return countElements(odometerField.text) > 0 && countElements(pricePerGallonField.text) > 0 && countElements(gallonsField.text) > 0
  }
  
  func textChanged() {
    saveButton.enabled = canSave()
  }
  
  // UITextFieldDelegate Protocol
  
  func textFieldDidBeginEditing(textField: UITextField) {
    NSNotificationCenter.defaultCenter().addObserver(self, selector:"textChanged", name:UITextFieldTextDidChangeNotification, object:textField)
  }
  
  func textFieldDidEndEditing(textField: UITextField) {
    NSNotificationCenter.defaultCenter()
  }
}