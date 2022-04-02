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
    
    @IBOutlet weak var userTypeTxt: DropDown! {
        didSet {
            self.userTypeTxt.selectedRowColor = ColorConstant.mainThemeColor// ?? UIColor.systemBlue
            self.userTypeTxt.setIcon(imgName: "ic_star")//addImageViewToLeft(imgName: "ic_user")
        }
    }
    
    @IBOutlet weak var departmentTypeTxt: DropDown! {
        didSet {
            self.departmentTypeTxt.selectedRowColor = ColorConstant.mainThemeColor// ?? UIColor.systemBlue
            self.departmentTypeTxt.setIcon(imgName: "ic_star")//addImageViewToLeft(imgName: "ic_user")
        }
    }
    
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
    var userTypesArr: [UserTypesModel] = []
    var selectedUserTypeId: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
        self.fetchUserType()
    }
    
    func setUI() {
        GlobalFunctions.configureStatusNavBar(navController: self.navigationController!, bgColor: ColorConstant.mainThemeColor, textColor: .white)

        //        set rounded corner
        self.userTypeTxt.setViewCorner(radius: self.userTypeTxt.frame.height/2)
        self.departmentTypeTxt.setViewCorner(radius: self.departmentTypeTxt.frame.height/2)
        self.loginBtn.setViewCorner(radius: self.loginBtn.frame.height/2)
        
        //        Set textfield border
        self.userTypeTxt.addBorderToView(borderWidth: 1.0, borderColor: .white)
        self.departmentTypeTxt.addBorderToView(borderWidth: 1.0, borderColor: .white)
        
        //        set place holder
        self.userTypeTxt.setPlaceholder(placeHolderStr: "Select Type")
        self.departmentTypeTxt.setPlaceholder(placeHolderStr: "Select Department")
                
        self.userTypeTxt.didSelect { selectedText, index, id in
            self.selectedUserTypeId = self.userTypesArr[index].id
        }
        self.userTypeTxt.rowHeight = 40
        self.departmentTypeTxt.isHidden = true
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
        guard let userTypeId = selectedUserTypeId else { return }
        let userNameStr = userNameTxt.text ?? ""
        let passwordStr = passwordTxt.text ?? ""
        
        if !Validation.sharedInstance.validateUserName(testStr: userNameStr) {
//TODO:             Display error message
            return
        }
        
//        if !Validation.sharedInstance.validatePassword(testStr: passwordStr) {
        if !Validation.sharedInstance.checkLength(testStr: passwordStr) {
//TODO:             Display error message
            return
        }
        
        let obj = LoginRequestModel(userTypeId: userTypeId, username: userNameStr, password: passwordStr, fcmToken: deviceToken)
        self.callUserLoginApi(userObj: obj)
    }
    
    func fetchUserType() {
        userTypesArr = UserTypeCoreData.sharedInstance.fetchUserTypes() ?? []
        if self.userTypesArr.isEmpty {
            self.fetchUserTypesFromServer()
            return
        }
        self.setUserTypeTxtData()
    }
    
    private func fetchUserTypesFromServer() {
        LoginServices.getUserTypes { responseModel, errorMessage in
            guard let response = responseModel else {
                GlobalFunctions.printToConsole(message: "login error: \(errorMessage)")
                return
            }
            self.userTypesArr = response.userTypes ?? []
            self.setUserTypeTxtData()
            //                save userTypes to Coredata
                            self.saveUserTypes()
        }
    }
    
    private func setUserTypeTxtData() {
        self.userTypeTxt.isEnabled = !self.userTypesArr.isEmpty
        self.userTypeTxt.optionArray = self.userTypesArr.map({ item -> String in
            item.name ?? ""
        })
    }
    
    private func saveUserTypes() {
        for user in userTypesArr {
            UserTypeCoreData.sharedInstance.saveData(userData: user)
        }
        UserTypeCoreData.sharedInstance.fetchUserTypes()
    }
    
    func callUserLoginApi(userObj: LoginRequestModel) {
        LoginServices.userLogin(loginObj: userObj) { loginResponse, errorMessage in
            
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
                self.view?.window?.rootViewController = GlobalFunctions.setHomeVC()
            }
        }
    }
}
