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
        navController.navigationBar.barTintColor = ColorConstant.mainThemeColor//UIColor(hexString: ColorConstant.mainThemeColor)
        navController.navigationBar.tintColor = .white
        navController.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navController.navigationBar.shadowImage = UIImage()
        navController.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20, weight: .medium)
        ]
        return navController
    }
    
    static func printToConsole(message : String) {
        #if DEBUG
            print(message)
        #endif
    }
}


