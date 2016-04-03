import Foundation

@objc(BSObservable)
class BSObservable : NSObject { // I wish this was a mixin! Gah!
  var listeners : [() -> ()] = []

  @objc func register(callback:()->()) {
    print("Observable#register")
    listeners.append(callback)
  }
  
  func emitChange() {
    print("Observable#emitChange")
    for listener in listeners {
      print("[Observable#emitChange] listener")
      listener()
    }
  }
}