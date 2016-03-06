// @flow

import React, {
  AppRegistry,
  Component,
  NativeModules,
  ScrollView,
  Text,
  View
} from "react-native";
import Dashboard from "./dashboard";

const { RefuelStore } = NativeModules;

const styles = {
  container: {
    flex: 1,
    backgroundColor: "#F6F6F6",
    paddingTop: 15
  },
  panel: {
    backgroundColor: "#fff",
    borderBottomWidth: 1,
    borderTopWidth: 1,
    borderBottomColor: "#CDCDCD",
    borderTopColor: "#CDCDCD",
    marginTop: 4,
    marginBottom: 4,
    padding: 8
  },
  panelTitle: {
    fontSize: 17
  },
  metricValue: {
    fontSize: 28
  },
  metricLabel: {
    fontSize: 18,
    fontWeight: "300",
    color: "#686868"
  }
};

const Panel = (props) => <View style={styles.panel}>{props.children}</View>;
Panel.propTypes = { children: React.PropTypes.node };
const PanelTitle = (props) => <Text style={styles.panelTitle}>{props.children}</Text>;
PanelTitle.propTypes = { children: React.PropTypes.node };

function parse(refuel : RawRefuel) : Refuel {
  return {
    odometer: parseInt(refuel.odometer, 10),
    pricePerGallon: parseFloat(refuel.pricePerGallon, 10),
    gallons: parseFloat(refuel.gallons, 10),
    octane: parseInt(refuel.octane, 10),
    partial: refuel.partial !== "false",
  };
};

class App extends Component {
  constructor(props : {}) {
    super(props);

    this.state = { refuels: [] };
  }

  componentWillMount() {
    RefuelStore.getAll((response) => {
      this.setState({
        refuels: response.refuels
          .map(parse)
          .sort((a, b) => a.odometer >= b.odometer ? -1 : 1)
      });
    });
  }

  render() {
    const { refuels } = this.state;
    const dashboard = new Dashboard(refuels);

    const MetricGroup = (props) => <View style={{ flex: 1, flexDirection: "row", marginTop: 20, marginBottom: 20 }}>{props.children}</View>;
    const MetricItem = (props) => <View style={{ flex: 1, alignItems: "center" }}>{props.children}</View>;
    const MetricValue = (props) => <Text style={styles.metricValue}>{props.children}</Text>;
    const MetricLabel = (props) => <Text style={styles.metricLabel}>{props.children}</Text>;

    return (
      <ScrollView style={{ backgroundColor: styles.container.backgroundColor }}>
      <View style={styles.container}>
        <Panel>
          <PanelTitle>Totals</PanelTitle>
          <MetricGroup>
            <MetricItem>
              <MetricValue>{dashboard.totalMiles()}</MetricValue>
              <MetricLabel>Miles</MetricLabel>
            </MetricItem>
            <MetricItem>
              <MetricValue>{dashboard.totalSpent()}</MetricValue>
              <MetricLabel>Spent</MetricLabel>
            </MetricItem>
          </MetricGroup>
        </Panel>
        <Panel>
          <PanelTitle>Miles Per Gallon</PanelTitle>
          <MetricGroup>
            <MetricItem>
              <MetricValue>{dashboard.mpgBest()}</MetricValue>
              <MetricLabel>Best</MetricLabel>
            </MetricItem>
            <MetricItem>
              <MetricValue>{dashboard.mpgAverage()}</MetricValue>
              <MetricLabel>Average</MetricLabel>
            </MetricItem>
            <MetricItem>
              <MetricValue>{dashboard.mpgWorst()}</MetricValue>
              <MetricLabel>Worst</MetricLabel>
            </MetricItem>
          </MetricGroup>
        </Panel>
        <Panel>
          <PanelTitle>Cost Per Mile</PanelTitle>
          <MetricGroup>
            <MetricItem>
              <MetricValue>{dashboard.cpmBest()}</MetricValue>
              <MetricLabel>Best</MetricLabel>
            </MetricItem>
            <MetricItem>
              <MetricValue>{dashboard.cpmAverage()}</MetricValue>
              <MetricLabel>Average</MetricLabel>
            </MetricItem>
            <MetricItem>
              <MetricValue>{dashboard.cpmWorst()}</MetricValue>
              <MetricLabel>Worst</MetricLabel>
            </MetricItem>
          </MetricGroup>
        </Panel>
        <Panel>
          <PanelTitle>Price Per Gallon</PanelTitle>
          <MetricGroup>
            <MetricItem>
              <MetricValue>{dashboard.ppgBest()}</MetricValue>
              <MetricLabel>Best</MetricLabel>
            </MetricItem>
            <MetricItem>
              <MetricValue>{dashboard.ppgAverage()}</MetricValue>
              <MetricLabel>Average</MetricLabel>
            </MetricItem>
            <MetricItem>
              <MetricValue>{dashboard.ppgWorst()}</MetricValue>
              <MetricLabel>Worst</MetricLabel>
            </MetricItem>
          </MetricGroup>
        </Panel>
      </View>
      </ScrollView>
    );
  }
}

AppRegistry.registerComponent('App', () => App);

export default App;
