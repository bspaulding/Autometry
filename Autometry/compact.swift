import Foundation

func compact(collection: [String]) -> [String] {
  return collection.filter {
    if $0.characters.count > 0 {
      return true
    } else {
      return false
    }
  }
}