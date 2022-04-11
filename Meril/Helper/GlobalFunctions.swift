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
        
    static func showToast(controller: UIViewController, message : String, seconds: Double, completionHandler: (() -> ())? = nil) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: .actionSheet)
//        alert.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)        
//        alert.view.alpha = 0.6
        alert.view.layer.cornerRadius = 15

        controller.present(alert, animated: true)

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + seconds) {
            alert.dismiss(animated: true)
            completionHandler?()
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
            navController.navigationBar.tintColor = .white
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

func convertDateToString() -> String {
    let date = Date()
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"//Format: Y-m-d H:i:s:- 2022-03-25 03:15:00
    let str = dateFormatter.string(from: date)
    GlobalFunctions.printToConsole(message: "Current date string: \(str)")
    return str
}

func convertStringToDateStr(str: String?) -> String? {
    guard let passedStr = str else {
        return nil
    }
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat =  "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"//2022-03-26T12:56:58.000000Z"
    if let currentDate = dateFormatter.date(from: passedStr) {
        dateFormatter.dateFormat = "dd/MM/yy"//Format: Y-m-d H:i:s:- 2022-03-25 03:15:00
        let str = dateFormatter.string(from: currentDate)
        GlobalFunctions.printToConsole(message: "Current date string: \(str)")
        return str
    }
    return nil
}

//To store barcode object array
class UserSessionManager
{
    // MARK:- Properties

    public static var shared = UserSessionManager()

    var barCodes: [BarCodeModel]
    {
        get
        {
            guard let data = UserDefaults.standard.data(forKey: "scannedBarcodes") else { return [] }
            return (try? JSONDecoder().decode([BarCodeModel].self, from: data)) ?? []
        }
        set
        {
            guard let data = try? JSONEncoder().encode(newValue) else { return }
            UserDefaults.standard.set(data, forKey: "scannedBarcodes")
        }
    }
    
    var userDetail: UserData? {
        get {
            if let userInfo = UserDefaults.standard.string(forKey: "userDetails") {
                let userData = userInfo.data(using: .utf8)!
                do {
                    let json = try JSONDecoder().decode(UserData.self, from: userData)
                    GlobalFunctions.printToConsole(message: "logged in user detail:- \(json)")
                    return json
                } catch {
                    GlobalFunctions.printToConsole(message: error.localizedDescription)
                }
        }
            return nil
        }
        set {
            guard let user_data = try? JSONEncoder().encode(newValue) else { return }
            let convertedString = String(data: user_data, encoding: String.Encoding.utf8) // the data will be converted to the string
            UserDefaults.standard.set(convertedString, forKey: "userDetails")
        }
    }

    // MARK:- Init

    private init(){}
}

struct AddSurgeryInventory {
    func fetchSurgeryBySyncStatus() {
        let surgeryArr = AddSurgeryToCoreData.sharedInstance.fetchSurgeries() ?? []
        let group = DispatchGroup()
        for surgery in surgeryArr {
            if let addSurgeryObj = surgery.addSurgeryTempObj {
                group.enter()
                SurgeryServices.addSurgery(surgeryObj: addSurgeryObj) { response, error in
                    group.leave()
                    guard let _ = error else {
        //                delete record from core data if surgery sync successfully
                        AddSurgeryToCoreData.sharedInstance.deleteSergeryBySurgeryId(surgeryId: addSurgeryObj.surgeryId!)
                        NotificationCenter.default.post(name: .surgeryAdded, object: nil, userInfo: ["surgeryId": addSurgeryObj.surgeryId!])
                        return
                    }
                }
            }
        }
        group.notify(queue: .main) {
            NotificationCenter.default.post(name: .stopSyncBtnAnimation, object: nil, userInfo: nil)
            AddSurgeryInventory().fetchInventoryBySyncStatus()
            GlobalFunctions.printToConsole(message: "All request completed")
        }
    }
    
    func fetchInventoryBySyncStatus() {
        let stockArr = AddStockToCoreData.sharedInstance.fetchStocks() ?? []
        let stockGroup = DispatchGroup()
        for stock in stockArr {
            stockGroup.enter()
            SurgeryServices.addInventoryStock(surgeryObj: stock) { response, error in
                stockGroup.leave()
                guard let _ = error else {
                    //                delete record from core data if inventory sync successfully
                    AddStockToCoreData.sharedInstance.deleteStockByStockId(stockId: stock.stockId!)
                    NotificationCenter.default.post(name: .stockAdded, object: nil, userInfo: ["stockId": stock.stockId!])
                    return
                }
            }
        }
        stockGroup.notify(queue: .main) {
            GlobalFunctions.printToConsole(message: "All request completed")
            NotificationCenter.default.post(name: .stopSyncBtnAnimation, object: nil, userInfo: nil)
        }
    }
}
