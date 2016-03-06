import Foundation

@objc(BSObservable)
class BSObservable : NSObject { // I wish this was a mixin! Gah!
  var listeners : [() -> ()] = []

  @objc func register(callback:()->()) {
    listeners.append(callback)
  }
  
  func emitChange() {
    for listener in listeners {
      listener()
    }
  }
}