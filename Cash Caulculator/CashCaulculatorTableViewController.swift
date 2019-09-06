//
//  CashCaulculatorViewController.swift
//  Cash Caulculator
//
//  Created by Salamender Li on 1/9/19.
//  Copyright © 2019 Salamender Li. All rights reserved.
//

import Foundation
import UIKit

// myBarButtonItem to pass UITExtField
class myBarButtonItem: UIBarButtonItem {
    var passedUITextField:UITextField?
}


class CashCaulculatorTableViewController: UITableViewController,UITextFieldDelegate,NewCountrySelected,MenuButtonProtocol{

    var fileHelper = FileHelper()
    
    var currencyBundles : [CurrencyBundle] = []
    
    var currencyBundle : CurrencyBundle?
    
    var countryCurrency: CountryCurrency?
    
    var countryCurrencies: [CountryCurrency]?
    
    lazy var sectionHeaderViews : [Int:HeaderView] = [:]
    
    lazy var cashCaulculatorcells : [IndexPath: CashCaulculatorCell] = [:]
    
    lazy var textsForAlls:[IndexPath:[CashCaulculatorTextField:String]] = [:]
    
    override func viewDidLoad() {

        currencyBundles = fileHelper.getArrayFromJson()
        setCurrencyBundle()
        self.navigationController?.navigationBar.barTintColor = UIColor.backgroundColor
        self.navigationController?.navigationBar.tintColor = UIColor.fillcolor
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.tableView.sectionHeaderHeight = 50
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorColor = UIColor.fillcolor
        self.view.backgroundColor = UIColor.backgroundColor
        let tableFooterView = TableFooterView(frame: CGRect(x: 0, y: 0, width: 0, height: 50))
        tableFooterView.settotalValue(sign: self.countryCurrency!.sign, value: 0.0)
        tableView.tableFooterView = tableFooterView
        tableView.register(CashCaulculatorCell.self, forCellReuseIdentifier: Constant.cashCaulculatorTableViewforCellReuseIdentifier)
        tableView.register(HeaderView.self, forHeaderFooterViewReuseIdentifier: Constant.cashCaulculatorTableViewforFooterReuseIdentifier)
        tableView.allowsSelection = false
    }
    
