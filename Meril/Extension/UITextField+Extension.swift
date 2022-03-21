//
//  UITextField+Extension.swift
//  Meril
//
//  Created by Nidhi Suhagiya on 21/03/22.
//

import UIKit

extension UITextField {
        
    func addImageViewToLeft(imgName: String) {
        self.leftView = UIImageView(image: UIImage(named: imgName))
        self.leftView?.frame = CGRect(x: 5, y: 5, width: 30 , height:30)
        self.leftViewMode = .always
    }
    
    func addImageViewToRight(imgName: String) {
        self.rightView = UIImageView(image: UIImage(named: imgName))
        self.rightView?.frame = CGRect(x: self.frame.width - 35, y: 5, width: 30 , height:30)
        self.rightViewMode = .always
    }
    
    func setPlaceholder(placeHolderStr: String) {
        self.attributedPlaceholder = NSAttributedString(string: placeHolderStr, attributes: [
            NSAttributedString.Key.foregroundColor: UIColor.white
        ]
)
    }
}

extension UIView {
    
    func setViewCorner(radius: CGFloat) {
        self.layer.cornerRadius = radius
    }
    
    func addBorderToView(borderWidth: CGFloat, borderColor: UIColor) {
        self.layer.borderColor = borderColor.cgColor
        self.layer.borderWidth = borderWidth
    }
}
