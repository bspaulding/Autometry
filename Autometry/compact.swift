import Foundation

func compact(_ collection: [String]) -> [String] {
  return collection.filter {
    if $0.count > 0 {
      return true
    } else {
      return false
    }
  }
}
