declare type Refuel = {
  odometer: number;
  pricePerGallon: number;
  gallons: number;
  octane: number;
  partial: boolean;
}

declare type RawRefuel = {
  odometer: string;
  pricePerGallon: string;
  gallons: string;
  octane: string;
  partial: string;
}
