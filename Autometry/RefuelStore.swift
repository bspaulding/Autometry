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
    
    return refuel
  }
  
  private var wrap : (Refuel, NSManagedObject) -> (NSManagedObject) = {refuel, object in
    if let odometer = refuel.odometer {
      object.setValue(odometer, forKey: "odometer")
    }
    if let pricePerGallon = refuel.pricePerGallon {
      object.setValue(pricePerGallon, forKey: "pricePerGallon")
    }
    if let gallons = refuel.gallons {
      object.setValue(gallons, forKey: "gallons")
    }
    if let octane = refuel.octane {
      object.setValue(octane, forKey: "octane")
    }
    if let partial = refuel.partial {
      object.setValue(partial, forKey: "partial")
    }
    if let station = refuel.station {
      object.setValue(station.name, forKey: "stationName")
      object.setValue(station.googlePlaceID, forKey: "google_place_id")
      object.setValue(station.latitude, forKey: "latitude")
      object.setValue(station.longitude, forKey: "longitude")
    }
    
    return object
  }
  
  private override init() {
    super.init()
    
    storeName = "RefuelStore"
    storeFilename = "RefuelStore.sqlite"
  }
  
  func all() -> [Refuel] {
    let request = NSFetchRequest(entityName: entityName)
    if let context = managedObjectContext {
      do {
        let results = try context.executeFetchRequest(request) as! [NSManagedObject]
        return results.map(unwrap)
      } catch {
        print("Could not fetch \(error)")
        return [];
      }
    } else {
      print("No context to fetch from");
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
      print("create failed")
    })
  }
  
  func update(refuel:Refuel) {
    if let object = findObject(refuel) {
      wrap(refuel, object)
      
      saveContext(managedObjectContext!,
        success: {
          self.emitChange()
        },
        failure: {error in
          print("update failed")
        }
      )
    } else {
      print("[RefuelStore#update] Tried to update a performance that hadn't been persisted yet.")
    }
  }
  
  func delete(refuel:Refuel) {
    if let objectID = refuel.id as? NSManagedObjectID {
      let context = managedObjectContext!
      let object = context.objectWithID(objectID)
      context.deleteObject(object)
      saveContext(context, success: {
        self.emitChange()
      },failure: { error in
        print("delete failed")
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
  
  // Private Methods
  
  private func findObject(refuel:Refuel) -> NSManagedObject? {
    let context = managedObjectContext!
    do {
      return try context.existingObjectWithID(refuel.id as! NSManagedObjectID)
    } catch {
      print("Uncaught exception")
      return nil
    }
  }
}
