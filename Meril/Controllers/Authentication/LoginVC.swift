//
//  LoginVC.swift
//  Meril
//
//  Created by Nidhi Suhagiya on 21/03/22.
//

//import iOSDropDown
import UIKit
import Alamofire
import CoreData

class LoginVC: UIViewController {
    
    @IBOutlet weak var userNameTxt: UITextField! {
        didSet {
            self.userNameTxt.setViewCorner(radius: self.userNameTxt.frame.height/2)
            self.userNameTxt.addBorderToView(borderWidth: 1.0, borderColor: .white)
            self.userNameTxt.setPlaceholder(placeHolderStr: "Username")
            self.userNameTxt.setIcon(imgName: "ic_user")//addImageViewToLeft(imgName: "ic_user")
        }
    }
    
    @IBOutlet weak var passwordTxt: UITextField! {
        didSet {
            self.passwordTxt.setIcon(imgName: "ic_passwordLock")
            self.passwordTxt.setPlaceholder(placeHolderStr: "Password")
            self.passwordTxt.addBorderToView(borderWidth: 1.0, borderColor: .white)
            self.passwordTxt.setViewCorner(radius: self.passwordTxt.frame.height/2)
        }
    }
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var forgotPasswordBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
    }
    
    func setUI() {
        GlobalFunctions.configureStatusNavBar(navController: self.navigationController!, bgColor: ColorConstant.mainThemeColor, textColor: .white)
        
        //        set rounded corner
        self.loginBtn.setViewCorner(radius: self.loginBtn.frame.height/2)
        self.forgotPasswordBtn.isHidden = true
    }
    
    @IBAction func forgotPasswordBtnClicked(_ sender: Any) {
    }
    
    @IBAction func loginBtnClicked(_ sender: Any) {
        self.fieldsValidation()
    }
}

//#MARK: Input validation and Api Calls
extension LoginVC {
    
    func fieldsValidation() {
        //        guard let userTypeId = selectedUserTypeId else { return }
        let userNameStr = userNameTxt.text ?? ""
        let passwordStr = passwordTxt.text ?? ""
        
        if !Validation.sharedInstance.checkLength(testStr: passwordStr) {
            GlobalFunctions.showToast(controller: self, message: "Please enter username", seconds: errorDismissTime, completionHandler: {})
            return
        }
        
        if !Validation.sharedInstance.checkLength(testStr: passwordStr) {
            GlobalFunctions.showToast(controller: self, message: "Please enter password", seconds: errorDismissTime, completionHandler: {})
            return
        }
        
        let obj = LoginRequestModel(username: userNameStr, password: passwordStr, fcmToken: deviceToken)
        self.callUserLoginApi(userObj: obj)
    }
    
    func callUserLoginApi(userObj: LoginRequestModel) {
        if appDelegate.reachability.connection == .unavailable {
            GlobalFunctions.showToast(controller: self, message: UserMessages.noInternetConnection, seconds: errorDismissTime) { }
            return
        }
        
        SHOW_CUSTOM_LOADER()
        LoginServices.userLogin(loginObj: userObj) { loginResponse, errorMessage in
            HIDE_CUSTOM_LOADER()
            guard let response = loginResponse else {
                GlobalFunctions.showToast(controller: self, message: errorMessage ?? UserMessages.serverError, seconds: errorDismissTime) { }
                return
            }
            
            
            //            store user data into UserDefaults
            UserSessionManager.shared.userDetail = response.loginUserData?.user_data
            
            let isDefaultPassword = (response.loginUserData?.is_default_password == 1) ? true : false
            UserDefaults.standard.set(isDefaultPassword, forKey: "isDefaultPassword")
            UserDefaults.standard.set(response.loginUserData?.token, forKey: "headerToken")
            UserDefaults.standard.set(response.loginUserData?.user_type_id, forKey: "userTypeId")
            
            //            save loggedin user's surgeries and stocks in local database
            SurgeryList_CoreData.sharedInstance.saveSurgeriesToCoreData(schemeData: response.loginUserData?.surgeries ?? [], isForceSave: true)
            StockList_CoreData.sharedInstance.saveStocksToCoreData(schemeData: response.loginUserData?.stocks ?? [], isForceSave: true)
            
            self.redirectToVC(isDefaultPassword: response.loginUserData?.is_default_password ?? 0)
        }
    }
    
    //    If is_default_password is true then redirect to Change password otherwise redirect to the Home screen
    func redirectToVC(isDefaultPassword: Int) {
        //           Redirect to home screen
        GlobalFunctions.showToast(controller: self, message: "Login successfully", seconds: successDismissTime) {
            
            
            //                If usertype == 2(hospital) and distributor or salesperson id is nil then allow user to select default doctor, distributor and sales person
            let userTypeId = UserDefaults.standard.string(forKey: "userTypeId")
            let userData = UserSessionManager.shared.userDetail
            
            if (isDefaultPassword == 1) {
                //                    Redirect to change password
                let vc = ChangePasswordViewController(nibName: "ChangePasswordViewController", bundle: nil)
                vc.isFromLogin = true
                self.navigationController!.pushViewController(vc, animated: true)
            } else  if let userTypeId = userTypeId, userTypeId == "2", ((userData?.distributor_id == nil) || userData?.sales_person_id == nil) {
                let vc = mainStoryboard.instantiateViewController(withIdentifier: "DefaultLoginData") as! DefaultLoginData
                self.navigationController!.pushViewController(vc, animated: true)
            } else {
                appDelegate.fetchAndStoredDataLocally()
                self.view?.window?.rootViewController = GlobalFunctions.setHomeVC()
                self.view?.window?.makeKeyAndVisible()
            }
        }
    }
}
