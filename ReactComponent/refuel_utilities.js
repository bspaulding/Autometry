// @flow

export function totalSpent(refuel : Refuel) : number {
  return (refuel.gallons || 0) * refuel.pricePerGallon;
}
