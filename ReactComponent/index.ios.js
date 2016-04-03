// @flow

import React, {
  AppRegistry,
  Component,
  NativeModules,
} from "react-native";

import StatisticsView from "./components/StatisticsView";
import RefuelsListView from "./components/RefuelsListView";

class App extends Component {
  render() {
    return <RefuelsListView/>;
  }
}

AppRegistry.registerComponent('App', () => App);
AppRegistry.registerComponent('StatisticsView', () => StatisticsView);
AppRegistry.registerComponent('RefuelsListView ', () => RefuelsListView);

export default App;
