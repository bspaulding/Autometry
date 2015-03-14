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
  @IBOutlet weak var octaneField: UITextField!
  @IBOutlet weak var totalField: UITextField!
  
  let refuel = Refuel()
  let locationManager = CLLocationManager()
  let refuellingStationStore = RefuellingStationStore.sharedInstance
  var refuellingStations : [RefuellingStation] = []
  
  var currencyFormatter = NSNumberFormatter()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    odometerField.delegate = self
    pricePerGallonField.delegate = self
    gallonsField.delegate = self
    octaneField.delegate = self
    
    locationManager.delegate = self
    locationManager.desiredAccuracy = kCLLocationAccuracyBest
    
    refuellingStationStore.register({
      self.locationDescriptionField.text = self.refuellingStationStore.getCurrentRefuellingStation()!.name
    })
    
    currencyFormatter.numberStyle = .CurrencyStyle
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender:AnyObject?) {
    switch segue.identifier {
      case let .Some("RefuellingStationSelection"):
        let destination = segue.destinationViewController as RefuellingStationsListViewController
        destination.setStations(refuellingStations)
        destination.stationStore = refuellingStationStore
      default:
        refuel.odometer = odometerField.text.toInt()
        refuel.pricePerGallon = (pricePerGallonField.text as NSString).floatValue
        refuel.gallons = (gallonsField.text as NSString).floatValue
        refuel.station = refuellingStationStore.getCurrentRefuellingStation()
        refuel.octane = octaneField.text.toInt()
    }
  }
  
  func canSave() -> Bool {
    return countElements(odometerField.text) > 0 && countElements(pricePerGallonField.text) > 0 && countElements(gallonsField.text) > 0
  }
  
  func total() -> String {
    let ppgString = pricePerGallonField.text as NSString
    let gallonsString = gallonsField.text as NSString
    
    if ppgString.length == 0 || gallonsString.length == 0 {
      return ""
    }
    
    let total = ppgString.floatValue * gallonsString.floatValue
    return currencyFormatter.stringFromNumber(total)!
  }
  
  func textChanged() {
    saveButton.enabled = canSave()
    totalField.text = total()
  }
  
  func updateRefuellingStations(stations:[RefuellingStation]) {
    refuellingStations = stations
    
    if (refuellingStations.count > 0) {
      locationActivityIndicator.stopAnimating()
      if refuellingStationStore.getCurrentRefuellingStation() == nil {
        refuellingStationStore.setCurrentRefuellingStation(refuellingStations[0])
      }
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
      locationActivityIndicator.stopAnimating()
    case .Denied:
      println("Denied")
      locationActivityIndicator.stopAnimating()
    case .AuthorizedAlways, .AuthorizedWhenInUse:
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
    locationActivityIndicator.stopAnimating()
  }
}