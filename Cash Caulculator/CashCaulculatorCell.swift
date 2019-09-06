//
//  CashCaulculatorCell.swift
//  Cash Caulculator
//
//  Created by Salamender Li on 1/9/19.
//  Copyright © 2019 Salamender Li. All rights reserved.
//

import Foundation
import UIKit

class CashCaulculatorCell: UITableViewCell{
    
    
    var signLabel : CashCaulculatorLabel = {
        var label = CashCaulculatorLabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = NSTextAlignment.center
        return label
    }()
    
    var sign:String?
    
    var bundleValue : Int?
    
    var cellValue : Double?{
        didSet{
            changeSignLabel(value: cellValue!)
        }
    }
    
    var result : Double?{
        didSet{
            changeResultLabel(value: round(result!*100)/100)
        }
    }
    
    var noteNumberTextField : CashCaulculatorTextField = {
        var textField = CashCaulculatorTextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.text = ""
        return textField
    }()
    
    var bundleNumberTextField : CashCaulculatorTextField = {
        var textField = CashCaulculatorTextField()
        textField.adjustsFontSizeToFitWidth = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Bd(0)"
        textField.text = ""
        return textField
    }()
    
    var resultLabel : CashCaulculatorLabel = {
        var label = CashCaulculatorLabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = NSTextAlignment.center
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addviews()
        self.contentView.backgroundColor = UIColor.white.withAlphaComponent(0.95)
        self.backgroundColor = UIColor.backgroundColor
    }
    
    func addviews(){
        self.contentView.addSubview(signLabel)
        self.contentView.addSubview(noteNumberTextField)
        self.contentView.addSubview(bundleNumberTextField)
        self.contentView.addSubview(resultLabel)
        
        contentView.addConstraintsWithFormat(format: "H:|-8-[v0(v2)]-8-[v1(v2)]-16-[v2(v3)]-8-[v3]-8-|", views: signLabel,bundleNumberTextField,noteNumberTextField,resultLabel)
        contentView.addConstraintsWithFormat(format: "V:|-2-[v0]-2-|", views: signLabel)
        contentView.addConstraintsWithFormat(format: "V:|-2-[v0]-2-|", views: bundleNumberTextField)
        contentView.addConstraintsWithFormat(format: "V:|-2-[v0]-2-|", views: noteNumberTextField)
        contentView.addConstraintsWithFormat(format: "V:|-2-[v0]-2-|", views: resultLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    func changeSignLabel(value:Any){
        signLabel.text = "\(sign!)\(value) "
    }
    
    
    
    func changeResultLabel(value:Double) {
        resultLabel.text = "\(sign!)\(value)"
    }
}

class CashCaulculatorLabel: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.textColor = UIColor.fillcolor
        self.adjustsFontSizeToFitWidth = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//MARK: - CashCaulculatorTextField
class CashCaulculatorTextField: UITextField {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = 3
        self.layer.borderColor = UIColor.gray.cgColor
        self.layer.borderWidth = 0.5
        self.textAlignment = NSTextAlignment.center
        self.keyboardType = .numberPad
        self.placeholder = "0"
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


//MARK : - Footer View
class HeaderView:UITableViewHeaderFooterView{
    
    var value : Double?
    
    var titleLabel : CashCaulculatorLabel = {
        var label = CashCaulculatorLabel()
        label.textAlignment = .left
        label.adjustsFontSizeToFitWidth = true
        label.font = UIFont.boldSystemFont(ofSize: 15)
        return label
    }()
    
    var totalLabel : CashCaulculatorLabel = {
        var label = CashCaulculatorLabel()
        label.textAlignment = .right
        label.adjustsFontSizeToFitWidth = true
        label.font = UIFont.boldSystemFont(ofSize: 15)
        return label
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        addviews()
    }
    

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addviews(){
        addSubview(totalLabel)
        addSubview(titleLabel)
        addConstraintsWithFormat(format: "H:|-16-[v0(v1)]-16-[v1]-16-|", views: titleLabel,totalLabel)
        addConstraintsWithFormat(format: "V:|[v0]|", views: totalLabel)
        addConstraintsWithFormat(format: "V:|[v0]|", views: titleLabel)
    }
    
    func settotalValue(sign:String, value:Double) {
        self.value = value
        totalLabel.text = "Subtotal: \(sign)\(value)"
    }
    
    func setTitle(title:String){
        titleLabel.text = title
    }
    
}

//MARK: - Table Footer View

class TableFooterView: UIView {
    var alltotalLabel : CashCaulculatorLabel = {
        var label = CashCaulculatorLabel()
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textColor = UIColor.black
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addviews()
        self.backgroundColor = UIColor.backgroundColor
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addviews(){
        addSubview(alltotalLabel)
        addConstraintsWithFormat(format: "H:|[v0]|", views: alltotalLabel)
        addConstraintsWithFormat(format: "V:|[v0]|", views: alltotalLabel)
    }
    
    func settotalValue(sign:String, value:Double) {
        alltotalLabel.text = "Total: \(sign)\(value)"
    }
    
}


