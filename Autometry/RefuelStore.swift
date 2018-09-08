import Foundation
import CoreData

class RefuelStore : CoreDataStore {
  static let sharedInstance = RefuelStore()
  let entityName = "Refuel"
  
  static let createdDateSorter : (Refuel,Refuel) -> Bool = {(a,b) in
    switch (a.createdDate,b.createdDate) {
    case let (.some(aDate), .some(bDate)):
      return aDate.timeIntervalSinceNow > bDate.timeIntervalSinceNow
    case (.none, .some(_)):
      return false
    case (.some(_), .none):
      return true
    case (.none, .none):
      return false
    }
  }
  
  fileprivate var unwrap : (NSManagedObject) -> (Refuel) = {object in
    let refuel = Refuel(
      id: object.objectID,
      odometer: object.value(forKey: "odometer") as! Int,
      pricePerGallon: (object.value(forKey: "pricePerGallon") as! NSNumber).floatValue,
      gallons: (object.value(forKey: "gallons") as! NSNumber).floatValue,
      octane: object.value(forKey: "octane") as? Int,
      createdDate: object.value(forKey: "date") as? Date,
      partial: object.value(forKey: "partial") as? Bool
    )
    
    if let googlePlaceID = (object.value(forKey: "google_place_id") as? String) {
      let station = RefuellingStation(
        name: object.value(forKey: "stationName") as! String,
        googlePlaceID: googlePlaceID,
        latitude: object.value(forKey: "latitude") as! Double,
        longitude: object.value(forKey: "longitude") as! Double
      )
      refuel.station = station
    }
    
    return refuel
  }
  
  fileprivate var wrap : (Refuel, NSManagedObject) -> Void = {refuel, object in
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
  }
  
  fileprivate override init() {
    super.init()
    
    storeName = "RefuelStore"
    storeFilename = "RefuelStore.sqlite"
  }
  
  func all() -> [Refuel] {
    let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
    if let context = managedObjectContext {
      do {
        let results = try context.fetch(request) as! [NSManagedObject]
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
  
  func create(_ refuel:Refuel) {
    let context = managedObjectContext!
    let entity = NSEntityDescription.entity(forEntityName: entityName, in:context)
    
    let object = NSManagedObject(entity: entity!, insertInto:context)
    let createdDate = Date()
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
  
  func update(_ refuel:Refuel) {
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
  
  func delete(_ refuel:Refuel) {
    if let objectID = refuel.id as? NSManagedObjectID {
      let context = managedObjectContext!
      let object = context.object(with: objectID)
      context.delete(object)
      saveContext(context, success: {
        self.emitChange()
      },failure: { error in
        print("delete failed")
      })
    }
  }
  
  // Private Methods
  
  fileprivate func findObject(_ refuel:Refuel) -> NSManagedObject? {
    let context = managedObjectContext!
    do {
      return try context.existingObject(with: refuel.id as! NSManagedObjectID)
    } catch {
      print("Uncaught exception")
      return nil
    }
  }
}
