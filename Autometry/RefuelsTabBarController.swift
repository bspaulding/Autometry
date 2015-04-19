import UIKit
import MessageUI

class RefuelsTabBarController : UITabBarController, MFMailComposeViewControllerDelegate {
  let refuelStore = RefuelStore.sharedInstance
  var picker : MFMailComposeViewController?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    UITabBar.appearance().tintColor = UIColor(red: 231.0/255.0, green: 76.0/255.0, blue: 60.0/255.0, alpha: 1.0)
  }
  
  @IBAction func export(sender: AnyObject) {
    let picker = MFMailComposeViewController()
    self.picker = picker
    picker.mailComposeDelegate = self
    picker.setSubject("Autometry Data Export")
    picker.setMessageBody("Hi!\n\nAttached is a spreadshet export of your data. Thanks for using Autometry!", isHTML: false)
    
    let refuels = refuelStore.all()
    let csvString = RefuelCSVWrapper.wrapAll(refuels)
    let csvData = csvString.dataUsingEncoding(NSUTF8StringEncoding)
    picker.addAttachmentData(csvData, mimeType:"text/csv", fileName:"AutometryExport.csv")
    
    presentViewController(picker, animated:true, completion:nil)
  }
  
  func mailComposeController(controller: MFMailComposeViewController!,
    didFinishWithResult result: MFMailComposeResult,
    error: NSError!) {
      if let picker = self.picker {
        picker.dismissViewControllerAnimated(true, completion:nil)
      }
  }
}