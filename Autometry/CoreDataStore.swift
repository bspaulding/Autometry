import Foundation
import CoreData

class CoreDataStore: Observable {
  
  var storeName : String = "CoreDataStoreName";
  var storeFilename : String = "CoreDataStoreFilename";
  
  // From Base Class in Example
  
  lazy var applicationDocumentsDirectory: URL = {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "me.iascchen.MyTTT" in the application's documents Application Support directory.
    let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return urls[urls.count-1] 
    }()
  
  lazy var managedObjectModel: NSManagedObjectModel = {
    // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
    let modelURL = Bundle.main.url(forResource: self.storeName, withExtension: "momd")!
    return NSManagedObjectModel(contentsOf: modelURL)!
    }()
  
  lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
    // Create the coordinator and store
    var coordinator: NSPersistentStoreCoordinator? = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
    let url = self.applicationDocumentsDirectory.appendingPathComponent(self.storeFilename)
    var error: NSError? = nil
    var failureReason = "There was an error creating or loading the application's saved data."
    let options = [
      NSMigratePersistentStoresAutomaticallyOption: true,
      NSInferMappingModelAutomaticallyOption: true
    ]
    do {
      try coordinator!.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: options)
    } catch var error1 as NSError {
      coordinator = nil
      // Report any error we got.
      // Replace this with code to handle the error appropriately.
      // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
      print("Failed to initialize the application's saved data")
      print(failureReason)
      print(error)
      abort()
    } catch {
      fatalError()
    }
    
    return coordinator
    }()
  
  // From CoreDataHelper in Example
  
  override init(){
    super.init()
    
    NotificationCenter.default.addObserver(self, selector: #selector(CoreDataStore.contextDidSaveContext(_:)), name: NSNotification.Name.NSManagedObjectContextDidSave, object: nil)
  }
  
  deinit{
    NotificationCenter.default.removeObserver(self)
  }
  
  lazy var managedObjectContext: NSManagedObjectContext? = {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
    let coordinator = self.persistentStoreCoordinator
    if coordinator == nil {
      return nil
    }
    var managedObjectContext = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.mainQueueConcurrencyType)
    managedObjectContext.persistentStoreCoordinator = coordinator
    return managedObjectContext
    }()
  
  // Returns the background object context for the application.
  // You can use it to process bulk data update in background.
  // If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
  
  lazy var backgroundContext: NSManagedObjectContext? = {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
    let coordinator = self.persistentStoreCoordinator
    if coordinator == nil {
      return nil
    }
    var backgroundContext = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.privateQueueConcurrencyType)
    backgroundContext.persistentStoreCoordinator = coordinator
    return backgroundContext
    }()
  
  
  // save NSManagedObjectContext
  func saveContext (_ context: NSManagedObjectContext, success:()->(), failure:(_ error:Error)->()) {
    if context.hasChanges {
      do {
        try context.save()
        success()
      } catch {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog("Unresolved error \(error)")
        failure(error)
      }
    } else {
      success()
    }
  }
  
  func saveContext (_ success:()->(), failure:(_ error:Error)->()) {
    self.saveContext(self.backgroundContext!, success: success, failure: failure)
  }
  
  // call back function by saveContext, support multi-thread
  func contextDidSaveContext(_ notification: Notification) {
    let sender = notification.object as! NSManagedObjectContext
    if sender === self.managedObjectContext {
      NSLog("******** Saved main Context in this thread")
      self.backgroundContext!.perform {
        self.backgroundContext!.mergeChanges(fromContextDidSave: notification)
      }
    } else if sender === self.backgroundContext {
      NSLog("******** Saved background Context in this thread")
      self.managedObjectContext!.perform {
        self.managedObjectContext!.mergeChanges(fromContextDidSave: notification)
      }
    } else {
      NSLog("******** Saved Context in other thread")
      self.backgroundContext!.perform {
        self.backgroundContext!.mergeChanges(fromContextDidSave: notification)
      }
      self.managedObjectContext!.perform {
        self.managedObjectContext!.mergeChanges(fromContextDidSave: notification)
      }
    }
  }
}
