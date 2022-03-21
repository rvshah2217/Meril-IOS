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
    @IBOutlet weak var userNameTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var forgotPasswordBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
    }
    
    func setUI() {
//        set rounded corner
        self.userTypeTxt.setViewCorner(radius: self.userTypeTxt.frame.height/2)
        self.departmentTypeTxt.setViewCorner(radius: self.departmentTypeTxt.frame.height/2)
        self.userNameTxt.setViewCorner(radius: self.userNameTxt.frame.height/2)
        self.passwordTxt.setViewCorner(radius: self.passwordTxt.frame.height/2)
        self.loginBtn.setViewCorner(radius: self.loginBtn.frame.height/2)
        
//        Set textfield border
        self.userTypeTxt.addBorderToView(borderWidth: 1.0, borderColor: .white)
        self.departmentTypeTxt.addBorderToView(borderWidth: 1.0, borderColor: .white)
        self.passwordTxt.addBorderToView(borderWidth: 1.0, borderColor: .white)
        self.userNameTxt.addBorderToView(borderWidth: 1.0, borderColor: .white)
        
//        set place holder
        self.userTypeTxt.setPlaceholder(placeHolderStr: "Select Type")
        self.departmentTypeTxt.setPlaceholder(placeHolderStr: "Select Type")
        self.userNameTxt.setPlaceholder(placeHolderStr: "Select Type")
        self.passwordTxt.setPlaceholder(placeHolderStr: "Select Type")
        
//        set image on left of textfields
        self.userTypeTxt.addImageViewToLeft(imgName: "ic_menu")
        self.departmentTypeTxt.addImageViewToLeft(imgName: "ic_menu")
        self.passwordTxt.addImageViewToLeft(imgName: "ic_menu")
        self.userNameTxt.addImageViewToLeft(imgName: "ic_menu")
        
//        set dropDown arrow
        self.userTypeTxt.addImageViewToLeft(imgName: "ic_menu")
        self.departmentTypeTxt.addImageViewToLeft(imgName: "ic_menu")
    }
    
    @IBAction func forgotPasswordBtnClicked(_ sender: Any) {
    }
    
    @IBAction func loginBtnClicked(_ sender: Any) {
    }
}
