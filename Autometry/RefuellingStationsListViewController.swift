import Foundation
import UIKit

class RefuellingStationsListViewController : UITableViewController {
  var stations : [RefuellingStation] = []
  var stationStore : RefuellingStationStore?
  
  func setStations(_ stations:[RefuellingStation]) {
    self.stations = stations
    self.tableView.reloadData()
  }
  
  // TableViewDataSource interface
  
  override func numberOfSections(in tableView: UITableView) -> NSInteger {
    return 1;
  }
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return stations.count;
  }
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "RefuellingStationCellIdentifier", for: indexPath) 
    
    let station = stations[indexPath.row]
    cell.textLabel!.text = String(station.name)
    if station == stationStore!.getCurrentRefuellingStation()! {
      cell.accessoryType = UITableViewCellAccessoryType.checkmark
    } else {
      cell.accessoryType = UITableViewCellAccessoryType.none
    }

    return cell;
  }
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated:false)
    stationStore!.setCurrentRefuellingStation(stations[indexPath.row])
    //tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.None)
    tableView.reloadData()
  }
}
