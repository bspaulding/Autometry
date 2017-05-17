//
//  InterfaceController.swift
//  Watch Extension
//
//  Created by Bradley Spaulding on 1/6/16.
//  Copyright © 2016 Motingo. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {
  @IBOutlet var totalMilesLabel: WKInterfaceLabel!
  @IBOutlet var totalSpentLabel: WKInterfaceLabel!
  @IBOutlet var averageMPGLabel: WKInterfaceLabel!
  @IBOutlet var bestMPGLabel: WKInterfaceLabel!
  @IBOutlet var worstMPGLabel: WKInterfaceLabel!
  @IBOutlet var bestCPMLabel: WKInterfaceLabel!
  @IBOutlet var averageCPMLabel: WKInterfaceLabel!
  @IBOutlet var worstCPMLabel: WKInterfaceLabel!
  @IBOutlet var bestPPGLabel: WKInterfaceLabel!
  @IBOutlet var averagePPGLabel: WKInterfaceLabel!
  @IBOutlet var worstPPGLabel: WKInterfaceLabel!

  override func awake(withContext context: Any?) {
    super.awake(withContext: context)
    
    WatchSessionManager.sharedManager.register({
      let context = WatchSessionManager.sharedManager.context
      print("Received context: \(context)")
      self.averageMPGLabel.setText(context["mpgAverage"] as? String)
      self.bestMPGLabel.setText(context["mpgBest"] as? String)
      self.worstMPGLabel.setText(context["mpgWorst"] as? String)
      self.totalMilesLabel.setText(context["totalMiles"] as? String)
      self.totalSpentLabel.setText(context["totalSpent"] as? String)
      self.averageCPMLabel.setText(context["cpmAverage"] as? String)
      self.bestCPMLabel.setText(context["cpmBest"] as? String)
      self.worstCPMLabel.setText(context["cpmWorst"] as? String)
      self.averagePPGLabel.setText(context["ppgAverage"] as? String)
      self.bestPPGLabel.setText(context["ppgBest"] as? String)
      self.worstPPGLabel.setText(context["ppgWorst"] as? String)
    })
    WatchSessionManager.sharedManager.updateContext()
  }
  
  override func willActivate() {
    // This method is called when watch view controller is about to be visible to user
    super.willActivate()
  }

  override func didDeactivate() {
    // This method is called when watch view controller is no longer visible
    
    // TODO: unregister listener
    
    super.didDeactivate()
  }
}
