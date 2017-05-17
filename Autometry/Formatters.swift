import Foundation

struct Formatters {
  let dateFormatter = DateFormatter()
  let currencyFormatter = NumberFormatter()
  let numberFormatter = NumberFormatter()
  
  init() {
    dateFormatter.dateStyle = DateFormatter.Style.long
    currencyFormatter.numberStyle = .currency
    numberFormatter.numberStyle = .decimal
  }
}

let formatters = Formatters()
