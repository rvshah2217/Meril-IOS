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
    
    func setPlaceholder(placeHolderStr: String, textColor: UIColor = .white) {
        self.attributedPlaceholder = NSAttributedString(string: placeHolderStr, attributes: [
            NSAttributedString.Key.foregroundColor: textColor.withAlphaComponent(0.5)
        ]
        )
    }
}

extension UIView {
    
    func rotate() {
        let rotation : CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.toValue = NSNumber(value: Double.pi * 2)
        rotation.duration = 4
        rotation.isCumulative = true
        rotation.repeatCount = Float.greatestFiniteMagnitude
        self.layer.add(rotation, forKey: "rotationAnimation")
    }
    
    func stopRotation() {
        self.layer.removeAnimation(forKey: "rotationAnimation")
    }
    
    func addShadowPath(radius: CGFloat){
        self.layer.cornerRadius = radius
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
    static let surgeryAdded = Notification.Name("SurgeryAddedNotification")
    static let stockAdded = Notification.Name("StockAddedNotification")
    static let stopSyncBtnAnimation = Notification.Name("stopSyncBtnAnimation")
}

