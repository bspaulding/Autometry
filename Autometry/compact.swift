import Foundation

func compact(collection: [String]) -> [String] {
  return filter(collection) {
    if count($0) > 0 {
      return true
    } else {
      return false
    }
  }
}