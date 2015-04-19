import Foundation
import UIKit

class KeyboardNavigationView : UIView {
  override init(frame:CGRect) {
    super.init(frame:frame)
    
    let toolbar = UIToolbar()
    toolbar.sizeToFit()
    
    let navButtons = UISegmentedControl(items: ["Previous", "Next"])
    navButtons.momentary = true
    navButtons.addTarget(self, action:"navButtonsChanged", forControlEvents:UIControlEvents.ValueChanged)
    
    toolbar.items = [UIBarButtonItem(customView:navButtons)]
    
    self.addSubview(toolbar)
  }
  
  convenience init() {
    self.init(frame:CGRectZero)
  }
  
  required init(coder:NSCoder) {
    fatalError("This class does not support NSCoding")
  }
}
