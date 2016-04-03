import Foundation
import React

class ReactBridge : NSObject, RCTBridgeDelegate {
  static let jsURL = NSURL(string: "http://localhost:8081/index.ios.bundle?platform=ios&dev=true")

  private var bridge: RCTBridge!
  
  override init() {
    super.init()
    
    bridge = RCTBridge(delegate: self, launchOptions: nil)
  }

  func sourceURLForBridge(bridge: RCTBridge!) -> NSURL! {
    return ReactBridge.jsURL
  }

  // Singleton Pattern
  
  class var sharedInstance: RCTBridge {
    struct Static {
      static var instance: ReactBridge?
      static var token: dispatch_once_t = 0
    }
    
    dispatch_once(&Static.token) {
      Static.instance = ReactBridge()
    }
    
    return Static.instance!.bridge
  }
}