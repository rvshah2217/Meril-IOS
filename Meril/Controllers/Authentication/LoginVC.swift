//
//  LoginVC.swift
//  Meril
//
//  Created by Nidhi Suhagiya on 21/03/22.
//

import iOSDropDown
import UIKit

class LoginVC: UIViewController {
    
    @IBOutlet weak var userTypeTxt: DropDown!
    @IBOutlet weak var departmentTypeTxt: DropDown!
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
        self.fetchUserType()
    }
    
    func setUI() {
//        set rounded corner
        self.userTypeTxt.setViewCorner(radius: self.userTypeTxt.frame.height/2)
        self.departmentTypeTxt.setViewCorner(radius: self.departmentTypeTxt.frame.height/2)
//        self.userNameTxt.setViewCorner(radius: self.userNameTxt.frame.height/2)
        self.loginBtn.setViewCorner(radius: self.loginBtn.frame.height/2)
        
//        Set textfield border
        self.userTypeTxt.addBorderToView(borderWidth: 1.0, borderColor: .white)
        self.departmentTypeTxt.addBorderToView(borderWidth: 1.0, borderColor: .white)

//        self.userNameTxt.addBorderToView(borderWidth: 1.0, borderColor: .white)
        
//        set place holder
        self.userTypeTxt.setPlaceholder(placeHolderStr: "Select Type")
        self.departmentTypeTxt.setPlaceholder(placeHolderStr: "Select Department")
//        self.userNameTxt.setPlaceholder(placeHolderStr: "Username")

//        set image on left of textfields
//        self.userTypeTxt.addImgViewToLeft(imgName: "ic_star")
//        self.departmentTypeTxt.addImgViewToLeft(imgName: "ic_star")

//        self.userNameTxt.addImageViewToLeft(imgName: "ic_user")
        
//        set dropDown arrow
        self.userTypeTxt.addImageViewToLeft(imgName: "ic_menu")
        self.departmentTypeTxt.addImageViewToLeft(imgName: "ic_menu")
    }
    
    @IBAction func forgotPasswordBtnClicked(_ sender: Any) {
    }
    
    @IBAction func loginBtnClicked(_ sender: Any) {
    }
    
    func fetchUserType() {
        LoginServices.getUserTypes { responseModel, errorMessage in
            guard let response = responseModel else {
                GlobalFunctions.printToConsole(message: "login error: \(errorMessage)")
                return
            }
            for item in response.userTypes ?? [] {
                print(item.name)
            }
        }
    }
}
