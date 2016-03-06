/* global describe, it */

import assert from 'assert';
import Dashboard from '../dashboard.js';

describe('Dashboard', function() {
  const refuelA = {
    odometer: '10000',
    pricePerGallon: 3.499,
    gallons: 10
  };
  const refuelB = {
    odometer: '10300',
    pricePerGallon: 3.459,
    gallons: 10
  };
  const refuelC = {
    odometer: 10500,
    gallons: 10,
    pricePerGallon: 2.899
  };
  const refuelD = {
    odometer: 10900,
    gallons: 10,
    pricePerGallon: 2.399
  };
  const refuelE = {
    odometer: 10950,
    gallons: 10,
    pricePerGallon: 4.699
  };
  const refuelF = {
    odometer: 10350,
    gallons: 2.5,
    pricePerGallon: 3.999,
    partial: true
  };
  const refuelG = {
    odometer: 10600,
    gallons: 10,
    pricePerGallon: 3.999
  };
  const refuelH = {
    odometer: 10400,
    gallons: 2.5,
    pricePerGallon: 3.999,
    partial: true
  };

  const refuelsA = [refuelC, refuelB, refuelA];
  const refuelsB = [refuelE, refuelD, refuelC, refuelB, refuelA];
  const refuelsC = [refuelG, refuelC, refuelF, refuelB, refuelA];
  const refuelsD = [refuelG, refuelC, refuelH, refuelF, refuelB, refuelA];

  const dashboardEmpty = new Dashboard([]);
  const dashboardSingle = new Dashboard([refuelA]);
  const dashboardA = new Dashboard(refuelsA);
  const dashboardB = new Dashboard(refuelsB);
  const dashboardC = new Dashboard(refuelsC);
  const dashboardD = new Dashboard(refuelsD);

  describe('mpgAverage', function() {
    it('should return the average mpgs', function() {
      assert.equal(dashboardA.mpgAverage(), 25);
      assert.equal(dashboardB.mpgAverage(), 23);
    });
  });

  describe('mpgBest', function() {
    it('should return the highest mpg', function() {
      assert.equal(dashboardA.mpgBest(), 30);
      assert.equal(dashboardB.mpgBest(), 40);
    });
  });

  describe('mpgWorst', function() {
    it('should return the lowest mpg', function() {
      assert.equal(dashboardA.mpgWorst(), 20);
      assert.equal(dashboardB.mpgWorst(), 5);
    });
  });

  describe('ppgAverage', function() {
    it('should return N/A when no refuels', function() {
      assert.equal(dashboardEmpty.ppgAverage(), "N/A");
    });

    it('should return the average price per gallon', function() {
      assert.equal(dashboardA.ppgAverage(), "$3.29");
      assert.equal(dashboardB.ppgAverage(), "$3.39");
    });
  });

  describe('ppgBest', function() {
    it('should return N/A when no refuels', function() {
      assert.equal(dashboardEmpty.ppgBest(), "N/A");
    });
    it('returns the lowest price per gallon', function() {
      assert.equal(dashboardA.ppgBest(), "$2.90");
      assert.equal(dashboardB.ppgBest(), "$2.40");
    });
  });

  describe('ppgWorst', function() {
    it('should return N/A when no refuels', function() {
      assert.equal(dashboardEmpty.ppgWorst(), "N/A");
    });
    it('returns the highest price per gallon', function() {
      assert.equal(dashboardA.ppgWorst(), "$3.50");
      assert.equal(dashboardB.ppgWorst(), "$4.70");
    });
  });

  describe('totalSpent', function() {
    it('should return the total dollars', function() {
      assert.equal(dashboardEmpty.totalSpent(), "$0.00");
      assert.equal(dashboardA.totalSpent(), "$98.57");
      assert.equal(dashboardB.totalSpent(), "$169.55");
    });
  });

  describe('totalSpentBest', function() {
    it('should return the largest refuel spend', function() {
      assert.equal(dashboardA.totalSpentBest(), "$28.99");
      assert.equal(dashboardB.totalSpentBest(), "$23.99");
    });
  });

  describe('totalSpentWorst', function() {
    it('should return the smallest refuel spend', function() {
      assert.equal(dashboardA.totalSpentWorst(), "$34.99");
      assert.equal(dashboardB.totalSpentWorst(), "$46.99");
    });
  });

  describe('totalMiles', function() {
    it('should return 0 if only one refuel', function() {
      assert.equal(dashboardSingle.totalMiles(), 0);
    });

    it('should return the difference in odometers', function() {
      assert.equal(dashboardA.totalMiles(), 500);
      assert.equal(dashboardB.totalMiles(), 950);
    });
  });

  describe('totalMilesLongest', function() {
    it('should return 0 if only one refuel', function() {
      assert.equal(dashboardSingle.totalMilesLongest(), 0);
    });

    it('should return the largest difference in odometer between refuels', function() {
      assert.equal(dashboardA.totalMilesLongest(), 300);
      assert.equal(dashboardB.totalMilesLongest(), 400);
    });
  });

  describe('totalMilesShortest', function() {
    it('should return 0 if only one refuel', function() {
      assert.equal(dashboardSingle.totalMilesShortest(), 0);
    });

    it('should return the smallest difference in odometer between refuels', function() {
      assert.equal(dashboardA.totalMilesShortest(), 200);
      assert.equal(dashboardB.totalMilesShortest(), 50);
    });
  });

  describe('cpmAverage', function() {
    it('should be zero when no refuels', function() {
      assert.equal(dashboardEmpty.cpmAverage(), "$0.00");
    });
    it('should return the average cost per mile', function() {
      assert.equal(dashboardA.cpmAverage(), "$0.14");
      assert.equal(dashboardB.cpmAverage(), "$0.21");
    });
  });

  describe('cpmBest', function() {
    it('should be zero when no refuels', function() {
      assert.equal(dashboardEmpty.cpmBest(), "$0.00");
    });
    it('should return the lowest cost per mile between two refuels', function() {
      assert.equal(dashboardA.cpmBest(), "$0.12");
      assert.equal(dashboardB.cpmBest(), "$0.07");
    });
  });

  describe('cpmWorst', function() {
    it('should be zero when no refuels', function() {
      assert.equal(dashboardEmpty.cpmWorst(), "$0.00");
    });
    it('should return the highest cost per mile between two refuels', function() {
      assert.equal(dashboardA.cpmWorst(), "$0.17");
      assert.equal(dashboardB.cpmWorst(), "$0.48");
    });
  });

  describe('milesPerTrip', function() {
    it('should return an array of Numbers of miles between refuels', function() {
      const milesA = dashboardA.milesPerTrip();
      assert.equal(milesA.length, 2);
      assert.equal(milesA[0], 200);
      assert.equal(milesA[1], 300);

      const milesB = dashboardB.milesPerTrip();
      assert.equal(milesB.length, 4);
      assert.equal(milesB[0], 50);
      assert.equal(milesB[1], 400);
      assert.equal(milesB[2], 200);
      assert.equal(milesB[3], 300);
    });
  });

  describe('mpgs', function() {
    it('should return the mpg between full refuels', function() {
      const mpgsA = dashboardA.mpgs();
      assert.equal(mpgsA.length, refuelsA.length - 1);
      assert.equal(mpgsA[0], 20);
      assert.equal(mpgsA[1], 30);

      const mpgsB = dashboardB.mpgs();
      assert.equal(mpgsB.length, refuelsB.length - 1);
      assert.equal(mpgsB[0], 5);
      assert.equal(mpgsB[1], 40);
      assert.equal(mpgsB[2], 20);
      assert.equal(mpgsB[3], 30);

      const refuel1 = { odometer: 10000, gallons: 10 };
      const refuel2 = { odometer: 10300, gallons: 15 };
      const refuelsC = [refuel2, refuel1];
      const mpgsC = (new Dashboard(refuelsC)).mpgs();

      assert.equal(mpgsC.length, refuelsC.length - 1);
      assert.equal(mpgsC[0], 20);
    });

    it('should skip partial refuels in the middle of the list', function() {
      const mpgs = dashboardC.mpgs();
      assert.equal(refuelsC.length, 5);
      assert.equal(mpgs.length, refuelsC.length - 1);
      assert.equal(mpgs[0], 10);
      assert.equal(mpgs[1], 16);
      assert.equal(mpgs[2], 16);
      assert.equal(mpgs[3], 30);
    });

    it('should skip partial refuel when its the newest', function() {
      const refuels = [refuelF, refuelB, refuelA];
      const mpgs = (new Dashboard(refuels)).mpgs();
      assert.equal(refuels.length, 3);
      assert.equal(mpgs.length, 1);
      assert.equal(mpgs[0], 30);
    });

    it('should skip partial refuel when its the oldest', function() {
      const refuels = [refuelC, refuelF];
      const mpgs = (new Dashboard(refuels)).mpgs();
      assert.equal(refuels.length, 2);
      assert.equal(mpgs.length, 1);
      assert.equal(mpgs[0], 15);
    });

    it('should skip all partials in multiple positions', function() {
      const mpgs = dashboardD.mpgs();
      assert.equal(refuelsD.length, 6);
      assert.equal(mpgs.length, refuelsD.length - 1);
      assert.equal(mpgs[0], 10);
      assert.equal(mpgs[1], 13);
      assert.equal(mpgs[2], 13);
      assert.equal(mpgs[3], 13);
      assert.equal(mpgs[4], 30);
    });
  });
});
