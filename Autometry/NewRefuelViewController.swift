//
//  NewRefuelViewController.swift
//  Autometry
//
//  Created by Bradley Spaulding on 3/2/15.
//  Copyright (c) 2015 Motingo. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

class NewRefuelViewController : UITableViewController, UITextFieldDelegate, CLLocationManagerDelegate {
  @IBOutlet weak var odometerField: UITextField!
  @IBOutlet weak var pricePerGallonField: UITextField!
  @IBOutlet weak var gallonsField: UITextField!
  @IBOutlet weak var saveButton: UIBarButtonItem!
  @IBOutlet weak var locationActivityIndicator: UIActivityIndicatorView!
  @IBOutlet weak var locationDescriptionField: UITextField!
  
  let refuel = Refuel()
  let locationManager = CLLocationManager()
  let refuellingStationStore = RefuellingStationStore()
  var refuellingStations : [RefuellingStation] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    odometerField.delegate = self
    pricePerGallonField.delegate = self
    gallonsField.delegate = self
    
    locationManager.delegate = self
    locationManager.desiredAccuracy = kCLLocationAccuracyBest
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
  
  func updateRefuellingStations(stations:[RefuellingStation]) {
    refuellingStations = stations
    if (refuellingStations.count > 0) {
      locationActivityIndicator.stopAnimating()
      locationDescriptionField.text = refuellingStations[0].name
    } else {
      locationActivityIndicator.startAnimating()
      locationDescriptionField.text = ""
    }
  }
  
  // UITextFieldDelegate Protocol
  
  func textFieldDidBeginEditing(textField: UITextField) {
    NSNotificationCenter.defaultCenter().addObserver(self, selector:"textChanged", name:UITextFieldTextDidChangeNotification, object:textField)
  }
  
  func textFieldDidEndEditing(textField: UITextField) {
    NSNotificationCenter.defaultCenter()
  }
  
  // CLLocationManagerDelegate Protocol
  
  func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
    println("authorization status changed")
    switch status {
    case .NotDetermined:
      println("NotDetermined")
      manager.requestWhenInUseAuthorization()
    case .Restricted:
      println("Restricted")
    case .Denied:
      println("Denied")
    case .Authorized, .AuthorizedWhenInUse:
      println("starting location updates")
      manager.startUpdatingLocation()
    default:
      println("unknown authorization status...")
    }
  }
  
  func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
    let coordinate = locations[0].coordinate
    refuellingStationStore.nearby(coordinate.latitude, longitude: coordinate.longitude, callback:{stations in
      self.updateRefuellingStations(stations)
    })
    locationManager.stopUpdatingLocation()
  }
  
  func locationManager(manager:CLLocationManager, didFailWithError error:NSError) {
    println("didFailWithError: ", error)
  }
}