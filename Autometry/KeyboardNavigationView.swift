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

    navButtons.isMomentary = true
    navButtons.addTarget(self, action:#selector(KeyboardNavigationView.navButtonsChanged), for:UIControlEvents.valueChanged)

    
    items = [UIBarButtonItem(customView:navButtons)]
    
    // TODO: This doesn't work...maybe need to size first?
    let bottomBorder = UIView(frame: CGRect(x: 0, y: frame.height, width: frame.width, height: 1))
    bottomBorder.backgroundColor = UIColor.gray
    self.addSubview(bottomBorder)

    sizeToFit()
  }
  
  convenience init() {
    self.init(frame:CGRect.zero)
  }
  
  required init?(coder:NSCoder) {
    fatalError("This class does not support NSCoding")
  }
  
  @objc func navButtonsChanged() {
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
