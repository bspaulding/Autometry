import UIKit
import React

class ReactNativeNewRefuelView : UIView {
  
  let rootView = RCTRootView(
    bridge: ReactBridge.sharedInstance,
    moduleName: "NewRefuel",
    initialProperties: nil
  )
  
  required init(coder: NSCoder) {
    super.init(coder: coder)!
    addReactView()
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    addReactView()
  }
  
  func addReactView() {
    addSubview(rootView)
  }
  
  override func layoutSubviews() {
    rootView.frame = bounds
  }
}