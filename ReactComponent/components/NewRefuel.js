/* @flow */
import React, {
	ActivityIndicatorIOS,
	Component,
	ScrollView,
	SwitchIOS,
	Text,
	TextInput,
	View
} from "react-native";
import {CustomCell, Section, TableView} from 'react-native-tableview-simple';
import accounting from 'accounting';

const { formatMoney, formatNumber } = accounting;

const Label = (props) => <Text style={{ flex: 1, fontSize: 16 }}>{props.children}</Text>;
Label.propTypes = { children: React.PropTypes.node };
const BoldLabel = (props) => <Text style={{ flex: 1, fontSize: 16, fontWeight: "600" }}>{props.children}</Text>;
BoldLabel.propTypes = { children: React.PropTypes.node };
const ValueLabel = (props) => <Text style={{ flex: 1, fontSize: 16, textAlign: "right" }}>{props.children}</Text>;
ValueLabel.propTypes = { children: React.PropTypes.node };

const chevronRightStyle = {
	width: 10,
	height: 10,
	marginLeft: 7,
	backgroundColor: 'transparent',
	borderTopWidth: 1,
	borderRightWidth: 1,
	borderColor: '#c7c7cc',
	transform: [{
		rotate: '45deg',
	}],
};
const ChevronRight = () => <View style={chevronRightStyle}/>;

const initialRefuel = { gallons: "", octane: "", odometer: "", partial: false, pricePerGallon: "" };

class NewRefuel extends Component {
	constructor(props: { refuel:Refuel }) {
		super(props);

		this.state = {
			...(props.refuel || initialRefuel)
		};

		this.odometerChanged = this.odometerChanged.bind(this);
		this.octaneChanged = this.octaneChanged.bind(this);
		this.pricePerGallonChanged = this.pricePerGallonChanged.bind(this);
		this.gallonsChanged = this.gallonsChanged.bind(this);
	}

	odometerChanged(odometer : string) {
		this.setState({ odometer });
	}

	octaneChanged(octane : string) {
		this.setState({ octane });
	}

	pricePerGallonChanged(pricePerGallon : string) {
		this.setState({ pricePerGallon });
	}

	gallonsChanged(gallons : string) {
		this.setState({ gallons });
	}

	render() {
		const { gallons, octane, odometer, partial, pricePerGallon } = this.state;
		const total = gallons * pricePerGallon;

		return (
			<View style={{ flex: 1 }}>
			<ScrollView style={{ flex: 1, backgroundColor: "#EFEFF4" }}>
				<TableView style={{ flex: 1 }}>
					<Section style={{ flex: 1 }}>
						<CustomCell>
							<Label>Odometer</Label>
							<TextInput
								keyboardType={"numeric"}
								placeholder={"miles"}
								value={odometer ? formatNumber(odometer) : odometer}
								style={{ flex: 1, textAlign: "right" }}
								onChangeText={this.odometerChanged}
							/>
						</CustomCell>
					</Section>
					<Section style={{ flex: 1 }}>
						<CustomCell>
							<Label>Location</Label>
							<ActivityIndicatorIOS/>
							<ChevronRight/>
						</CustomCell>
					</Section>
					<Section style={{ flex: 1 }}>
						<CustomCell>
							<Label>Full</Label>
							<SwitchIOS value={!partial}/>
						</CustomCell>
					</Section>
					<Section style={{ flex: 1 }}>
						<CustomCell>
							<Label>Octane</Label>
							<TextInput
								keyboardType={"numeric"}
								placeholder={"level"}
								value={octane ? formatNumber(octane) : octane}
								style={{ flex: 1, textAlign: "right" }}
								onChangeText={this.octaneChanged}
							/>
						</CustomCell>
						<CustomCell>
							<Label>Price Per Gallon</Label>
							<TextInput
								keyboardType={"numeric"}
								placeholder={"dollars"}
								value={pricePerGallon ? formatMoney(pricePerGallon) : pricePerGallon}
								style={{ flex: 1, textAlign: "right" }}
								onChangeText={this.pricePerGallonChanged}
							/>
						</CustomCell>
						<CustomCell>
							<Label>Gallons</Label>
							<TextInput
								keyboardType={"numeric"}
								placeholder={"gallons"}
								value={gallons ? formatNumber(gallons) : gallons}
								style={{ flex: 1, textAlign: "right" }}
								onChangeText={this.gallonsChanged}
							/>
						</CustomCell>
						<CustomCell>
							<BoldLabel>Total</BoldLabel>
							<ValueLabel>{formatMoney(total)}</ValueLabel>
						</CustomCell>
					</Section>
				</TableView>
			</ScrollView>
			</View>
		);
	}
}

export default NewRefuel;
