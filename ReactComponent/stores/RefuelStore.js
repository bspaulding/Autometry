// @flow

import {
  NativeAppEventEmitter,
  NativeModules
} from "react-native";
import moment from "moment";

const { RefuelStore } = NativeModules;

function parse(refuel : RawRefuel) : Refuel {
  const pricePerGallon = parseFloat(refuel.pricePerGallon, 10);
  const gallons = parseFloat(refuel.gallons, 10);

  return {
    odometer: parseInt(refuel.odometer, 10),
    pricePerGallon,
    gallons,
    octane: parseInt(refuel.octane, 10),
    partial: refuel.partial !== "false",
    createdDate: moment(parseFloat(refuel.createdDate, 10)),
    totalSpent: pricePerGallon * gallons
  };
}

const parseResponse = (response) => {
  return response.refuels
    .map(parse)
    .sort((a, b) => a.odometer >= b.odometer ? -1 : 1);
};

let listeners = [];

NativeAppEventEmitter.addListener(
  "RefuelStoreChanged",
  () => {
    console.log("RefuelStoreChanged callback called in js");
    RefuelStore.getAll((response) => {
      const refuels = parseResponse(response);
      listeners.forEach((fn) => fn(refuels));
    });
  }
);

export default {
  listen(fn : any) {
    listeners.push(fn);
    RefuelStore.getAll((response) => {
      fn(parseResponse(response));
    });
  }
};
