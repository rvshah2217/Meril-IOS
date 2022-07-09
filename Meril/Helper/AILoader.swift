//
//  AILoader.swift
//
//  Created by Ravi Alagiya on 13/05/17.
//  Copyright © 2016 Agile Infoways. All rights reserved.
//

import UIKit
//import NVActivityIndicatorView
import FullMaterialLoader

var indicator: MaterialLoadingIndicator!

func configViews() {
    let activityContainer: UIView = UIView(frame: CGRect(x:0, y:0,width:SCREEN_WIDTH, height:SCREEN_HEIGHT))
    activityContainer.backgroundColor = UIColor.black.withAlphaComponent(0.5)
    activityContainer.restorationIdentifier = activityRestorationIdentifier
    
    indicator = MaterialLoadingIndicator(frame: CGRect(x:0, y:0, width: 56, height: 56))
    indicator.indicatorColor = [ColorConstant.mainThemeColor.cgColor, UIColor.red.cgColor]
    indicator.center = activityContainer.center
    indicator.isHidden = false
    activityContainer.addSubview(indicator)
    UIApplication.shared.keyWindow?.isUserInteractionEnabled = false
    UIApplication.shared.keyWindow?.addSubview(indicator)
    indicator.startAnimating()
}

private var activityRestorationIdentifier: String {
    return "NVActivityIndicatorViewContainer"
}

public func ShowLoaderWithMessage(message:String) {
    startActivityAnimating(size: CGSize(width:44, height:44), message: message, color: ColorConstant.mainThemeColor, padding: 2,isFromOnView: false)
}

//MARK:- ShowLoader

public func SHOW_CUSTOM_LOADER() {
    startActivityAnimating(size: CGSize(width:44, height:44), message: nil , color: ColorConstant.mainThemeColor, padding: 2,isFromOnView: false)
}

//MARK:- Hide Loader

public func HIDE_CUSTOM_LOADER() {
    stopActivityAnimating(isFromOnView: false)
}

//MARK:- ShowLoaderOnView

public func ShowLoaderOnView() {
    startActivityAnimating(size: CGSize(width:44, height:44), message: nil , color: ColorConstant.mainThemeColor, padding: 2,isFromOnView: true)
}

//MARK:- HideLoaderOnView
public func HideLoaderOnView() {
    stopActivityAnimating(isFromOnView: true)
}

private func startActivityAnimating(size: CGSize? = nil, message: String? = nil , color: UIColor? = nil, padding: CGFloat? = nil, isFromOnView:Bool) {
    let activityContainer: UIView = UIView(frame: CGRect(x:0, y:0,width:SCREEN_WIDTH, height:SCREEN_HEIGHT))
    activityContainer.backgroundColor = UIColor.black.withAlphaComponent(0.5)
    activityContainer.restorationIdentifier = activityRestorationIdentifier
    
    activityContainer.isUserInteractionEnabled = false
    let actualSize = size ?? CGSize(width:56,height:56)
    
    //    let activityIndicatorView = NVActivityIndicatorView(
    //        frame: CGRect(x:0, y:0, width:actualSize.width, height:actualSize.height),
    //        type: type!,
    //        color: color!,
    //        padding: padding!)
    
    indicator = MaterialLoadingIndicator(frame: CGRect(x:0, y:0, width: 56, height: 56))
    indicator.indicatorColor = [ColorConstant.mainThemeColor.cgColor, UIColor.yellow.cgColor, UIColor.red.cgColor]
    indicator.center = activityContainer.center
    indicator.isHidden = false
    
    indicator.center = activityContainer.center
    indicator.startAnimating()
    activityContainer.addSubview(indicator)
    
    if message != nil {
        let width = activityContainer.frame.size.width / 2
        if let message = message , !message.isEmpty {
            let label = UILabel(frame: CGRect(x:0, y:0,width:width, height:30))
            label.center = CGPoint(
                x:indicator.center.x, y:
                    indicator.center.y + actualSize.height)
            label.textAlignment = .center
            label.text = message
//            label.font = UIFont.appFont_Poppins_Regular_WithSize(16.0)
            label.textColor = .white
            activityContainer.addSubview(label)
        }
    }
    UIApplication.shared.keyWindow?.isUserInteractionEnabled = false
    
    for item in (UIApplication.shared.keyWindow?.subviews)!
    where item.restorationIdentifier == activityRestorationIdentifier {
        return
    }
    
    if isFromOnView == true {
        UIApplication.shared.keyWindow?.rootViewController?.view.addSubview(activityContainer)
    } else {
        UIApplication.shared.keyWindow?.addSubview(activityContainer)
    }
}

/**
 Stop animation and remove from view hierarchy.
 */
private func stopActivityAnimating(isFromOnView:Bool) {
    UIApplication.shared.keyWindow?.isUserInteractionEnabled = true
    if isFromOnView == true {
        for item in (UIApplication.shared.keyWindow?.rootViewController?.view.subviews)!
        where item.restorationIdentifier == activityRestorationIdentifier {
            item.removeFromSuperview()
            indicator.isHidden = true
            indicator.stopAnimating()
        }
    } else {
        if UIApplication.shared.keyWindow != nil{
            for item in (UIApplication.shared.keyWindow?.subviews)!
            where item.restorationIdentifier == activityRestorationIdentifier {
                item.removeFromSuperview()
                indicator.isHidden = true
                indicator.stopAnimating()
            }
        }
    }
}
