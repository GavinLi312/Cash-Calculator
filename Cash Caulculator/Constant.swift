//
//  Constant.swift
//  Cash Caulculator
//
//  Created by Salamender Li on 1/9/19.
//  Copyright © 2019 Salamender Li. All rights reserved.
//

import Foundation

class Constant{
    // Firebase Table Name
    static let TableName = "World Wide Currency"
    
    // The Default Country
    static let defaultCountry = "Australia"
    
    // Userdefault Key
    static let userDefaultKey = "Country"
    
    // MARK: - Country Currency json Keys
    
    static let bankNoteValueKey = "BankNote Value"
    static let codeKey = "Code"
    static let coinValueKey = "Coin Value"
    static let signKey = "Sign"
    
    
    // MARK: - CashCaulculatorTableView forCellReuseIdentifier
    static let cashCaulculatorTableViewforCellReuseIdentifier = "cashCaulculatorTableViewforCellReuseIdentifier"
    
    static let cashCaulculatorTableViewforFooterReuseIdentifier = "cashCaulculatorTableViewforFooterReuseIdentifier"
    
    //MARK: - ChangeCurrencyTableViewController
    static let changeCurrencyTableViewCellReuseIdentifier = "changeCurrencyTableViewCellReuseIdentifier"
    
    
    // MARK: - Default Bundle Number
    static let defaultBundleNumber = 10
    
    
    //MARK: - Menu Bar
    static let menuArray = ["Change Currency","Set Bundle ","Exit"]
    
    
    //MARK: - File name Country Currency bundle setting for note and coin
    static let countruCurrencyBundleSettingFile = "countruCurrencyBundleSettingFile.json"
    
}

