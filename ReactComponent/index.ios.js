// @flow

import React, {
  AppRegistry,
  Component,
} from "react-native";

import StatisticsView from "./components/StatisticsView";
import RefuelsListView from "./components/RefuelsListView";
import NewRefuel from "./components/NewRefuel";

class App extends Component {
  render() {
    return <RefuelsListView/>;
  }
}

AppRegistry.registerComponent('App', () => App);
AppRegistry.registerComponent('StatisticsView', () => StatisticsView);
AppRegistry.registerComponent('RefuelsListView ', () => RefuelsListView);
AppRegistry.registerComponent("NewRefuel", () => NewRefuel);

export default App;
