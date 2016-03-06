import React, {
 View,
 Text
} from "react-native";

const styles = {
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

export const Panel = (props) => <View style={styles.panel}>{props.children}</View>;
Panel.propTypes = { children: React.PropTypes.node };

export const PanelTitle = (props) => <Text style={styles.panelTitle}>{props.children}</Text>;
PanelTitle.propTypes = { children: React.PropTypes.node };


export const MetricGroup = (props) => <View style={{ flex: 1, flexDirection: "row", marginTop: 20, marginBottom: 20 }}>{props.children}</View>;
export const MetricItem = (props) => <View style={{ flex: 1, alignItems: "center" }}>{props.children}</View>;
export const MetricValue = (props) => <Text style={styles.metricValue}>{props.children}</Text>;
export const MetricLabel = (props) => <Text style={styles.metricLabel}>{props.children}</Text>;

