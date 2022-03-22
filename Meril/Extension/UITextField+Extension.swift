//
//  UITextField+Extension.swift
//  Meril
//
//  Created by Nidhi Suhagiya on 21/03/22.
//

import UIKit

extension UITextField {
        
    func setIcon(imgName: String) {
       let iconView = UIImageView(frame:
                      CGRect(x: 10, y: 10, width: 20, height: 20))
       iconView.image = UIImage(named: imgName)
       let iconContainerView: UIView = UIView(frame:
                      CGRect(x: 20, y: 0, width: 40, height: 40))
       iconContainerView.addSubview(iconView)
       leftView = iconContainerView
       leftViewMode = .always
    }
    
//    func addImageViewToLeft(imgName: String) {
//        self.leftView = UIImageView(image: UIImage(named: imgName))
//        self.leftView?.frame = CGRect(x: 15, y: 5, width: 30 , height:30)
//        self.leftViewMode = .always
//    }
//
//    func addImageViewToRight(imgName: String) {
//        self.rightView = UIImageView(image: UIImage(named: imgName))
//        self.rightView?.frame = CGRect(x: self.frame.width - 35, y: 5, width: 30 , height:30)
//        self.rightViewMode = .always
//    }
    
    func setPlaceholder(placeHolderStr: String) {
        self.attributedPlaceholder = NSAttributedString(string: placeHolderStr, attributes: [
            NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.5)
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
