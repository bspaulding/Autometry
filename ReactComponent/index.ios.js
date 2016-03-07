// @flow

import React, {
  AppRegistry,
  Component,
  NativeModules,
} from "react-native";

import StatisticsView from "./components/StatisticsView";

class App extends Component {
  render() {
    return <StatisticsView/>;
  }
}

AppRegistry.registerComponent('App', () => App);
AppRegistry.registerComponent('StatisticsView', () => StatisticsView);

export default App;
