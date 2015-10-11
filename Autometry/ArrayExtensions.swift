func arrayFind<T>(f: T -> Bool, xs: [T]) -> T? {
  for (_, x) in xs.enumerate() {
    if f(x) {
      return x;
    }
  }
  
  return nil
}

func arrayFindRight<T>(f: T -> Bool, xs: [T]) -> T? {
  for (var i = xs.count - 1; i >= 0; i -= 1) {
  if f(xs[i]) {
      return xs[i];
    }
  }
  
  return nil
}

extension Array {
  func find(f: Element -> Bool) -> Element? {
    return arrayFind(f, xs: self)
  }
  
  func findRight(f: Element -> Bool) -> Element? {
    return arrayFindRight(f, xs: self)
  }
}

func arraySliceFind<T>(f: T -> Bool, xs: ArraySlice<T>) -> T? {
  for (_, x) in xs.enumerate() {
    if f(x) {
      return x;
    }
  }
  
  return nil
}

func arraySliceFindRight<T>(f: T -> Bool, xs: ArraySlice<T>) -> T? {
  for (var i = xs.count - 1; i >= 0; i -= 1) {
    if f(xs[i]) {
      return xs[i];
    }
  }
  
  return nil
}

extension ArraySlice {
  func find(f: Element -> Bool) -> Element? {
    return arraySliceFind(f, xs: self)
  }
  
  func findRight(f: Element -> Bool) -> Element? {
    return arraySliceFindRight(f, xs: self)
  }
}

