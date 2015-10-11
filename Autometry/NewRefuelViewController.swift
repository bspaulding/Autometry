import Foundation
import UIKit
import CoreLocation
import iAd

class NewRefuelViewController : UITableViewController, UITextFieldDelegate, CLLocationManagerDelegate {
  @IBOutlet weak var odometerField: UITextField!
  @IBOutlet weak var pricePerGallonField: UITextField!
  @IBOutlet weak var gallonsField: UITextField!
  @IBOutlet weak var saveButton: UIBarButtonItem!
  @IBOutlet weak var locationActivityIndicator: UIActivityIndicatorView!
  @IBOutlet weak var locationDescriptionField: UITextField!
  @IBOutlet weak var octaneField: UITextField!
  @IBOutlet weak var totalField: UITextField!
  @IBOutlet weak var partialSwitch: UISwitch! /* On = Full = false, Off = Partial = true */
  
  let keyboardNavigationView = KeyboardNavigationView()
  
  let refuel = Refuel()
  let locationManager = CLLocationManager()
  let refuellingStationStore = RefuellingStationStore.sharedInstance
  var refuellingStations : [RefuellingStation] = []
  
  var currencyFormatter = NSNumberFormatter()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    keyboardNavigationView.tintColor = UIColor.whiteColor()
    keyboardNavigationView.barTintColor = UIColor(red: 231.0/255.0, green: 76.0/255.0, blue: 60.0/255.0, alpha: 1.0)
    let totalIndexPath = NSIndexPath(forRow:3, inSection:4)
    keyboardNavigationView.onPrevious = {
      if let responder = self.previousField() {
        responder.becomeFirstResponder()
        if responder == self.gallonsField {
          self.tableView.scrollToRowAtIndexPath(totalIndexPath, atScrollPosition:UITableViewScrollPosition.Top, animated:true)
        } else if responder == self.odometerField {
          self.tableView.scrollRectToVisible(CGRectMake(0, 0, 1, 1), animated:true)
        }
      }
    }
    keyboardNavigationView.onNext = {
      if let responder = self.nextField() {
        responder.becomeFirstResponder()
        if responder == self.octaneField {
          self.tableView.scrollToRowAtIndexPath(totalIndexPath, atScrollPosition:UITableViewScrollPosition.Top, animated:true)
        } else if responder == self.odometerField {
          self.tableView.scrollRectToVisible(CGRectMake(0, 0, 1, 1), animated:true)
        }
      }
    }
    
