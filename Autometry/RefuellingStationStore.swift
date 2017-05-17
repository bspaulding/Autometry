import Foundation

class RefuellingStationStore : Observable {
  static let sharedInstance = RefuellingStationStore()
  fileprivate var currentRefuellingStation : RefuellingStation?
  
  override fileprivate init() {}
    
  func getCurrentRefuellingStation() -> RefuellingStation? {
    return self.currentRefuellingStation
  }
  func setCurrentRefuellingStation(_ station:RefuellingStation) {
    self.currentRefuellingStation = station
    emitChange()
  }
  
  func nearby(_ latitude:Double, longitude:Double, callback:@escaping ([RefuellingStation]) -> ()) {
    GoogleMapsAPI.gasStationsNearby(latitude, longitude:longitude, callback:{(data) in
      let results = data["results"] as! [NSDictionary]
      callback(results.map({ (result) -> RefuellingStation in
        let geometry = result.value(forKey: "geometry") as! NSDictionary
        let location = geometry.value(forKey: "location") as! NSDictionary
        
        return RefuellingStation(
          name: result.value(forKey: "name") as! String,
          googlePlaceID: result.value(forKey: "place_id") as! String,
          latitude: location.value(forKey: "lat") as! Double,
          longitude: location.value(forKey: "lng") as! Double
        )
      }))
    })
  }
}
