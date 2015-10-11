import Foundation
import UIKit

class KeyboardNavigationView : UIToolbar {
  let navButtonItems : [String] = ["Previous", "Next"]
  var navButtons : UISegmentedControl
  var onPrevious : () -> () = {}
  var onNext : () -> () = {}
  
  override init(frame:CGRect) {
    navButtons = UISegmentedControl(items: navButtonItems)

    super.init(frame:frame)

    navButtons.momentary = true
    navButtons.addTarget(self, action:"navButtonsChanged", forControlEvents:UIControlEvents.ValueChanged)

    
    items = [UIBarButtonItem(customView:navButtons)]
    
    // TODO: This doesn't work...maybe need to size first?
    let bottomBorder = UIView(frame: CGRect(x: 0, y: frame.height, width: frame.width, height: 1))
    bottomBorder.backgroundColor = UIColor.grayColor()
    self.addSubview(bottomBorder)

    sizeToFit()
  }
  
  convenience init() {
    self.init(frame:CGRectZero)
  }
  
  required init?(coder:NSCoder) {
    fatalError("This class does not support NSCoding")
  }
  
  func navButtonsChanged() {
    switch navButtonItems[navButtons.selectedSegmentIndex] {
    case "Previous":
      onPrevious()
    case "Next":
      onNext()
    default:
      ({} as () -> ())()
    }
  }
}
