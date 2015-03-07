import Foundation
import XCTest
import Autometry

class RefuelCSVWrapperTests: XCTestCase {
  override func setUp() {
    super.setUp()
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }
  
  func testCSVHeader() {
    let header = RefuelCSVWrapper.header
    println(header)
    XCTAssert(header == ",".join(["Date", "Odometer", "Price Per Gallon", "Gallons", "Octane", "Latitude", "Longtidue"]))
  }
  
  func testToCSV() {
    let csv = RefuelCSVWrapper.wrap(Refuel())
    XCTAssert(csv == ",,,,,,", "Refuel with no data has empty cells")
  }
}
