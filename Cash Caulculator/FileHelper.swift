//
//  FileHelper.swift
//  Cash Caulculator
//
//  Created by Salamender Li on 5/9/19.
//  Copyright © 2019 Salamender Li. All rights reserved.
//

import Foundation

struct CurrencyBundle : Codable{
    var countryName:String
    var typeValueSet : [String:[AmountValuePair]]
    init(countryName:String,typeValueSet :[String:[AmountValuePair]]) {
        self.countryName = countryName
        self.typeValueSet = typeValueSet
    }
}


struct AmountValuePair: Codable{
    var value:String
    var Amount:Int
    init(value:String,Amount:Int) {
        self.value = value
        self.Amount = Amount
    }
}


class FileHelper {
    
    let defaultData  = CurrencyBundle(countryName: Constant.defaultCountry, typeValueSet:
        [Constant.bankNoteValueKey:[AmountValuePair(value: "100", Amount: 10),AmountValuePair(value: "50", Amount: 10),AmountValuePair(value: "20", Amount: 10),AmountValuePair(value: "10", Amount: 10),AmountValuePair(value: "5", Amount: 10)],
         Constant.coinValueKey:[AmountValuePair(value: "2", Amount: 10),AmountValuePair(value: "1", Amount: 10),AmountValuePair(value: "0.5", Amount: 10),AmountValuePair(value: "0.2", Amount: 10),AmountValuePair(value: "0.1", Amount: 10),AmountValuePair(value: "0.05", Amount: 10)]])
    
    func fileURl() -> URL?{
        let fileManager = FileManager.default
        guard let documentDirectoryUrl = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil}
        let fileUrl = documentDirectoryUrl.appendingPathComponent(Constant.countruCurrencyBundleSettingFile)
        return fileUrl
    }
    
    func saveJsonArray(currencyBundles:[CurrencyBundle]){


        let jsonEncoder = JSONEncoder()
        
        do{
            let json = try jsonEncoder.encode(currencyBundles)
            try json.write(to: fileURl()!)

        }catch let err{
            print(err)
        }
        
    }
    
    
    func getArrayFromJson() -> [CurrencyBundle]{
        let jsonDecoder = JSONDecoder()
        
        do {
            let data = try Data(contentsOf: fileURl()!)
            let currencyBundles = try jsonDecoder.decode([CurrencyBundle].self, from: data)
            return currencyBundles
        }catch let err{
            print(err)
            return []
        }
    }

    
    func  removeFile() {
        do {
            try FileManager.default.removeItem(at: fileURl()!)
        }catch let err{
            print(err)
        }
    }
    
    func generateDefaultValueAmountSet(currency:CountryCurrency) -> [String:[AmountValuePair]]{
        var typevalueAmountSet : [String:[AmountValuePair]] = [:]
        var bankNoteValueSet : [AmountValuePair] = []
        var coinValueSet : [AmountValuePair] = []
        for item in currency.bankNoteValue{
            bankNoteValueSet.append(AmountValuePair(value: "\(item)", Amount: Constant.defaultBundleNumber))
        }
        typevalueAmountSet[Constant.bankNoteValueKey] = bankNoteValueSet
        for item in currency.coinValue{
            coinValueSet.append(AmountValuePair(value: "\(item)", Amount: Constant.defaultBundleNumber))
        }
        typevalueAmountSet[Constant.coinValueKey] = coinValueSet
        
        return typevalueAmountSet
    }
    

}
