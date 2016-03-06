// @flow

import {
  average, min, max
} from './math';
import {
  cpms,
  milesPerTrip,
  mpgs,
  spendPerTrip
} from './dashboard_utilities';
import accounting from 'accounting';

const { formatMoney, formatNumber } = accounting;

class Dashboard {
  refuels: Array<Refuel>;
  _mpgs: Array<number>;
  cpms: Array<number>;
  _milesPerTrip: Array<number>;
  spendPerTrip: Array<number>;
  ppgs: Array<number>;

  constructor(refuels : Array<Refuel>) {
    this.refuels = refuels;
    this._mpgs = mpgs(refuels);
    this.cpms = cpms(refuels);
    this._milesPerTrip = milesPerTrip(refuels);
    this.spendPerTrip = spendPerTrip(refuels);
    this.ppgs = this.refuels.map((r) => r.pricePerGallon);
  }

  totalMiles() : string {
    return formatNumber(
      this.refuels.length === 0
        ? 0
        : this.refuels[0].odometer - this.refuels[this.refuels.length - 1].odometer
    );
  }

  totalMilesLongest() : string {
    return formatNumber(
      this.refuels.length <= 1 ? 0 : max(this._milesPerTrip)
    );
  }

  totalMilesShortest() : string {
    return formatNumber(
      this.refuels.length <= 1 ? 0 : min(this._milesPerTrip)
    );
  }

  totalSpent() : string {
    return formatMoney(
      this.refuels.length < 1
      ? 0
      : this.refuels.reduce((s, r) => s + r.pricePerGallon * r.gallons, 0)
    );
  }

  totalSpentBest() : string {
    return formatMoney(
      this.refuels.length < 1 ? 0 : min(this.spendPerTrip)
    );
  }

  totalSpentWorst() : string {
    return this.refuels.length < 1 ? "$0.00" : formatMoney(max(this.spendPerTrip));
  }

  mpgs() : Array<number> {
    return this._mpgs;
  }

  mpgBest() : string {
    return this.refuels.length <= 1 ? "N/A" : formatNumber(max(this._mpgs));
  }

  mpgAverage() : string {
    return this.refuels.length <= 1 ? "N/A" : formatNumber(Math.floor(average(this._mpgs)));
  }

  mpgWorst() : string {
    return this.refuels.length <= 1 ? "N/A" : formatNumber(min(this._mpgs));
  }

  ppgAverage() : string {
    return this.refuels.length < 1 ? "N/A" : formatMoney(
      this.refuels.reduce((x, r) => x + r.pricePerGallon, 0) / this.refuels.length
    );
  }

  ppgBest() : string {
    return this.refuels.length < 1 ? "N/A" : formatMoney(min(this.ppgs));
  }

  ppgWorst() : string {
    return this.refuels.length < 1 ? "N/A" : formatMoney(max(this.ppgs));
  }

  cpmAverage() : string {
    return this.refuels.length < 1 ? "$0.00" : formatMoney(average(this.cpms));
  }

  cpmBest() : string {
    return this.refuels.length < 1 ? "$0.00" : formatMoney(min(this.cpms));
  }

  cpmWorst() : string {
    return this.refuels.length < 1 ? "$0.00" : formatMoney(max(this.cpms));
  }

  milesPerTrip() : Array<number> {
    return this._milesPerTrip;
  }
}

export default Dashboard;
