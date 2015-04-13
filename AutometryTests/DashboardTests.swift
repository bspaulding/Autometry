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
    refuelA.pricePerGallon = 3.499
    
    refuelB.odometer = 10300
    refuelB.gallons = 10
    refuelB.pricePerGallon = 3.459
    
    refuelC.odometer = 10500
    refuelC.gallons = 10
    refuelC.pricePerGallon = 2.899

    refuelD.odometer = 10900
    refuelD.gallons = 10
    refuelD.pricePerGallon = 2.399
    
    refuelE.odometer = 10950
    refuelE.gallons = 10
    refuelE.pricePerGallon = 4.699
    
    refuelsA = [refuelC, refuelB, refuelA]
    refuelsB = [refuelE, refuelD, refuelC, refuelB, refuelA]
    
    super.setUp()
  }
  
  func testMpgAverage() {
    XCTAssertEqual(dashboard.mpgAverage(refuelsA), "25")
    XCTAssertEqual(dashboard.mpgBest(refuelsA), "30")
    XCTAssertEqual(dashboard.mpgWorst(refuelsA), "20")
    
    XCTAssertEqual(dashboard.mpgAverage(refuelsB), "23")
    XCTAssertEqual(dashboard.mpgBest(refuelsB), "40")
    XCTAssertEqual(dashboard.mpgWorst(refuelsB), "5")
  }
  
  func testTotalSpent() {
    XCTAssertEqual(dashboard.totalSpent(refuelsA), "$98.57")
    XCTAssertEqual(dashboard.totalSpent(refuelsB), "$169.55")
    
    XCTAssertEqual(dashboard.totalSpentBest(refuelsA), "$28.99")
    XCTAssertEqual(dashboard.totalSpentBest(refuelsB), "$23.99")

    XCTAssertEqual(dashboard.totalSpentWorst(refuelsA), "$34.99")
    XCTAssertEqual(dashboard.totalSpentWorst(refuelsB), "$46.99")
  }
  
  func testTotalMiles() {
    XCTAssertEqual(dashboard.totalMiles([refuelA]), "0")
    XCTAssertEqual(dashboard.totalMiles(refuelsA), "500")
    XCTAssertEqual(dashboard.totalMiles(refuelsB), "950")
    
    XCTAssertEqual(dashboard.totalMilesLongest([refuelA]), "0")
    XCTAssertEqual(dashboard.totalMilesLongest(refuelsA), "300")
    XCTAssertEqual(dashboard.totalMilesLongest(refuelsB), "400")
    
    XCTAssertEqual(dashboard.totalMilesShortest([refuelA]), "0")
    XCTAssertEqual(dashboard.totalMilesShortest(refuelsA), "200")
    XCTAssertEqual(dashboard.totalMilesShortest(refuelsB), "50")
  }
  
  func testCostPerMile() {
    XCTAssertEqual(dashboard.costPerMile(refuelsA), "$0.20")
    XCTAssertEqual(dashboard.costPerMile(refuelsB), "$0.18")
    
    XCTAssertEqual(dashboard.costPerMileBest(refuelsA), "$0.12")
    XCTAssertEqual(dashboard.costPerMileBest(refuelsB), "$0.07")

    XCTAssertEqual(dashboard.costPerMileWorst(refuelsA), "$0.17")
    XCTAssertEqual(dashboard.costPerMileWorst(refuelsB), "$0.48")
  }
}