//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Bektemur on 10/02/23.
//

import Foundation

protocol CoinManagerDelegate {
    func didUpdateWeather(_ coinManager: CoinManager, coin: CoinModel)
    func didFailWithError(error: Error)
}

struct CoinManager {
    
    var delegate: CoinManagerDelegate?
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "AC78A8DC-EF92-4176-9BA5-F6039EAA506F"
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    func getCoinPrice(for currency: String) {
        let selectedCoin = currency
        let urlString = "\(baseURL)/\(selectedCoin)?apikey=\(apiKey)"
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String) {
        //1. Create a URL
        if let url = URL(string: urlString) {
            //2. Create a urlSession
            let session = URLSession(configuration: .default)
            //3. Give the session a task
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    if let rate = self.parseJSON(safeData) {
                        self.delegate?.didUpdateWeather(self, coin: rate)
                    }
                }
            }
            //4. Start the tast
            task.resume()
        }
    }
    func parseJSON(_ coindata: Data) -> CoinModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(CoinData.self, from: coindata)
            
            let bitcoinLabel = decodedData.asset_id_base
            let currency = decodedData.asset_id_quote
            let rate = decodedData.rate
            
            let coinRate = CoinModel(btcLabel: bitcoinLabel, selectedCurrencyLabel: currency, rate: rate)
            return coinRate
            
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
