import Foundation

struct Formatters {
  let dateFormatter = NSDateFormatter()
  let currencyFormatter = NSNumberFormatter()
  let numberFormatter = NSNumberFormatter()
  
  init() {
    dateFormatter.dateStyle = NSDateFormatterStyle.LongStyle
    currencyFormatter.numberStyle = .CurrencyStyle
    numberFormatter.numberStyle = .DecimalStyle
  }
}

let formatters = Formatters()