import UIKit
import MessageUI

class RefuelsTabBarController : UITabBarController, MFMailComposeViewControllerDelegate {
  let refuelStore = RefuelStore.sharedInstance
  var picker : MFMailComposeViewController?
  
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