    fileprivate func setCurrencyBundle() {
        currencyBundle =  currencyBundles.filter({ (bundle) -> Bool in
            bundle.countryName == countryCurrency?.countryName
        }).first
        
        if currencyBundle == nil {
            currencyBundle = CurrencyBundle(countryName: countryCurrency!.countryName, typeValueSet:fileHelper.generateDefaultValueAmountSet(currency: countryCurrency!))
            currencyBundles.append(currencyBundle!)
            fileHelper.saveJsonArray(currencyBundles: currencyBundles)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setNavigationControllerTitle(title: countryCurrency!.countryName)
        setNavigationItem()
        
        setCurrencyBundle()

    }
    
    /// Set navigation Bar Title
    func setNavigationControllerTitle(title: String){
        self.navigationItem.title = title
    }
    
    /// set navigation Bar
    func setNavigationItem(){
        let menuButton = UIBarButtonItem(title: "Menu", style: .plain, target: self, action: #selector(menuPressed))
        let cancelButton = UIBarButtonItem(title: "Clear", style: .plain, target: self, action: #selector(cancelPressed))

        self.navigationItem.setRightBarButton(cancelButton, animated: false)
        self.navigationItem.setLeftBarButton(menuButton, animated: false)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return (countryCurrency?.bankNoteValue.count)!
        case 1:
            return (countryCurrency?.coinValue.count)!
        default:
            print("Should Not happen")
            return 0
        }
    }
    
    
    // cell for table view cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: Constant.cashCaulculatorTableViewforCellReuseIdentifier, for: indexPath) as! CashCaulculatorCell
            cell.sign = countryCurrency?.sign
            cell.cellValue = Double((countryCurrency?.bankNoteValue[indexPath.row])!)
            if textsForAlls[indexPath] == nil{
                var textFieldStringArray : [CashCaulculatorTextField:String] = [:]
                textFieldStringArray[cell.bundleNumberTextField] = ""
                textFieldStringArray[cell.noteNumberTextField] = ""
                textsForAlls[indexPath] = textFieldStringArray
                cell.result = 0
            }
            cell.noteNumberTextField.delegate = self
            cell.bundleNumberTextField.delegate = self
            cell.bundleValue = currencyBundle?.typeValueSet[Constant.bankNoteValueKey]![indexPath.row].Amount
            self.cashCaulculatorcells[indexPath] = cell
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: Constant.cashCaulculatorTableViewforCellReuseIdentifier, for: indexPath) as! CashCaulculatorCell
            cell.sign = countryCurrency?.sign
            cell.cellValue = countryCurrency?.coinValue[indexPath.row]
            
            if textsForAlls[indexPath] == nil{
                var textFieldStringArray : [CashCaulculatorTextField:String] = [:]
                textFieldStringArray[cell.bundleNumberTextField] = ""
                textFieldStringArray[cell.noteNumberTextField] = ""
                textsForAlls[indexPath] = textFieldStringArray
                cell.result = 0
            }
            cell.bundleValue = currencyBundle?.typeValueSet[Constant.coinValueKey]![indexPath.row].Amount
            cell.noteNumberTextField.delegate = self
            cell.bundleNumberTextField.delegate = self
            self.cashCaulculatorcells[indexPath] = cell
            return cell
        default:
            print("Should not happen")
            return tableView.dequeueReusableCell(withIdentifier: Constant.cashCaulculatorTableViewforCellReuseIdentifier, for: indexPath)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func createToolBar(textField:UITextField){
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let done = myBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(donePressed(sender:)))
        let previous =  myBarButtonItem(title: "Prev", style: .plain, target: self, action: #selector(previousPressed(sender:)))
        //(barButtonSystemItem: , target: self, action: #selector(cancelPressed))
        previous.passedUITextField = textField
        let next =  myBarButtonItem(title: "Next", style: .plain, target: self, action:  #selector(nextPressed(sender:)))
        next.passedUITextField = textField
        
        let space =  myBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        done.passedUITextField = textField
        toolbar.setItems([previous,next,space,done],animated:false)
        textField.inputAccessoryView = toolbar
    }
    
    @objc func donePressed(sender:myBarButtonItem){
        textFieldDidEndEditing(sender.passedUITextField!)
        textFieldShouldReturn(sender.passedUITextField!)
    }
    
    @objc func cancelPressed(){
        for cell in cashCaulculatorcells.values{
            cell.noteNumberTextField.text  = ""
            cell.bundleNumberTextField.text = ""
            cell.result = 0.0
        }
        
        for i in 0...tableView.numberOfSections-1{
            setfooterViewValue(i, 0)
        }
        setTableFooterViewValue()
    }
    
    @objc func menuPressed(sender:myBarButtonItem){
        let vc = MenuViewController()
        //enforce the view ending editing
        view.endEditing(true)
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        vc.menuButtonClickedProtocol = self
        self.present(vc, animated: true, completion: nil)
    }
    
    /// previous Button pressed, move to the previous textfield
    @objc func previousPressed(sender:myBarButtonItem){
        let indexpath = self.findTextFieldIndexPath(textField: sender.passedUITextField as! CashCaulculatorTextField)
        guard let previousIndexPath = findPreviousIndexPath(indexpath: indexpath!) else{
            return
        }
        let previousCell = self.cashCaulculatorcells[previousIndexPath]
        textFieldDidEndEditing(sender.passedUITextField!)
        textFieldShouldReturn(sender.passedUITextField!)
        previousCell?.noteNumberTextField.becomeFirstResponder()
        tableView.selectRow(at: previousIndexPath, animated: true, scrollPosition: .none)
    }
    
    /// Move to another viewcontroller Change Currency
    @objc func changeCurrency() {
        
        let viewcontroller = ChangeCurrencyTableViewController()
        viewcontroller.countryCurrencies = self.countryCurrencies?.sorted(by: {
            $0.countryName < $1.countryName
        })
        
        viewcontroller.newCountry = self
        navigationController?.pushViewController(viewcontroller, animated: true)
    }
    
    ///
    func findPreviousIndexPath(indexpath:IndexPath) -> IndexPath?{
        var indexpathSet = cashCaulculatorcells.keys.sorted {
            if $0.section != $1.section{
                return $0.section < $1.section
            }else{
                return $0.row < $1.row
            }
        }
        if indexpath == indexpathSet.first{
            return nil
        }else{
            let previousIndexPath = indexpathSet[indexpathSet.firstIndex(of: indexpath)! - 1]
            return previousIndexPath
        }
    }
    
    func findNextIndexPath(indexpath:IndexPath) -> IndexPath?{
        var indexpathSet = cashCaulculatorcells.keys.sorted {
            if $0.section != $1.section{
                return $0.section < $1.section
            }else{
                return $0.row < $1.row
            }
        }
        if indexpath == indexpathSet.last{
            return nil
        }else{
            let previousIndexPath = indexpathSet[indexpathSet.firstIndex(of: indexpath)! + 1]
            return previousIndexPath
        }
    }
    
    /// Next Button Pressed, will move to the next textfield
    @objc func nextPressed(sender:myBarButtonItem) {
        let indexpath = self.findTextFieldIndexPath(textField: sender.passedUITextField as! CashCaulculatorTextField)
        guard let nextIndexPath = findNextIndexPath(indexpath: indexpath!) else{
            return
        }
        let nextCell = self.cashCaulculatorcells[nextIndexPath]
        textFieldDidEndEditing(sender.passedUITextField!)
        textFieldShouldReturn(sender.passedUITextField!)
        nextCell?.noteNumberTextField.becomeFirstResponder()
    }
    
    /// find
    /// need to be changed
    func findTextFieldIndexPath(textField:CashCaulculatorTextField) -> IndexPath?{
        
       let cashCell =  self.cashCaulculatorcells.filter {
        if $0.value.noteNumberTextField == textField{
            return true
        }else if $0.value.bundleNumberTextField == textField{
            return true
        }else{
            return false
        }}
   
        return cashCell.first?.key
    }
    
    /// create tool bar when text Fieldbegin editing
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        createToolBar(textField: textField)
        return true
    }
    
    
    
    fileprivate func getTextFieldContent(_ range: NSRange, _ textField: UITextField, _ string: String) -> String {
        var text = ""
        switch range.length {
        case 0:
            text = "\(textField.text!)\(string)"
        case 1:
            var temp = textField.text
            temp?.popLast()
            text = temp!
        default:
            print("should not happen")
        }
        return text
    }
    
    ///
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard let superview = textField.superview?.superview as? CashCaulculatorCell else {
            print("error")
            return true
        }
        
        var bundleNumber : String?
        var noteNumber : String?
        
        switch textField {
            case superview.bundleNumberTextField:
                bundleNumber = getTextFieldContent(range, textField, string)
                if bundleNumber!.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
                    bundleNumber = "0"
                }
                noteNumber = superview.noteNumberTextField.text
                if noteNumber!.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
                    noteNumber = "0"
                }
            
