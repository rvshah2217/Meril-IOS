//
//  GlobalFunctions.swift
//  Meril
//
//  Created by Nidhi Suhagiya on 21/03/22.
//

import LGSideMenuController
import UIKit
import ChameleonFramework

struct GlobalFunctions {
    
    static func showToast(controller: UIViewController, message : String, seconds: Double) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: .actionSheet)
//        alert.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)        
//        alert.view.alpha = 0.6
        alert.view.layer.cornerRadius = 15

        controller.present(alert, animated: true)

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + seconds) {
            alert.dismiss(animated: true)
        }
    }
    
    static func setHomeVC() -> UIViewController {
        let homeVC = mainStoryboard.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
        let leftVC = sidemenuStoryboard.instantiateViewController(withIdentifier: "SideMenuVC") as! SideMenuVC
        let homeWithNavVC = setRootNavigationController(currentVC: homeVC)
        let sideMenuVC = LGSideMenuController(rootViewController: homeWithNavVC, leftViewController: leftVC, rightViewController: nil)
        sideMenuVC.leftViewPresentationStyle = .slideAboveBlurred
        return sideMenuVC
    }
    
    static func setRootNavigationController(currentVC: UIViewController) -> UINavigationController {
        let navController = UINavigationController(rootViewController: currentVC)
    
        navController.navigationBar.tintColor = .white
        configureStatusNavBar(navController: navController, bgColor: .white, textColor: ColorConstant.mainThemeColor)
        return navController
    }
    
    static func configureStatusNavBar(navController: UINavigationController, bgColor: UIColor, textColor: UIColor) {
        if #available(iOS 13.0, *) {
            let navBarAppearance = UINavigationBarAppearance()
            navBarAppearance.configureWithDefaultBackground()
            navBarAppearance.backgroundColor = bgColor
            navBarAppearance.shadowColor = .clear
            navBarAppearance.titleTextAttributes = [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20, weight: .medium),
                NSAttributedString.Key.foregroundColor: textColor
            ]
            navController.navigationBar.isTranslucent = false
            navController.navigationBar.scrollEdgeAppearance = navBarAppearance
            navController.navigationBar.standardAppearance = navBarAppearance
        } else {
            navController.navigationBar.setBackgroundImage(UIImage(), for: .default)
            navController.navigationBar.shadowImage = UIImage()
            navController.navigationBar.barTintColor = bgColor//UIColor(hexString: ColorConstant.mainThemeColor)
            navController.navigationBar.titleTextAttributes = [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20, weight: .medium),
                NSAttributedString.Key.foregroundColor: textColor
            ]

        }
    }
    
    static func printToConsole(message : String) {
        #if DEBUG
            print(message)
        #endif
    }
}
let NAVIGATION_BAR_HEIGHT:CGFloat = 64
let SCREEN_HEIGHT = UIScreen.main.bounds.size.height
let SCREEN_WIDTH = UIScreen.main.bounds.size.width
let appDelegate = UIApplication.shared.delegate as! AppDelegate

//Check IsiPhone Device
func IS_IPHONE_DEVICE()->Bool{
    let deviceType = UIDevice.current.userInterfaceIdiom == .phone
    return deviceType
}

//Check IsiPad Device
func IS_IPAD_DEVICE()->Bool{
    let deviceType = UIDevice.current.userInterfaceIdiom == .pad
    return deviceType
}


//iPhone 4 OR 4S
func IS_IPHONE_4_OR_4S()->Bool{
    let SCREEN_HEIGHT_TO_CHECK_AGAINST:CGFloat = 480
    var device:Bool = false
    
    if(SCREEN_HEIGHT_TO_CHECK_AGAINST == SCREEN_HEIGHT)    {
        device = true
    }
    return device
}

//iPhone 5 OR OR 5C OR 4S
func IS_IPHONE_5_OR_5S()->Bool{
    let SCREEN_HEIGHT_TO_CHECK_AGAINST:CGFloat = 568
    var device:Bool = false
    if(SCREEN_HEIGHT_TO_CHECK_AGAINST == SCREEN_HEIGHT)    {
        device = true
    }
    return device
}

//iPhone 6 OR 6S
func IS_IPHONE_6_OR_6S()->Bool{
    let SCREEN_HEIGHT_TO_CHECK_AGAINST:CGFloat = 667
    var device:Bool = false
    
    if(SCREEN_HEIGHT_TO_CHECK_AGAINST == SCREEN_HEIGHT)    {
        device = true
    }
    return device
}

//iPhone 6Plus OR 6SPlus
func IS_IPHONE_6P_OR_6SP()->Bool{
    let SCREEN_HEIGHT_TO_CHECK_AGAINST:CGFloat = 736
    var device:Bool = false
    
    if(SCREEN_HEIGHT_TO_CHECK_AGAINST == SCREEN_HEIGHT)    {
        device = true
    }
    return device
}
//iPhone X
func IS_IPHONE_X()->Bool{
    let SCREEN_HEIGHT_TO_CHECK_AGAINST:CGFloat = 812
    var device:Bool = false
    
    if(SCREEN_HEIGHT_TO_CHECK_AGAINST <= SCREEN_HEIGHT)    {
        device = true
    }
    return device
}

//iPhone Xr
func IS_IPHONE_XR()->Bool{
    let SCREEN_HEIGHT_TO_CHECK_AGAINST:CGFloat = 896
    var device:Bool = false
    
    if(SCREEN_HEIGHT_TO_CHECK_AGAINST == SCREEN_HEIGHT)    {
        device = true
    }
    return device
}
//iPhone Pro Max
func IS_IPHONE_PRO_MAX()->Bool{
    let SCREEN_HEIGHT_TO_CHECK_AGAINST:CGFloat = 896
    var device:Bool = false
    
    if(SCREEN_HEIGHT_TO_CHECK_AGAINST == SCREEN_HEIGHT)    {
        device = true
    }
    return device
}
func setLeftButton(_ textField: UITextField, image: UIImage) {
    let imageView = UIImageView(frame: CGRect(x: CGFloat(10), y: CGFloat(0), width: CGFloat(30), height: CGFloat(30)))
    let view = UIView(frame: CGRect(x: 10, y: 0, width: 45, height: 30))
    view.contentMode = .center
    imageView.image = image
    imageView.contentMode = .center
    textField.leftViewMode = .always
    view.addSubview(imageView)
    textField.leftView = view
}
   
func setRightButton(_ textField: UITextField, image: UIImage) {
    let imageView = UIImageView(frame: CGRect(x: CGFloat(-10), y: CGFloat(0), width: CGFloat(15), height: CGFloat(9)))
    let view = UIView(frame: CGRect(x: -10, y: 0, width: 15, height: 9))
    view.contentMode = .center
    imageView.image = image
    imageView.contentMode = .center
    textField.rightViewMode = .always
    view.addSubview(imageView)
    textField.rightView = view
    textField.rightView?.isUserInteractionEnabled = false
}
