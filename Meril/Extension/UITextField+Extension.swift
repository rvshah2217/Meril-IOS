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
    
    func addShadowPath(radius: CGFloat){
        self.layer.cornerRadius = radius
//        self.borderColor = UIColor.colorFromHex("#cccccc")
//        self.borderWidth = 1
        let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: radius)
        self.clipsToBounds = true
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 0);
        layer.shadowOpacity = 0.7
        layer.shadowPath = shadowPath.cgPath
    }
    
    func addCornerAtTops(radius: CGFloat) {
        self.clipsToBounds = true
        self.layer.cornerRadius = radius
        if #available(iOS 11.0, *) {
            self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        } else {
            self.roundCorners(corners: [.topLeft, .topRight], radius: radius)
        }
    }
    
    
    func addCornerAtBotttoms(radius: CGFloat) {
        self.clipsToBounds = true
        self.layer.cornerRadius = radius
        if #available(iOS 11.0, *) {
            self.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        } else {
            self.roundCorners(corners: [.bottomLeft, .bottomRight], radius: radius)
        }
    }
    
    private func roundCorners(corners: UIRectCorner, radius: CGFloat) {
           let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
           let mask = CAShapeLayer()
           mask.path = path.cgPath
           layer.mask = mask
       }
    
    func setViewCorner(radius: CGFloat) {
        self.layer.cornerRadius = radius
    }
    
    func addBorderToView(borderWidth: CGFloat, borderColor: UIColor) {
        self.layer.borderColor = borderColor.cgColor
        self.layer.borderWidth = borderWidth
    }
}

extension Date {
    static var currentTimeStamp: Int64{
        return Int64(Date().timeIntervalSince1970 * 1000)
    }
}

extension Dictionary {
    func jsonString() -> String? {
        let jsonData = try? JSONSerialization.data(withJSONObject: self, options: [])
        guard jsonData != nil else {return nil}
        let jsonString = String(data: jsonData!, encoding: .utf8)
        guard jsonString != nil else {return nil}
        return jsonString//! as NSString
    }

}

extension Notification.Name {
    static let networkLost = Notification.Name("InternetConnectionLost")
}