            case superview.noteNumberTextField:
                noteNumber = getTextFieldContent(range, textField, string)
                if noteNumber!.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
                    noteNumber = "0"
                }
                bundleNumber = superview.bundleNumberTextField.text
                if bundleNumber!.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
                    bundleNumber = "0"
                }

            default:
                print("this doesn't work")
        }
        
        if bundleNumber!.count >= 6 || noteNumber!.count >= 6{
                return false
            }
    
        guard let _ = Double(bundleNumber!), let _ = Double(noteNumber!) else {
                print("error")
                return false
            }
        
        //var text  = getTextFieldContent(range, textField, string)

        let noteValue = (Double(bundleNumber!)! * Double(superview.bundleValue!) + (Double(noteNumber!)!))
        superview.result = (round(noteValue * superview.cellValue!*100)/100)
        return true
    }
    

    
    fileprivate func setfooterViewValue(_ section: Int, _ result: Double) {
        // tableView
        let footerView = self.sectionHeaderViews[section]
        footerView!.settotalValue(sign: countryCurrency!.sign, value: result)
    }
    
    func setTableFooterViewValue(){
        var totalResult = 0.0
        
        for view in sectionHeaderViews.values{
            totalResult += view.value!
        }
        
        guard let tableFooterView = tableView.tableFooterView as? TableFooterView else {
            print("error")
            return
        }
        tableFooterView.settotalValue(sign: countryCurrency!.sign, value: totalResult)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) != ""{
            guard let num = Int(textField.text!) else { return}
            if num == 0{
                textField.text = ""
            }else{
                textField.text = "\(num)"
            }
        }
        
        guard let indexpath = self.findTextFieldIndexPath(textField: textField as! CashCaulculatorTextField) else{
            print("Error")
            return
        }
        
        var result = 0.0
        let numberOfRows =  tableView.numberOfRows(inSection: indexpath.section)
        for i in 0...numberOfRows - 1{
            let indexpath = IndexPath(row: i, section: indexpath.section)
            let counterCell = self.cashCaulculatorcells[indexpath]
            result += counterCell!.result!
        }
        
        result = round(result*100)/100
        
        
        
        textsForAlls[indexpath]?[textField as! CashCaulculatorTextField] = textField.text
        setfooterViewValue(indexpath.section, result)
        setTableFooterViewValue()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: Constant.cashCaulculatorTableViewforFooterReuseIdentifier) as! HeaderView
        sectionHeaderViews[section] = headerView
        
        if headerView.value == nil{
            headerView.settotalValue(sign: countryCurrency!.sign, value: 0)
        }
        switch section {
        case 0:
            headerView.setTitle(title: Constant.bankNoteValueKey)
        case 1:
            headerView.setTitle(title: Constant.coinValueKey)
        default:
            print("Should not happen")
        }
        return headerView
    }
    

    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        var cellView = cell as! CashCaulculatorCell
        if textsForAlls[indexPath] != nil{
            cellView.noteNumberTextField.text = textsForAlls[indexPath]![cellView.noteNumberTextField]
            cellView.bundleNumberTextField.text = textsForAlls[indexPath]![cellView.bundleNumberTextField]
        }
        if cellView.noteNumberTextField.text == "" && cellView.bundleNumberTextField.text == ""{
            cellView.result = 0.0
        }else{
            var noteValue: Double?
            if cellView.noteNumberTextField.text == ""{
                noteValue = 0
            }else{
                noteValue = Double(cellView.noteNumberTextField.text!)!
            }
            var bundleValue: Double?
            if cellView.bundleNumberTextField.text == ""{
                bundleValue = 0
            }else{
                bundleValue = Double(cellView.bundleNumberTextField.text!)!
            }

            let Value = (bundleValue! * Double(cellView.bundleValue!) + noteValue!)
            cellView.result = (round(Value * cellView.cellValue!*100)/100)
        }
    }
    
    
    
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let cellView = cell as! CashCaulculatorCell
        if cellView.noteNumberTextField.isFirstResponder{

            textFieldDidEndEditing(cellView.noteNumberTextField)
            textFieldShouldReturn(cellView.noteNumberTextField)
            cellView.noteNumberTextField.resignFirstResponder()
        }
        
        if cellView.bundleNumberTextField.isFirstResponder{
            textFieldDidEndEditing(cellView.bundleNumberTextField)
            textFieldShouldReturn(cellView.bundleNumberTextField)
            cellView.bundleNumberTextField.resignFirstResponder()
        }
        
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 50
    }
    
    
    func newCountrySelected(countryCurrency: CountryCurrency) {
        self.countryCurrency = countryCurrency
        let userDefault = UserDefaults()
        userDefault.setValue(countryCurrency.countryName, forKey: Constant.userDefaultKey)
        cancelPressed()
        self.cashCaulculatorcells.removeAll()
        self.textsForAlls.removeAll()
        tableView.reloadData()
    }
    
    
    func menuButtonClicked(option: menuButtons) {
        switch option {
            case .changeCurrency:
                changeCurrency()
            case .setBundle:
                print("not coming yet")
        }
    }
    
    


}





