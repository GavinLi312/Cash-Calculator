//
//  UIColorExtension.swift
//  Cash Caulculator
//
//  Created by Salamender Li on 3/9/19.
//  Copyright © 2019 Salamender Li. All rights reserved.
//

import Foundation
import UIKit

extension UIColor{
    
    static let backgroundColor = UIColor(red: 252/256, green: 237/256, blue: 108/256, alpha: 1)
    
    static let fillcolor = UIColor(red: 54/256, green: 54/256, blue: 51/256, alpha: 1)
    
    static let strokeColor = UIColor(red: 215/256, green: 215/256, blue: 165/256, alpha: 1)
    
    static let shapeLayerColor =  UIColor(red: 165/256, green: 119/256, blue: 75/256, alpha: 1)
}


extension UIView{
    
    func addConstraintsWithFormat(format:String,views:UIView...){
        var viewsDictionary = [String:AnyObject]()
        //purpose is just to make the index unique
        for (index,view) in views.enumerated(){
            view.translatesAutoresizingMaskIntoConstraints = false
            let key = "v\(index)"
            viewsDictionary[key] = view
        }
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: viewsDictionary))
    }
    
    
    enum ViewSide {
        case Left, Right, Top, Bottom
    }
    
    //Add Border
    func addBorder(toSide side: ViewSide, withColor color: UIColor, andThickness thickness: CGFloat) {
        
        let border = UIView()
        border.backgroundColor = color
        border.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(border)
        
        switch side {
        case .Left:
            border.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
            border.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
            border.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
            border.widthAnchor.constraint(equalToConstant: thickness).isActive = true
        case .Right:
            border.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
            border.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
            border.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
            border.widthAnchor.constraint(equalToConstant: thickness).isActive = true
        case .Top:
            border.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
            border.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
            border.heightAnchor.constraint(equalToConstant: thickness).isActive = true
            border.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        case .Bottom:
            border.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
            border.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
            border.heightAnchor.constraint(equalToConstant: thickness).isActive = true
            border.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        }
        
    }
}


extension UIImage {
    func rotate(radians: CGFloat) -> UIImage {
        let rotatedSize = CGRect(origin: .zero, size: size)
            .applying(CGAffineTransform(rotationAngle: CGFloat(radians)))
            .integral.size
        UIGraphicsBeginImageContext(rotatedSize)
        if let context = UIGraphicsGetCurrentContext() {
            let origin = CGPoint(x: rotatedSize.width / 2.0,
                                 y: rotatedSize.height / 2.0)
            context.translateBy(x: origin.x, y: origin.y)
            context.rotate(by: radians)
            draw(in: CGRect(x: -origin.y, y: -origin.x,
                            width: size.width, height: size.height))
            let rotatedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            return rotatedImage ?? self
        }
        
        return self
    }
}
