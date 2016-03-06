// @flow

import { totalSpent } from './refuel_utilities';

const tripStart = (refuels, currentRefuel) => {
  const currentRefuelIndex = refuels.indexOf(currentRefuel);
  const last = refuels[refuels.length - 1];
  if (currentRefuelIndex < 0) {
    return last;
  }

  const lastFull = refuels
    .slice(currentRefuelIndex + 1, refuels.length)
    .find((r) => !r.partial);

  return lastFull ? lastFull : last;
};

const tripEnd = (refuels, currentRefuel) => {
  const currentRefuelIndex = refuels.indexOf(currentRefuel);
  if (currentRefuelIndex) {
    return refuels
      .slice(0, currentRefuelIndex + 1)
      .reverse()
      .find((r) => !r.partial);
  }

  return refuels[0];
};

export function mpgs(refuels : Array<Refuel>) : Array<number> {
  if (refuels.length <= 1) {
    return [];
  }

  var firstFullRefuel = refuels.find((r) => !r.partial);
  var firstFullRefuelIndex = refuels.indexOf(firstFullRefuel);

  return refuels.slice(firstFullRefuelIndex, refuels.length - 1)
    .map((r, i, rs) => {
      const start = tripStart(refuels, r);
      const end = tripEnd(refuels, r);
      const miles = end.odometer - start.odometer;

      const startIndex = refuels.indexOf(start);
      const endIndex = refuels.indexOf(end);
      const gallons = refuels.slice(endIndex, startIndex)
        .map((r) => r.gallons)
        .reduce((s,x) => s + x, 0);

      return Math.floor(miles / gallons);
    });
}

export function cpms(refuels : Array<Refuel>) : Array<number> {
  if (refuels.length <= 1) {
    return [];
  }

  return refuels.slice(0, refuels.length - 1).map((refuel, index) => {
    const prev = refuels[index + 1];
    const cost = totalSpent(prev);
    const miles = refuel.odometer - prev.odometer;
    return cost / miles;
  });
}

export function milesPerTrip(refuels : Array<Refuel>) : Array<number> {
  if (refuels.length <= 1) {
    return [];
  }

  return refuels.slice(0, refuels.length - 1)
    .map((refuel, index) => {
      return refuel.odometer - refuels[index + 1].odometer;
    });
}

export function spendPerTrip(refuels : Array<Refuel>) : Array<number> {
  return refuels.map((refuel) => totalSpent(refuel));
}
