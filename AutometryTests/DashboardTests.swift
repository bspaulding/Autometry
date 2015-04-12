import Foundation
import XCTest
import Autometry

class DashboardTests: XCTestCase {

  let dashboard = Dashboard()
  let refuelA = Refuel()
  let refuelB = Refuel()
  let refuelC = Refuel()
  let refuelD = Refuel()
  let refuelE = Refuel()

  var refuelsA : [Refuel] = []
  var refuelsB : [Refuel] = []
  
  override func setUp() {
    refuelA.odometer = 10000
    refuelA.gallons = 10
    
    refuelB.odometer = 10300
    refuelB.gallons = 10
    
    refuelC.odometer = 10500
    refuelC.gallons = 10

    refuelD.odometer = 10900
    refuelD.gallons = 10
    
    refuelE.odometer = 10950
    refuelE.gallons = 10
    
    refuelsA = [refuelC, refuelB, refuelA]
    refuelsB = [refuelE, refuelD, refuelC, refuelB, refuelA]
    
    super.setUp()
  }
  
  func testMpg() {
    XCTAssertEqual(dashboard.mpgAverage(refuelsA), "25")
    XCTAssertEqual(dashboard.mpgBest(refuelsA), "30")
    XCTAssertEqual(dashboard.mpgWorst(refuelsA), "20")
    
    XCTAssertEqual(dashboard.mpgAverage(refuelsB), "23")
    XCTAssertEqual(dashboard.mpgBest(refuelsB), "40")
    XCTAssertEqual(dashboard.mpgWorst(refuelsB), "5")
  }
}