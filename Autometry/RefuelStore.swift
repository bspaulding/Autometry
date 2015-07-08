import Foundation
import CoreData

class RefuelStore : CoreDataStore {
  let entityName = "Refuel"
    
  private var unwrap : (NSManagedObject) -> (Refuel) = {object in
    let refuel = Refuel(
      id: object.objectID,
      odometer: object.valueForKey("odometer") as! Int,
      pricePerGallon: object.valueForKey("pricePerGallon") as! Float,
      gallons: object.valueForKey("gallons") as! Float,
      octane: object.valueForKey("octane") as? Int,
      createdDate: object.valueForKey("date") as? NSDate,
      partial: object.valueForKey("partial") as? Bool
    )
    
    if let googlePlaceID = (object.valueForKey("google_place_id") as? String) {
      let station = RefuellingStation(
        name: object.valueForKey("stationName") as! String,
        googlePlaceID: googlePlaceID,
        latitude: object.valueForKey("latitude") as! Double,
        longitude: object.valueForKey("longitude") as! Double
      )
      refuel.station = station
    }
    
    print("refuel.partial: \(refuel.partial)")
    return refuel
  }
  
  private override init() {
    super.init()
    
    storeName = "RefuelStore"
    storeFilename = "RefuelStore.sqlite"
  }
  
  func all() -> [Refuel]{
    let request = NSFetchRequest(entityName: entityName)
    var error : NSError?
    if let context = managedObjectContext {
      let fetchResult = context.executeFetchRequest(request, error: &error) as! [NSManagedObject]?
      
      if let results = fetchResult {
        return results.map(unwrap)
      } else {
        println("Could not fetch \(error), \(error!.userInfo)")
      }
    } else {
      println("No context to fetch from");
    }
    
    return [];
  }
  
  func create(refuel:Refuel) {
    let context = managedObjectContext!
    let entity = NSEntityDescription.entityForName(entityName, inManagedObjectContext:context)
    
    let object = NSManagedObject(entity: entity!, insertIntoManagedObjectContext:context)
    let createdDate = NSDate()
    object.setValue(createdDate, forKey: "date")
    object.setValue(refuel.odometer, forKey: "odometer")
    object.setValue(refuel.pricePerGallon, forKey: "pricePerGallon")
    object.setValue(refuel.gallons, forKey: "gallons")
    object.setValue(refuel.octane, forKey: "octane")
    object.setValue(refuel.partial, forKey: "partial")
    if let station = refuel.station {
      object.setValue(station.googlePlaceID, forKey: "google_place_id")
      object.setValue(station.latitude, forKey:"latitude")
      object.setValue(station.longitude, forKey:"longitude")
      object.setValue(station.name, forKey:"stationName")
    }

    saveContext(context, success: {
      refuel.id = object.objectID
      refuel.createdDate = createdDate
      self.emitChange()
    }, failure: { error in
      println("create failed")
    })
  }
  
  func delete(refuel:Refuel) {
    if let objectID = refuel.id as? NSManagedObjectID {
      let context = managedObjectContext!
      let object = context.objectWithID(objectID)
      context.deleteObject(object)
      saveContext(context, success: {
        self.emitChange()
      },failure: { error in
        println("delete failed")
      })
    }
  }
  
  // Singleton Pattern
  
  class var sharedInstance: RefuelStore {
    struct Static {
      static var instance: RefuelStore?
      static var token: dispatch_once_t = 0
    }
    
    dispatch_once(&Static.token) {
      Static.instance = RefuelStore()
    }
    
    return Static.instance!
  }
}
