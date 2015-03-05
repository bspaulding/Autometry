//
//  RefuelStore.swift
//  Autometry
//
//  Created by Bradley Spaulding on 3/2/15.
//  Copyright (c) 2015 Motingo. All rights reserved.
//

import Foundation
import CoreData

class RefuelStore : CoreDataStore {
  let entityName = "Refuel"
  
  override init() {
    super.init()
    
    storeName = "RefuelStore"
    storeFilename = "RefuelStore.sqlite"
  }
  
  func all() -> [Refuel]{
    let request = NSFetchRequest(entityName: entityName)
    var error : NSError?
    if let context = managedObjectContext {
      let fetchResult = context.executeFetchRequest(request, error: &error) as [NSManagedObject]?
      
      if let results = fetchResult {
        return results.map({ (var object) -> Refuel in
          let refuel = Refuel(
            id: object.objectID,
            odometer: object.valueForKey("odometer") as Int,
            pricePerGallon: object.valueForKey("pricePerGallon") as Float,
            gallons: object.valueForKey("gallons") as Float
          )
          
          if let googlePlaceID = (object.valueForKey("google_place_id") as? String) {
            let station = RefuellingStation(
              name: object.valueForKey("stationName") as String,
              googlePlaceID: googlePlaceID,
              latitude: object.valueForKey("latitude") as Double,
              longitude: object.valueForKey("longitude") as Double
            )
            refuel.station = station
          }
          
          return refuel
        })
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
    object.setValue(refuel.odometer, forKey: "odometer")
    object.setValue(refuel.pricePerGallon, forKey: "pricePerGallon")
    object.setValue(refuel.gallons, forKey: "gallons")
    if let station = refuel.station {
      object.setValue(station.googlePlaceID, forKey: "google_place_id")
      object.setValue(station.latitude, forKey:"latitude")
      object.setValue(station.longitude, forKey:"longitude")
      object.setValue(station.name, forKey:"stationName")
    }
    
    var error : NSError?
    if !context.save(&error) {
      println("Could not save \(error), \(error?.userInfo)")
    } else {
      refuel.id = object.objectID
    }
  }
}
