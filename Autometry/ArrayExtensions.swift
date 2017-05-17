func arrayFind<T>(_ f: (T) -> Bool, xs: [T]) -> T? {
  for (_, x) in xs.enumerated() {
    if f(x) {
      return x;
    }
  }
  
  return nil
}

func arrayFindRight<T>(_ f: (T) -> Bool, xs: [T]) -> T? {
  for i in (0...(xs.count - 1)).reversed() {
    if f(xs[i]) {
      return xs[i];
    }
  }
  
  return nil
}

extension Array {
  func find(_ f: (Element) -> Bool) -> Element? {
    return arrayFind(f, xs: self)
  }
  
  func findRight(_ f: (Element) -> Bool) -> Element? {
    return arrayFindRight(f, xs: self)
  }
}

func arraySliceFind<T>(_ f: (T) -> Bool, xs: ArraySlice<T>) -> T? {
  for (_, x) in xs.enumerated() {
    if f(x) {
      return x;
    }
  }
  
  return nil
}

func arraySliceFindRight<T>(_ f: (T) -> Bool, xs: ArraySlice<T>) -> T? {
  for i in (0...(xs.count - 1)).reversed() {
    if f(xs[i]) {
      return xs[i];
    }
  }
  
  return nil
}

extension ArraySlice {
  func find(_ f: (Element) -> Bool) -> Element? {
    return arraySliceFind(f, xs: self)
  }
  
  func findRight(_ f: (Element) -> Bool) -> Element? {
    return arraySliceFindRight(f, xs: self)
  }
}