    odometerField.delegate = self
    odometerField.becomeFirstResponder()
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
      case .Some("RefuellingStationSelection"):
        let destination = segue.destinationViewController as! RefuellingStationsListViewController
        destination.setStations(refuellingStations)
        destination.stationStore = refuellingStationStore
      default:
        refuel.odometer = Int(digitize(odometerField.text!))
        refuel.pricePerGallon = (pricePerGallonField.text! as NSString).floatValue
        refuel.gallons = (gallonsField.text! as NSString).floatValue
        refuel.station = refuellingStationStore.getCurrentRefuellingStation()
        refuel.octane = Int(octaneField.text!)
        refuel.partial = !partialSwitch.on
    }
  }
  
  func canSave() -> Bool {
    return odometerField.text!.characters.count > 0 && pricePerGallonField.text!.characters.count > 0 && gallonsField.text!.characters.count > 0
  }
  
  func currentResponder() -> UITextField? {
    let responders = [octaneField, odometerField, pricePerGallonField, gallonsField].filter({ $0.isFirstResponder() })
    if responders.count > 0 {
      return responders[0]
    }
    
    return nil
  }
  
  func total() -> String {
    let ppgString = pricePerGallonField.text! as NSString
    let gallonsString = gallonsField.text! as NSString
    
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
  
  func nextField() -> UITextField? {
    switch currentResponder()! {
    case odometerField:
      return octaneField
    case octaneField:
      return pricePerGallonField
    case pricePerGallonField:
      return gallonsField
    case gallonsField:
      return odometerField
    default:
      print("Unknown current responder!")
      return nil
    }
  }
  
  func previousField() -> UITextField? {
    switch currentResponder()! {
    case odometerField:
      return gallonsField
    case octaneField:
      return odometerField
    case pricePerGallonField:
      return octaneField
    case gallonsField:
      return pricePerGallonField
    default:
      print("Unknown current responder!")
      return nil
    }
  }
  
  // UITextFieldDelegate Protocol

  func textFieldDidBeginEditing(textField: UITextField) {
    textField.inputAccessoryView = keyboardNavigationView
    NSNotificationCenter.defaultCenter().addObserver(self, selector:"textChanged", name:UITextFieldTextDidChangeNotification, object:textField)
  }
  
  func textFieldDidEndEditing(textField: UITextField) {
    NSNotificationCenter.defaultCenter().removeObserver(self, name:UITextFieldTextDidChangeNotification, object:textField)
  }
  
  func isDigit(character : Character) -> Bool {
    let s = String(character).unicodeScalars
    let uni = s[s.startIndex]
    
    let digits = NSCharacterSet.decimalDigitCharacterSet()
    let isADigit = digits.longCharacterIsMember(uni.value)

    return isADigit
  }
  
  func digitize(string:String) -> String {
    var currentString = ""
    for character in string.characters {
      if isDigit(character) {
        currentString.append(character)
      }
    }
    return currentString
  }
  
  func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
    if textField == octaneField {
      return true
    }
    
    if textField == odometerField {
      let currentStringWithSeparators : NSMutableString = NSMutableString(string: textField.text!)
      currentStringWithSeparators.replaceCharactersInRange(range, withString: string)
      let currentString = digitize(currentStringWithSeparators as String)
      
      let fmt = formatters.numberFormatter
      if let number = fmt.numberFromString(currentString) {
        textField.text = fmt.stringFromNumber(number)!
        textChanged()
        return false
      } else {
        print("Parsing failed: \(textField.text)")
        return true
      }
    }
    
    // get current cursor position
    let selectedRange : UITextRange = textField.selectedTextRange!
    let start : UITextPosition = textField.beginningOfDocument
    let cursorOffset : NSInteger = textField.offsetFromPosition(start, toPosition: selectedRange.start)

    // Update the string in the text input
    let currentString : NSMutableString = NSMutableString(string: textField.text!)
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
    textChanged()
    
    // if the cursor was not at the end of the string being entered, restore cursor position
    if cursorOffset != currentLength {
      let lengthDelta = newString.characters.count - currentLength
      let newCursorOffset = max(0, min(newString.characters.count, cursorOffset + lengthDelta))
      let newPosition = textField.positionFromPosition(textField.beginningOfDocument, offset:newCursorOffset)!
      let newRange = textField.textRangeFromPosition(newPosition, toPosition:newPosition)
      textField.selectedTextRange = newRange
    }

    return false
  }
  
  // CLLocationManagerDelegate Protocol
  
  func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
    switch status {
    case .NotDetermined:
      manager.requestWhenInUseAuthorization()
    case .Restricted:
      locationActivityIndicator.stopAnimating()
    case .Denied:
      locationActivityIndicator.stopAnimating()
    case .AuthorizedAlways, .AuthorizedWhenInUse:
      manager.startUpdatingLocation()
    }
  }
  
  func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    let coordinate = locations[0].coordinate
    refuellingStationStore.nearby(coordinate.latitude, longitude: coordinate.longitude, callback:{stations in
      self.updateRefuellingStations(stations)
    })
    manager.stopUpdatingLocation()
  }
  
  func locationManager(manager:CLLocationManager, didFailWithError error:NSError) {
    print("didFailWithError: ", error)
    locationActivityIndicator.stopAnimating()
  }
  
  // ADBannerView Delegate Protocol
  
  func restoringFirstResponder(callback:()->()) {
    let _currentResponder = currentResponder()
    
    callback()
    
    if let responder = _currentResponder {
      responder.becomeFirstResponder()
    }
 }
  
  var showAd = false
  
  func bannerViewDidLoadAd(banner: ADBannerView) {
    showAd = true
    restoringFirstResponder({
      self.tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation:UITableViewRowAnimation.Fade)
    })
  }
  
  func bannerView(banner:ADBannerView, didFailToReceiveAdWithError error:NSError) {
    showAd = false
    restoringFirstResponder({
      self.tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation:UITableViewRowAnimation.Fade)
    })
  }
  
  // TableView Delegate
  
  override func tableView(tableView:UITableView, numberOfRowsInSection section:NSInteger) -> NSInteger {
    if section == 0 && !showAd {
      return 0
    }
    
    return super.tableView(tableView, numberOfRowsInSection:section)
  }
  
  override func tableView(tableView:UITableView, heightForHeaderInSection section:NSInteger) -> CGFloat {
    if section == 0 && !showAd {
      return 1
    }
    
    return super.tableView(tableView, heightForHeaderInSection:section)
  }
}