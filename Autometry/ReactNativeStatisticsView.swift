import UIKit
import React

class ReactNativeStatisticsView : UIView {
  static let jsURL = NSURL(string: "http://localhost:8081/index.ios.bundle?platform=ios&dev=true")
  
  let rootView = RCTRootView(
    bundleURL: ReactNativeStatisticsView.jsURL,
    moduleName: "StatisticsView",
    initialProperties: nil,
    launchOptions: nil
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