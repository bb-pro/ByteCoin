//
//  ViewController.swift
//  ByteCoin
//
//  Created by Bektemur on 10/02/23.
//

import UIKit

class CoinViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, CoinManagerDelegate {
    
  
    
    
    @IBOutlet var rateLabel: UILabel!
    @IBOutlet var currencyLabel: UILabel!
    @IBOutlet var currencyPicker: UIPickerView!
    @IBOutlet var btcImageView: UIImageView!
    
    var coinManager = CoinManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        coinManager.delegate = self
        
        currencyPicker.delegate = self
        currencyPicker.dataSource = self
    }
    
    
    
    
    func didUpdateWeather(_ coinManager: CoinManager, coin: CoinModel) {
        DispatchQueue.main.async {
            self.rateLabel.text = String(format: "%.3f", coin.rate)
            self.currencyLabel.text = coin.selectedCurrencyLabel
            self.btcImageView.isHidden = false
        }
    }
    
    func didFailWithError(error: Error) {
        print("Error")
    }
    
    
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return coinManager.currencyArray.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return coinManager.currencyArray[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedCurrency = coinManager.currencyArray[row]
        coinManager.getCoinPrice(for: selectedCurrency)
        
    }
}

