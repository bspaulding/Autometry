import Foundation
import XCTest
import Autometry

class DashboardTests: XCTestCase {
  func testMpg() {
    let dashboard = Dashboard()
    let refuelA = Refuel()
    refuelA.odometer = 10000
    refuelA.gallons = 10
    let refuelB = Refuel()
    refuelB.odometer = 10300
    refuelB.gallons = 10
    
    XCTAssertEqual(dashboard.mpg([refuelB, refuelA]), "30")
  }
}