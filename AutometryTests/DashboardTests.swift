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
  let refuelF = Refuel()
  let refuelG = Refuel()
  let refuelH = Refuel()

  var refuelsA : [Refuel] = []
  var refuelsB : [Refuel] = []
  var refuelsC : [Refuel] = []
  var refuelsD : [Refuel] = []
  
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
    
    refuelF.odometer = 10350
    refuelF.gallons = 2.5
    refuelF.pricePerGallon = 3.999
    refuelF.partial = true
    
    refuelG.odometer = 10600
    refuelG.gallons = 10
    refuelG.pricePerGallon = 3.999

    refuelH.odometer = 10400
    refuelH.gallons = 2.5
    refuelH.pricePerGallon = 3.999
    refuelH.partial = true
    
    refuelsA = [refuelC, refuelB, refuelA]
    refuelsB = [refuelE, refuelD, refuelC, refuelB, refuelA]
    refuelsC = [refuelG, refuelC, refuelF, refuelB, refuelA]
    refuelsD = [refuelG, refuelC, refuelH, refuelF, refuelB, refuelA]
    
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
  
  func testPricePerGallon() {
    XCTAssertEqual(dashboard.averagePPG([]), "N/A")
    XCTAssertEqual(dashboard.averagePPG(refuelsA), "$3.29")
    XCTAssertEqual(dashboard.pricePerGallonBest(refuelsA), "$2.90")
    XCTAssertEqual(dashboard.pricePerGallonWorst(refuelsA), "$3.50")

    XCTAssertEqual(dashboard.averagePPG(refuelsB), "$3.39")
    XCTAssertEqual(dashboard.pricePerGallonBest(refuelsB), "$2.40")
    XCTAssertEqual(dashboard.pricePerGallonWorst(refuelsB), "$4.70")
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
    XCTAssertEqual(dashboard.costPerMile([]), "$0.00")
    XCTAssertEqual(dashboard.costPerMile(refuelsA), "$0.14")
    XCTAssertEqual(dashboard.costPerMile(refuelsB), "$0.21")
    
    XCTAssertEqual(dashboard.costPerMileBest(refuelsA), "$0.12")
    XCTAssertEqual(dashboard.costPerMileBest(refuelsB), "$0.07")

    XCTAssertEqual(dashboard.costPerMileWorst(refuelsA), "$0.17")
    XCTAssertEqual(dashboard.costPerMileWorst(refuelsB), "$0.48")
  }
  
  func testMilesPerTrip() {
    let milesPerTripA = dashboard.milesPerTrip(refuelsA)

    XCTAssertEqual(milesPerTripA.count, 2)
    XCTAssertEqual(milesPerTripA[0], 200)
    XCTAssertEqual(milesPerTripA[1], 300)

    let milesPerTripB = dashboard.milesPerTrip(refuelsB)
    
    XCTAssertEqual(milesPerTripB.count, 4)
    XCTAssertEqual(milesPerTripB[0], 50)
    XCTAssertEqual(milesPerTripB[1], 400)
    XCTAssertEqual(milesPerTripB[2], 200)
    XCTAssertEqual(milesPerTripB[3], 300)
  }
  
  func testMpgs() {
    let mpgsA = dashboard.mpgs(refuelsA)
    
    XCTAssertEqual(mpgsA.count, refuelsA.count - 1)
    XCTAssertEqual(mpgsA[0], 20)
    XCTAssertEqual(mpgsA[1], 30)
    
    let mpgsB = dashboard.mpgs(refuelsB)
    
    XCTAssertEqual(mpgsB.count, refuelsB.count - 1)
    XCTAssertEqual(mpgsB[0], 5)
    XCTAssertEqual(mpgsB[1], 40)
    XCTAssertEqual(mpgsB[2], 20)
    XCTAssertEqual(mpgsB[3], 30)
    
    let refuel1 = Refuel()
    refuel1.odometer = 10000
    refuel1.gallons = 10
    let refuel2 = Refuel()
    refuel2.odometer = 10300
    refuel2.gallons = 15

    let refuelsC = [refuel2, refuel1]
    let mpgsC = dashboard.mpgs(refuelsC)
    
    XCTAssertEqual(mpgsC.count, refuelsC.count - 1)
    XCTAssertEqual(mpgsC[0], 20)
  }
  
  func testMpgsWithPartialInside() {
    let mpgs = dashboard.mpgs(refuelsC)
    
    // 10600, 10500, 10350 (partial), 10300, 10000
    XCTAssertEqual(refuelsC.count, 5)
    XCTAssertEqual(mpgs.count, refuelsC.count - 1)
    XCTAssertEqual(mpgs[0], 10)
    XCTAssertEqual(mpgs[1], 16)
    XCTAssertEqual(mpgs[2], 16)
    XCTAssertEqual(mpgs[3], 30)
  }
  
  func testMpgsWithPartialNewest() {
    let refuels = [refuelF, refuelB, refuelA]
    let mpgs = dashboard.mpgs(refuels)
    
    // 10350 (partial), 10300, 10000
    XCTAssertEqual(refuels.count, 3)
    XCTAssertEqual(mpgs.count, 1)
    XCTAssertEqual(mpgs[0], 30)
  }
  
  func testMpgsWithPartialOldest() {
    let refuels = [refuelC, refuelF]
    let mpgs = dashboard.mpgs(refuels)
    
    // 10500, 10350 (partial)
    XCTAssertEqual(refuels.count, 2)
    XCTAssertEqual(mpgs.count, 1)
    XCTAssertEqual(mpgs[0], 15)
  }
  
  func testMpgsWithMultiPartials() {
    let mpgs = dashboard.mpgs(refuelsD)
    
    XCTAssertEqual(refuelsD.count, 6)
    XCTAssertEqual(mpgs.count, refuelsD.count - 1)
    XCTAssertEqual(mpgs[0], 10)
    XCTAssertEqual(mpgs[1], 13)
    XCTAssertEqual(mpgs[2], 13)
    XCTAssertEqual(mpgs[3], 13)
    XCTAssertEqual(mpgs[4], 30)
  }
}