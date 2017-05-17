import WatchConnectivity

// Note that the WCSessionDelegate must be an NSObject
// So no, you cannot use the nice Swift struct here!
class WatchSessionManager: Observable, WCSessionDelegate {
  /** Called when the session has completed activation. If session state is WCSessionActivationStateNotActivated there will be an error with more details. */
  @available(watchOS 2.2, *)
  func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
  }

  var context : [String : AnyObject] = ["empty" : "dict" as AnyObject]
  
  // Instantiate the Singleton
  static let sharedManager = WatchSessionManager()
  fileprivate override init() {
    super.init()
  }
  
  // Keep a reference for the session,
  // which will be used later for sending / receiving data
  fileprivate let session = WCSession.default()
  
  // Activate Session
  // This needs to be called to activate the session before first use!
  func startSession() {
    session.delegate = self
    session.activate()
  }
  
  func session(_ session: WCSession, didReceiveApplicationContext context: [String : Any]) {
    self.context = context as [String : AnyObject]
    self.emitChange()
  }
  
  func updateContext() {
    print("updateContext")
    session.sendMessage(["message": "fetch-dashboard"],
      replyHandler: { context in
        self.context = context as [String : AnyObject]
        self.emitChange()
      },
      errorHandler: { error in
      }
    )
  }
}
