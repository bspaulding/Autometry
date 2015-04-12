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
    
    let refuelC = Refuel()
    refuelC.odometer = 10500
    refuelC.gallons = 10

    var refuels = [refuelC, refuelB, refuelA]
    
    XCTAssertEqual(dashboard.mpgAverage(refuels), "25")
    XCTAssertEqual(dashboard.mpgBest(refuels), "30")
    XCTAssertEqual(dashboard.mpgWorst(refuels), "20")
    
    let refuelD = Refuel()
    refuelD.odometer = 10900
    refuelD.gallons = 10
    
    let refuelE = Refuel()
    refuelE.odometer = 10950
    refuelE.gallons = 10
    
    refuels = [refuelE, refuelD, refuelC, refuelB, refuelA]
    
    XCTAssertEqual(dashboard.mpgAverage(refuels), "23")
    XCTAssertEqual(dashboard.mpgBest(refuels), "40")
    XCTAssertEqual(dashboard.mpgWorst(refuels), "5")
  }
}