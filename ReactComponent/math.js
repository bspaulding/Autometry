// @flow

export function average(xs : Array<number>) : number {
  return xs.reduce((y, x) => y + x, 0) / xs.length;
}

export function max(xs : Array<number>) : number {
  return Math.max.apply(null, xs);
}

export function min(xs : Array<number>) : number {
  return Math.min.apply(null, xs);
}
