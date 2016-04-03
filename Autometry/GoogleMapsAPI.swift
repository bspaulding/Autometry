import Foundation
import Alamofire

class GoogleMapsAPI {
  private class var apiKey : String {
    return "AIzaSyCwOkPKuzciYQeHo3ICajljmmf6uFMBcOk"
  }
  
  class func gasStationsNearby(latitude:Double, longitude:Double, callback:(AnyObject?) -> ()) {
    let url = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?key=\(GoogleMapsAPI.apiKey)&type=gas_station&rankby=distance&location=\(latitude),\(longitude)"
    Alamofire.request(.GET, url).responseJSON {response in
      if let json = response.result.value {
        callback(json)
      } else {
        callback([])
      }
    }
  }
}