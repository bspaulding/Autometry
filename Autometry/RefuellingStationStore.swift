import Foundation

class RefuellingStationStore : Observable {
  private var currentRefuellingStation : RefuellingStation?
  
  override private init() {}
    
  func getCurrentRefuellingStation() -> RefuellingStation? {
    return self.currentRefuellingStation
  }
  func setCurrentRefuellingStation(station:RefuellingStation) {
    self.currentRefuellingStation = station
    emitChange()
  }
  
  func nearby(latitude:Double, longitude:Double, callback:([RefuellingStation]) -> ()) {
    GoogleMapsAPI.gasStationsNearby(latitude, longitude:longitude, callback:{(data) in
      let results = data!.valueForKey("results") as! [NSDictionary]
      callback(results.map({ (var result) -> RefuellingStation in
        let geometry = result.valueForKey("geometry") as! NSDictionary
        let location = geometry.valueForKey("location") as! NSDictionary
        
        return RefuellingStation(
          name: result.valueForKey("name") as! String,
          googlePlaceID: result.valueForKey("place_id") as! String,
          latitude: location.valueForKey("lat") as! Double,
          longitude: location.valueForKey("lng") as! Double
        )
      }))
    })
  }
  
  // Singleton Pattern
  
  class var sharedInstance: RefuellingStationStore {
    struct Static {
      static var instance: RefuellingStationStore?
      static var token: dispatch_once_t = 0
    }
    
    dispatch_once(&Static.token) {
      Static.instance = RefuellingStationStore()
    }
    
    return Static.instance!
  }
}
