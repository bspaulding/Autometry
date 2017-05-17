import Foundation
import Alamofire

class GoogleMapsAPI {
  fileprivate class var apiKey : String {
    return "AIzaSyCwOkPKuzciYQeHo3ICajljmmf6uFMBcOk"
  }
  
  class func gasStationsNearby(_ latitude:Double, longitude:Double, callback:@escaping ([String: Any?]) -> ()) {
    let url = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?key=\(GoogleMapsAPI.apiKey)&type=gas_station&rankby=distance&location=\(latitude),\(longitude)"
    Alamofire.request(url).responseJSON {response in
      if let json = response.result.value {
        callback(json as! [String: Any?])
      } else {
        callback([:])
      }
    }
  }
}
