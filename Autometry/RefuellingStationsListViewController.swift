import Foundation
import UIKit

class RefuellingStationsListViewController : UITableViewController {
  var stations : [RefuellingStation] = []
  var stationStore : RefuellingStationStore?
  
  func setStations(stations:[RefuellingStation]) {
    self.stations = stations
    self.tableView.reloadData()
  }
  
  // TableViewDataSource interface
  
  override func numberOfSectionsInTableView(tableView: UITableView) -> NSInteger {
    return 1;
  }
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return stations.count;
  }
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("RefuellingStationCellIdentifier", forIndexPath: indexPath) as UITableViewCell
    
    let station = stations[indexPath.row]
    cell.textLabel!.text = String(station.name)
    if station == stationStore!.getCurrentRefuellingStation()! {
      cell.accessoryType = UITableViewCellAccessoryType.Checkmark
    } else {
      cell.accessoryType = UITableViewCellAccessoryType.None
    }

    return cell;
  }
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    tableView.deselectRowAtIndexPath(indexPath, animated:false)
    stationStore!.setCurrentRefuellingStation(stations[indexPath.row])
    //tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.None)
    tableView.reloadData()
  }
}
