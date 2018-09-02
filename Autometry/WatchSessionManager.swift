import WatchConnectivity

// Note that the WCSessionDelegate must be an NSObject
// So no, you cannot use the nice Swift struct here!
class WatchSessionManager: NSObject, WCSessionDelegate {
  // Instantiate the Singleton
  static let sharedManager = WatchSessionManager()
  fileprivate override init() {
    super.init()
  }
  
  // Keep a reference for the session,
  // which will be used later for sending / receiving data
  fileprivate let session: WCSession? = WCSession.isSupported() ? WCSession.default : nil
  
  fileprivate var validSession: WCSession? {
    if let session = session, session.isPaired && session.isWatchAppInstalled {
      return session
    }
    
    return nil
  }
  
  // Activate Session
  // This needs to be called to activate the session before first use!
  func startSession() {
    session?.delegate = self
    session?.activate()
  }
  
  func updateApplicationContext(_ applicationContext: [String : AnyObject]) {
    if let session = validSession {
      do {
        try session.updateApplicationContext(applicationContext)
      } catch let error {
//        throw error
        print(error)
      }
    }
  }
  
  func session(_ session: WCSession,
    didReceiveMessage message: [String : Any],
    replyHandler: @escaping ([String : Any]) -> Void) {
    let refuels = RefuelStore.sharedInstance.all().sorted(by: RefuelStore.createdDateSorter)
    replyHandler(Dashboard().toDictionary(refuels))
  }
  
  /** Called when all delegate callbacks for the previously selected watch has occurred. The session can be re-activated for the now selected watch using activateSession. */
  @available(iOS 9.3, *)
  func sessionDidDeactivate(_ session: WCSession) {
  }
  
  /** Called when the session can no longer be used to modify or add any new transfers and, all interactive messages will be cancelled, but delegate callbacks for background transfers can still occur. This will happen when the selected watch is being changed. */
  @available(iOS 9.3, *)
  func sessionDidBecomeInactive(_ session: WCSession) {
  }
  
  /** Called when the session has completed activation. If session state is WCSessionActivationStateNotActivated there will be an error with more details. */
  @available(iOS 9.3, *)
  func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
  }
}
