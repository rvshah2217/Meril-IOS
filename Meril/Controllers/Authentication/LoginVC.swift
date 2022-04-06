//
//  LoginVC.swift
//  Meril
//
//  Created by Nidhi Suhagiya on 21/03/22.
//

import iOSDropDown
import UIKit
import Alamofire
import CoreData

class LoginVC: UIViewController {
    
    //    @IBOutlet weak var userTypeTxt: DropDown! {
    //        didSet {
    //            self.userTypeTxt.selectedRowColor = ColorConstant.mainThemeColor// ?? UIColor.systemBlue
    //            self.userTypeTxt.setIcon(imgName: "ic_star")//addImageViewToLeft(imgName: "ic_user")
    //        }
    //    }
    //
    //    @IBOutlet weak var departmentTypeTxt: DropDown! {
    //        didSet {
    //            self.departmentTypeTxt.selectedRowColor = ColorConstant.mainThemeColor// ?? UIColor.systemBlue
    //            self.departmentTypeTxt.setIcon(imgName: "ic_star")//addImageViewToLeft(imgName: "ic_user")
    //        }
    //    }
    
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
    //    var userTypesArr: [UserTypesModel] = []
    //    var selectedUserTypeId: Int?
    
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
        
//        if !Validation.sharedInstance.validateUserName(testStr: userNameStr) {
        if !Validation.sharedInstance.checkLength(testStr: passwordStr) {
            GlobalFunctions.showToast(controller: self, message: "Please enter username", seconds: errorDismissTime, completionHandler: {})
            return
        }
        
        //        if !Validation.sharedInstance.validatePassword(testStr: passwordStr) {
        if !Validation.sharedInstance.checkLength(testStr: passwordStr) {
            GlobalFunctions.showToast(controller: self, message: "Please enter password", seconds: errorDismissTime, completionHandler: {})
            return
        }
        
        let obj = LoginRequestModel(username: userNameStr, password: passwordStr, fcmToken: deviceToken)
        self.callUserLoginApi(userObj: obj)
    }
    
    func callUserLoginApi(userObj: LoginRequestModel) {
        SHOW_CUSTOM_LOADER()
        LoginServices.userLogin(loginObj: userObj) { loginResponse, errorMessage in
            HIDE_CUSTOM_LOADER()
            guard let response = loginResponse else {
                GlobalFunctions.printToConsole(message: "login error: \(errorMessage)")
                GlobalFunctions.showToast(controller: self, message: errorMessage ?? UserMessages.serverError, seconds: errorDismissTime) { }
                return
            }
            
            //            store user data into UserDefaults
            UserSessionManager.shared.userDetail = response.loginUserData?.user_data
            //            UserDefaults.standard.set(response.loginUserData?.id, forKey: "userId")
            //            UserDefaults.standard.set(response.loginUserData?.user_type_id, forKey: "userTypeId")
            //            UserDefaults.standard.set(response.loginUserData?.unique_id, forKey: "userName")
            UserDefaults.standard.set(response.loginUserData?.token, forKey: "headerToken")
            
            //           Redirect to home screen
            GlobalFunctions.showToast(controller: self, message: "Login successfully", seconds: successDismissTime) {
                if (response.loginUserData?.is_default_password == 1) {
//                    Redirect to change password
                    let vc = ChangePasswordViewController(nibName: "ChangePasswordViewController", bundle: nil)
                    vc.isFromLogin = true
                    self.navigationController?.pushViewController(vc, animated: true)
                } else {
                    self.view?.window?.rootViewController = GlobalFunctions.setHomeVC()
                }
            }
        }
    }
}
