// @flow

import React, {
  Component,
  ScrollView,
  Text,
  View
} from "react-native";

import {
  MetricGroup,
  MetricItem,
  MetricValue,
  MetricLabel,
  Panel,
  PanelTitle
} from "./BasicComponents";

import Dashboard from "../dashboard";
import RefuelStore from "../stores/RefuelStore";

const styles = {
  container: {
    flex: 1,
    backgroundColor: "#F6F6F6",
    paddingTop: 15
  }
};

class StatisticsView extends Component {
  constructor(props : {}) {
    super(props);

    this.state = { refuels: [] };
  }

  componentWillMount() {
    RefuelStore.listen((refuels) => {
      this.setState({ refuels });
    });
  }

  render() {
    const { refuels } = this.state;
    const dashboard = new Dashboard(refuels);

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

export default StatisticsView;
