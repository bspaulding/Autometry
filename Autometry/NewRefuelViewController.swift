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
        let destination = segue.destinationViewController as! RefuellingStationsListViewController
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
    return count(odometerField.text) > 0 && count(pricePerGallonField.text) > 0 && count(gallonsField.text) > 0
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
    NSNotificationCenter.defaultCenter().removeObserver(self, name:UITextFieldTextDidChangeNotification, object:textField)
  }
  
  func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
    if textField == odometerField || textField == octaneField {
      return true
    }
    
    // get current cursor position
    let selectedRange : UITextRange = textField.selectedTextRange!
    let start : UITextPosition = textField.beginningOfDocument
    let cursorOffset : NSInteger = textField.offsetFromPosition(start, toPosition: selectedRange.start)

    // Update the string in the text input
    let currentString : NSMutableString = NSMutableString(string: textField.text)
    let currentLength = currentString.length
    currentString.replaceCharactersInRange(range, withString: string)

    // Strip out the decimal separator
    let decimalSeparator = formatters.numberFormatter.decimalSeparator!
    currentString.replaceOccurrencesOfString(
      decimalSeparator,
      withString: "",
      options: NSStringCompareOptions.LiteralSearch,
      range: NSMakeRange(0, currentString.length)
    )

    // Generate a new string for the text input
    let currentValue = Double(currentString.intValue)
    let maximumFractionDigits = formatters.numberFormatter.maximumFractionDigits
    let format = NSString(format:"%%.%df", maximumFractionDigits)
    let minorUnitsPerMajor = pow(10.0, Double(maximumFractionDigits))
    let newString = NSString(format:format, (currentValue / minorUnitsPerMajor)).stringByReplacingOccurrencesOfString(".", withString:decimalSeparator)

    textField.text = newString
    // if the cursor was not at the end of the string being entered, restore cursor position
    if cursorOffset != currentLength {
      let lengthDelta = count(newString) - currentLength
      let newCursorOffset = max(0, min(count(newString), cursorOffset + lengthDelta))
      let newPosition = textField.positionFromPosition(textField.beginningOfDocument, offset:newCursorOffset)
      let newRange = textField.textRangeFromPosition(newPosition, toPosition:newPosition)
      textField.selectedTextRange = newRange
    }

    return false
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