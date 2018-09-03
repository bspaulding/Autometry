import Foundation
import UIKit
import CoreLocation

class RefuelDetailViewController : UITableViewController, UITextFieldDelegate, CLLocationManagerDelegate {
  @IBOutlet weak var odometerField: UITextField!
  @IBOutlet weak var pricePerGallonField: UITextField!
  @IBOutlet weak var gallonsField: UITextField!
  @IBOutlet weak var saveButton: UIBarButtonItem!
  @IBOutlet weak var locationActivityIndicator: UIActivityIndicatorView!
  @IBOutlet weak var locationDescriptionField: UITextField!
  @IBOutlet weak var octaneField: UITextField!
  @IBOutlet weak var totalField: UITextField!
  @IBOutlet weak var partialSwitch: UISwitch! /* On = Full = false, Off = Partial = true */
  @IBOutlet weak var adCellContentView: UIView!
  
  let keyboardNavigationView = KeyboardNavigationView()
  
  var refuel = Refuel()
  let locationManager = CLLocationManager()
  let refuellingStationStore = RefuellingStationStore.sharedInstance
  var refuellingStations : [RefuellingStation] = []
  
  var currencyFormatter = NumberFormatter()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    keyboardNavigationView.tintColor = UIColor.white
    keyboardNavigationView.barTintColor = UIColor(red: 231.0/255.0, green: 76.0/255.0, blue: 60.0/255.0, alpha: 1.0)
    let totalIndexPath = IndexPath(row:3, section:3)
    keyboardNavigationView.onPrevious = {
      if let responder = self.previousField() {
        responder.becomeFirstResponder()
        if responder == self.gallonsField {
          self.tableView.scrollToRow(at: totalIndexPath, at:UITableViewScrollPosition.top, animated:true)
        } else if responder == self.odometerField {
          self.tableView.scrollRectToVisible(CGRect(x: 0, y: 0, width: 1, height: 1), animated:true)
        }
      }
    }
    keyboardNavigationView.onNext = {
      if let responder = self.nextField() {
        responder.becomeFirstResponder()
        if responder == self.octaneField {
          self.tableView.scrollToRow(at: totalIndexPath, at:UITableViewScrollPosition.top, animated:true)
        } else if responder == self.odometerField {
          self.tableView.scrollRectToVisible(CGRect(x: 0, y: 0, width: 1, height: 1), animated:true)
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
    
    currencyFormatter.numberStyle = .currency
    
    update()
  }
  
  func update() {
    if let _ = refuel.id {
      navigationItem.title = "Edit Refuel"
    }
    
    if let odometer = refuel.odometer {
      odometerField.text = formatters.numberFormatter.string(from: NSNumber(value: odometer))
    }
    
    if let station = refuel.station {
      locationDescriptionField.text = station.name
    } else {
      locationDescriptionField.text = ""
    }
    
    if refuel.isPartial() {
      partialSwitch.setOn(!refuel.isPartial(), animated: false)
    }
    
    if let octane = refuel.octane {
      octaneField.text = formatters.numberFormatter.string(from: NSNumber(value: octane))
    }
    
    if let pricePerGallon = refuel.pricePerGallon {
      pricePerGallonField.text = formatters.numberFormatter.string(from: NSNumber(value: pricePerGallon))
    }
    
    if let gallons = refuel.gallons {
      gallonsField.text = formatters.numberFormatter.string(from: NSNumber(value: gallons))
    }
    
    totalField.text = formatters.currencyFormatter.string(from: NSNumber(value: refuel.totalSpent()))

    saveButton.isEnabled = canSave()
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender:Any?) {
    switch segue.identifier {
      case .some("RefuellingStationSelection"):
        let destination = segue.destination as! RefuellingStationsListViewController
        destination.setStations(refuellingStations)
        destination.stationStore = refuellingStationStore
      default:
        refuel.odometer = Int(digitize(odometerField.text!))
        refuel.pricePerGallon = (pricePerGallonField.text! as NSString).floatValue
        refuel.gallons = (gallonsField.text! as NSString).floatValue
        refuel.station = refuellingStationStore.getCurrentRefuellingStation()
        refuel.octane = Int(octaneField.text!)
        refuel.partial = !partialSwitch.isOn
    }
  }
  
  func canSave() -> Bool {
    return odometerField.text!.count > 0 && pricePerGallonField.text!.count > 0 && gallonsField.text!.count > 0
  }
  
  func currentResponder() -> UITextField? {
    let responders = [octaneField, odometerField, pricePerGallonField, gallonsField].filter({ $0.isFirstResponder })
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
    return currencyFormatter.string(from: NSNumber(value: total))!
  }
  
  @objc func textChanged() {
    saveButton.isEnabled = canSave()
    totalField.text = total()
  }
  
  func updateRefuellingStations(_ stations:[RefuellingStation]) {
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

  func textFieldDidBeginEditing(_ textField: UITextField) {
    textField.inputAccessoryView = keyboardNavigationView
    NotificationCenter.default.addObserver(self, selector:#selector(RefuelDetailViewController.textChanged), name:NSNotification.Name.UITextFieldTextDidChange, object:textField)
  }
  
  func textFieldDidEndEditing(_ textField: UITextField) {
    NotificationCenter.default.removeObserver(self, name:NSNotification.Name.UITextFieldTextDidChange, object:textField)
  }
  
  func isDigit(_ character : Character) -> Bool {
    let s = String(character).unicodeScalars
    let uni = s[s.startIndex]
    
    let digits = CharacterSet.decimalDigits
    let isADigit = digits.contains(UnicodeScalar(uni.value)!)

    return isADigit
  }
  
  func digitize(_ string:String) -> String {
    var currentString = ""
    for character in string {
      if isDigit(character) {
        currentString.append(character)
      }
    }
    return currentString
  }
  
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    if textField == octaneField {
      return true
    }
    
    if textField == odometerField {
      let currentStringWithSeparators : NSMutableString = NSMutableString(string: textField.text!)
      currentStringWithSeparators.replaceCharacters(in: range, with: string)
      let currentString = digitize(currentStringWithSeparators as String)
      
      let fmt = formatters.numberFormatter
      if let number = fmt.number(from: currentString) {
        textField.text = fmt.string(from: number)!
        textChanged()
        return false
      } else {
        print("Parsing failed: \(textField.text!)")
        return true
      }
    }
    
    // get current cursor position
    let selectedRange : UITextRange = textField.selectedTextRange!
    let start : UITextPosition = textField.beginningOfDocument
    let cursorOffset : NSInteger = textField.offset(from: start, to: selectedRange.start)

    // Update the string in the text input
    let currentString : NSMutableString = NSMutableString(string: textField.text!)
    let currentLength = currentString.length
    currentString.replaceCharacters(in: range, with: string)

    // Strip out the decimal separator
    let decimalSeparator = formatters.numberFormatter.decimalSeparator!
    currentString.replaceOccurrences(
      of: decimalSeparator,
      with: "",
      options: NSString.CompareOptions.literal,
      range: NSMakeRange(0, currentString.length)
    )

    // Generate a new string for the text input
    let currentValue = Double(currentString.intValue)
    let maximumFractionDigits = formatters.numberFormatter.maximumFractionDigits
    let format = NSString(format:"%%.%df", maximumFractionDigits)
    let minorUnitsPerMajor = pow(10.0, Double(maximumFractionDigits))
    let newString = NSString(format:format, (currentValue / minorUnitsPerMajor)).replacingOccurrences(of: ".", with:decimalSeparator)

    textField.text = newString
    textChanged()
    
    // if the cursor was not at the end of the string being entered, restore cursor position
    if cursorOffset != currentLength {
      let lengthDelta = newString.count - currentLength
      let newCursorOffset = max(0, min(newString.count, cursorOffset + lengthDelta))
      let newPosition = textField.position(from: textField.beginningOfDocument, offset:newCursorOffset)!
      let newRange = textField.textRange(from: newPosition, to:newPosition)
      textField.selectedTextRange = newRange
    }

    return false
  }
  
  // CLLocationManagerDelegate Protocol
  
  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    switch status {
    case .notDetermined:
      manager.requestWhenInUseAuthorization()
    case .restricted:
      locationActivityIndicator.stopAnimating()
    case .denied:
      locationActivityIndicator.stopAnimating()
    case .authorizedAlways, .authorizedWhenInUse:
      manager.startUpdatingLocation()
    }
  }
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    let coordinate = locations[0].coordinate
    refuellingStationStore.nearby(coordinate.latitude, longitude: coordinate.longitude, callback:{stations in
      self.updateRefuellingStations(stations)
    })
    manager.stopUpdatingLocation()
  }
  
  func locationManager(_ manager:CLLocationManager, didFailWithError error:Error) {
    print("didFailWithError: ", error)
    locationActivityIndicator.stopAnimating()
  }
  
  func restoringFirstResponder(_ callback:()->()) {
    let _currentResponder = currentResponder()
    
    callback()
    
    if let responder = _currentResponder {
      responder.becomeFirstResponder()
    }
  }
}
