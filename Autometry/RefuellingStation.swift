import Foundation

struct RefuellingStation : Equatable {
  var name : String = ""
  var googlePlaceID : String = ""
  let latitude : Double
  let longitude : Double
  
  init(name: String, googlePlaceID: String, latitude:Double, longitude:Double) {
    self.name = name
    self.googlePlaceID = googlePlaceID
    self.latitude = latitude
    self.longitude = longitude
  }
}

func ==(lhs:RefuellingStation, rhs:RefuellingStation) -> Bool {
  return lhs.googlePlaceID == rhs.googlePlaceID
}