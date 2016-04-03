// @flow

import React, {
  Component,
  ListView,
  View,
  Text
} from "react-native";
import accounting from "accounting";
import Dashboard from "../dashboard";
import RefuelStore from "../stores/RefuelStore";
import { darkGray, lightGray } from "../colors";

const { formatMoney, formatNumber } = accounting;

const RefuelListItemDate = (props) => {
  return <Text style={{ fontWeight: "400", fontSize: 17.0 }}>{props.children}</Text>;
};
const RefuelListItemTripInfo = (props) => {
  return <Text style={{ ...props.style, color: darkGray, fontSize: 16.0 }}>{props.children}</Text>;
};
const RefuelListItemMetric = (props) => {
  return <Text style={{ color: darkGray, fontSize: 16.0, fontWeight: props.kind === "bold" ? "600" : "400", textAlign: "center" }}>{props.children}</Text>;
};
const RefuelListItemMetricLabel = (props) => {
  return <Text style={{ color: lightGray, textAlign: "center", fontSize: 16.0 }}>{props.children}</Text>;
};

const RefuelListItem = (props : { refuel:Refuel, index:Number }) => {
  const { dashboard, index, refuel } = props;
  const { createdDate, pricePerGallon, totalSpent } = refuel;

  return (
    <View style={{
      flex: 1,
      flexDirection: "row",
      height: 90,
      backgroundColor: "#fff",
      borderBottomColor: "#D8D8D8",
      borderBottomWidth: 1,
      borderTopWidth: 0,
      paddingLeft: 13,
      paddingBottom: 18,
      paddingTop: 18
    }}>
      <View style={{ flex: 1 }}>
        <RefuelListItemDate>{createdDate.format("MMMM D, YYYY")}</RefuelListItemDate>
        {index > 0 ?
          <RefuelListItemTripInfo style={{ marginTop: 12 }}>{formatNumber(dashboard.milesPerTrip()[index - 1])} miles, {formatNumber(dashboard.mpgs()[index - 1])} mpg</RefuelListItemTripInfo>
        : null}
      </View>
      <View style={{
        flex: 1
      }}>
        <View style={{ flex: 1, flexDirection: "row", marginTop: 6 }}>
          <View style={{ flex: 1 }}>
            <RefuelListItemMetric>{formatMoney(pricePerGallon)}</RefuelListItemMetric>
            <RefuelListItemMetricLabel>/gallon</RefuelListItemMetricLabel>
          </View>
          <View style={{ flex: 1 }}>
            <RefuelListItemMetric kind="bold">{formatMoney(totalSpent)}</RefuelListItemMetric>
            <RefuelListItemMetricLabel>total</RefuelListItemMetricLabel>
          </View>
        </View>
      </View>
    </View>
  );
};

class RefuelsListView extends Component {
  constructor(props : {}) {
    super(props);

    var ds = new ListView.DataSource({
      rowHasChanged: (r1, r2) => r1 !== r2
    });
    this.state = { refuelsDataSource: ds.cloneWithRows([]) };

    this.refuelStoreChanged = this.refuelStoreChanged.bind(this);
  }

  componentDidMount() {
    RefuelStore.listen(this.refuelStoreChanged);
  }

  refuelStoreChanged(refuels) {
    this.setState({
      dashboard: new Dashboard(refuels),
      refuelsDataSource: this.state.refuelsDataSource.cloneWithRows(refuels)
    });
  }

  render() {
    return (
      <ListView
        dataSource={this.state.refuelsDataSource}
        renderRow={(refuel, sectionID, rowID) => <RefuelListItem refuel={refuel} index={rowID} dashboard={this.state.dashboard}/>}
      />
    );
  }
}

export default RefuelsListView;
