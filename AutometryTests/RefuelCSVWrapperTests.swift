import Foundation
import XCTest
import Autometry

class RefuelCSVWrapperTests: XCTestCase {
  func testHeader() {
    let header = RefuelCSVWrapper.header
    print(header)
    XCTAssertEqual(header, ["Date", "Odometer", "Price Per Gallon", "Gallons", "Octane", "Partial", "Location Name", "Latitude", "Longtidue", "Google Place ID"].joined(separator: ","))
  }
  
  func testBlank() {
    let csv = RefuelCSVWrapper.wrap(Refuel())
    XCTAssertEqual(csv, ",,,,,false,,,,", "Refuel with no data has empty cells")
  }
  
  func testCreatedDate() {
    let refuel = Refuel()
    if let date = DateHelpers.dateWithYear(2015, month:1, day:1, hour:3, minute: 24, tz:"PST") {
      refuel.createdDate = date
      let csv = RefuelCSVWrapper.wrap(refuel)
      XCTAssertEqual(csv, "2015-01-01T03:24-0800,,,,,false,,,,")
    } else {
      XCTAssert(false, "couldn't create new createdDate")
    }
  }
  
  func testOdometer() {
    let refuel = Refuel()
    refuel.odometer = 10000
    let csv = RefuelCSVWrapper.wrap(refuel)
    XCTAssertEqual(csv, ",10000,,,,false,,,,")
  }
  
  func testPricePerGallon() {
    let refuel = Refuel()
    refuel.pricePerGallon = 2.539
    let csv = RefuelCSVWrapper.wrap(refuel)
    XCTAssertEqual(csv, ",,$2.539,,,false,,,,")
  }
  
  func testGallons() {
    let refuel = Refuel()
    refuel.gallons = 11.2468
    let csv = RefuelCSVWrapper.wrap(refuel)
    XCTAssertEqual(csv, ",,,11.2468,,false,,,,")
  }
  
  func testOctane() {
    let refuel = Refuel()
    refuel.octane = 91
    let csv = RefuelCSVWrapper.wrap(refuel)
    XCTAssertEqual(csv, ",,,,91,false,,,,")
  }
  
  func testPartial() {
    let refuel = Refuel()
    var csv = RefuelCSVWrapper.wrap(refuel)
    XCTAssertEqual(csv, ",,,,,false,,,,") // undefined defaults to false

    refuel.partial = true
    csv = RefuelCSVWrapper.wrap(refuel)
    XCTAssertEqual(csv, ",,,,,true,,,,")
    
    refuel.partial = false
    csv = RefuelCSVWrapper.wrap(refuel)
    XCTAssertEqual(csv, ",,,,,false,,,,")
  }
  
  func testStation() {
    let refuel = Refuel()
    refuel.station = RefuellingStation(name: "Chevron", googlePlaceID: "GOOGLE_PLACE_ID", latitude:32.1245, longitude:-122.5436)
    let csv = RefuelCSVWrapper.wrap(refuel)
    XCTAssertEqual(csv, ",,,,,false,Chevron,32.1245,-122.5436,GOOGLE_PLACE_ID")
  }
  
  func testWrapAll() {
    let station = RefuellingStation(name: "Chevron", googlePlaceID: "GOOGLE_PLACE_ID", latitude:32.1245, longitude:-122.5436)
    let dateA = DateHelpers.dateWithYear(2015, month:1, day:1, hour:3, minute: 24, tz:"PST")!
    let refuelA = Refuel(id: "1" as AnyObject, odometer: 10000, pricePerGallon: 2.349, gallons: 10.9876, octane: 91, createdDate: dateA, partial: false)
    refuelA.station = station
    let dateB = DateHelpers.dateWithYear(2015, month:2, day:1, hour:3, minute: 24, tz:"PST")!
    let refuelB = Refuel(id: "2" as AnyObject, odometer: 10833, pricePerGallon: 2.749, gallons: 11.6789, octane: 91, createdDate: dateB, partial: true)
    refuelB.station = station
    let actual = RefuelCSVWrapper.wrapAll([refuelA, refuelB])
    let expected = [
      "Date,Odometer,Price Per Gallon,Gallons,Octane,Partial,Location Name,Latitude,Longtidue,Google Place ID",
      "2015-01-01T03:24-0800,10000,$2.349,10.9876,91,false,Chevron,32.1245,-122.5436,GOOGLE_PLACE_ID",
      "2015-02-01T03:24-0800,10833,$2.749,11.6789,91,true,Chevron,32.1245,-122.5436,GOOGLE_PLACE_ID"
    ].joined(separator: "\n")
    XCTAssertEqual(actual, expected)
  }
}
