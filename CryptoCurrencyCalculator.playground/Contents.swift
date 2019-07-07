import UIKit

class CrytoCurrencyCalculator {
    
    func calculateCryptoCurrency(days : Int, currencies : Dictionary<Int,CryptoCurrency>) -> Array<CryptoCurrency> {
        var result = Array<CryptoCurrency>()
        
        if currencies.count == 0 {
            return result
        }
        
        let currenciesSortedByTimestamp = sortCrytoCurrenciesDescending(currencies: currencies)
        
        let currenciesByDate = convertCurrenciesTimestampToDate(currencies: currenciesSortedByTimestamp)
        
        let currenciesDaysAgo = currenciesDuringTheLast(days: days, currencies: currenciesByDate)
        
        let currenciesBySymbolDaysAgo = currenciesSumBySymbol(currenciesDaysAgo: currenciesDaysAgo)
        
        result = currenciesBySymbolDaysAgo
        
        return result
    }
    
    func sortCrytoCurrenciesDescending(currencies : Dictionary<Int,CryptoCurrency>) -> Array<(Int,CryptoCurrency)> {
        return currencies.sorted(by: { $0.0 > $1.0 })
    }
    
    func convertCurrenciesTimestampToDate(currencies : Array<(Int,CryptoCurrency)>) -> Array<(Date,CryptoCurrency)> {
        var result = Array<(Date, CryptoCurrency)>()
        
        if currencies.count == 0 {
            return result
        }
        
        for currency in currencies {
            
            let currencyOnDate = Date(timeIntervalSince1970: Double(currency.0))
            
            result.append((currencyOnDate, currency.1))
        }
        
        return result
    }
    
    func currenciesDuringTheLast(days: Int, currencies: Array<(Date, CryptoCurrency)>) -> Array<CryptoCurrency> {
        var result = Array<CryptoCurrency>()
        
        let today = Date()
        let daysAgo : Date = Calendar.current.date(byAdding: .day, value: -days, to: today)!
        
        let currenciesDuringDaysAgo = currencies.filter{ $0.0 > daysAgo }
        
        currenciesDuringDaysAgo.forEach{ currency in
            
            result.append(currency.1)

        }
        
        return result
    }
    
    func currenciesSumBySymbol(currenciesDaysAgo: Array<CryptoCurrency>) -> Array<CryptoCurrency>{
        var result : Array<CryptoCurrency> = Array<CryptoCurrency>()

        let currenciesBySymbol = Dictionary(grouping: currenciesDaysAgo, by: {$0.symbol})
        
        for currency in currenciesBySymbol {
            
            var cryptoCurrency = CryptoCurrency(_amount: 0.0, _symbol: currency.key)
            currency.value.forEach{ currencyValue in
                cryptoCurrency.amount += currencyValue.amount
            }
            
            result.append(cryptoCurrency)
        }
        
        return result
    }
}

extension Date {
    
    var month: Int {
        return Calendar.current.component(.month, from: self)
    }
    
}

class CryptoCurrency {
    var amount : Decimal
    var symbol : String
    
    init(_amount: Decimal, _symbol: String) {
        amount = _amount
        symbol = _symbol
    }
}

//Tests
let cryptoCurrency = [1549424985: CryptoCurrency(_amount: 10.0, _symbol: "XRP"),
                      1546531031: CryptoCurrency(_amount: 200.0, _symbol: "XRP"),
                      1546531017: CryptoCurrency(_amount: 1.0, _symbol: "ETH"),
                      1546531018: CryptoCurrency(_amount: 1.0, _symbol: "ETH"),
                      1549424153: CryptoCurrency(_amount: 50.0, _symbol: "EOS"),
                      1549424154: CryptoCurrency(_amount: 50.0, _symbol: "EOS")]

let crytoCurrencyCalculator = CrytoCurrencyCalculator()

let cryptoCurrencyTotals : Array<CryptoCurrency> = crytoCurrencyCalculator.calculateCryptoCurrency(days: 160, currencies: cryptoCurrency)

cryptoCurrencyTotals.forEach{ cryptoCurrencyTotal in
    
    print(cryptoCurrencyTotal.symbol, ":", cryptoCurrencyTotal.amount)
}
