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
          return Refuel(
            id: object.objectID,
            odometer: object.valueForKey("odometer") as Int,
            pricePerGallon: object.valueForKey("pricePerGallon") as Float,
            gallons: object.valueForKey("gallons") as Float
          )
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
    
    var error : NSError?
    if !context.save(&error) {
      println("Could not save \(error), \(error?.userInfo)")
    } else {
      refuel.id = object.objectID
    }
  }
}
