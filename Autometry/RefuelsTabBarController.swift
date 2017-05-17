import UIKit
import MessageUI

class RefuelsTabBarController : UITabBarController {
  let refuelStore = RefuelStore.sharedInstance
  let tintColor = UIColor(red: 231.0/255.0, green: 76.0/255.0, blue: 60.0/255.0, alpha: 1.0)

  override func viewDidLoad() {
    super.viewDidLoad()

    UITabBar.appearance().tintColor = tintColor
  }

  @IBAction func export(_ sender: AnyObject) {
    let refuels = refuelStore.all()
    let csvString = RefuelCSVWrapper.wrapAll(refuels)

    let docPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
    let filePath = URL(fileURLWithPath: docPath).appendingPathComponent("AutometryDataExport.csv")
    do {
      try csvString.write(to: filePath, atomically: true, encoding: String.Encoding.utf8)

      let activityViewController = UIActivityViewController(activityItems: [filePath], applicationActivities: nil)
      activityViewController.setValue("Autometry Data Export", forKey: "subject")
      present(activityViewController, animated: true, completion: {})
    } catch {
      print("writing to csv failed: \(error)")
    }
  }
}
