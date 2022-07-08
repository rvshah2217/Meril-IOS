//
//  ChangePasswordViewController.swift
//  Meril
//
//  Created by iMac on 26/03/22.
//

import UIKit

class ChangePasswordViewController: BaseViewController {

    @IBOutlet weak var scrollDetails: UIScrollView!
    @IBOutlet weak var viewBK: UIView!
    @IBOutlet weak var constrainViewHeaderHeight: NSLayoutConstraint!
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var txtCurrent: UITextField!
    @IBOutlet weak var txtNew: UITextField!
    @IBOutlet weak var txtConfirm: UITextField!
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet var collectionTextField: [UITextField]!

    var isFromLogin: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigation()
    }
    //MARK:- Custome Method
    func setUI(){
        self.viewHeader.backgroundColor = ColorConstant.mainThemeColor
        btnSubmit.backgroundColor = ColorConstant.mainThemeColor
        btnSubmit.layer.cornerRadius = btnSubmit.frame.height / 2
        
        for txt in collectionTextField{
            txt.layer.borderWidth = 1
            txt.layer.cornerRadius = txt.frame.height / 2
            txt.layer.borderColor = ColorConstant.mainThemeColor.cgColor
            let view = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: txt.frame.height))
            txt.leftViewMode = UITextField.ViewMode.always;
            txt.leftView = view;
        }
        txtCurrent.attributedPlaceholder = NSAttributedString(          string: "Current Password",
            attributes: [NSAttributedString.Key.foregroundColor: ColorConstant.mainThemeColor]
        )
        txtNew.attributedPlaceholder = NSAttributedString(          string: "New Password",
            attributes: [NSAttributedString.Key.foregroundColor: ColorConstant.mainThemeColor]
        )
        txtConfirm.attributedPlaceholder = NSAttributedString(
            string: "Confirm Password",
            attributes: [NSAttributedString.Key.foregroundColor: ColorConstant.mainThemeColor]
        )
        scrollDetails.layer.cornerRadius = 20
        scrollDetails.layer.borderWidth = 0.5
        scrollDetails.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    func setNavigation(){
        self.navigationItem.title = "Change password"
        GlobalFunctions.configureStatusNavBar(navController: self.navigationController!, bgColor: ColorConstant.mainThemeColor, textColor: .white)        

//        settupHeaderView(childView: self.viewHeader, constrain: constrainViewHeaderHeight,title: "Change password")
//        navigationController?.setNavigationBarHidden(true, animated: false)
//        if !isFromLogin {
//            setBackButtononNavigation()
//            pressButtonOnNavigaion { (isBack) in
//                if(isBack){
//                }else{
//                    _ =  self.navigationController?.popViewController(animated: true)
//                }
//            }
//        }
    }
    
    func inputValidation() {
        
        let currentPassword = txtCurrent.text ?? ""
        let newPassword = txtNew.text ?? ""
        let confirmPassword = txtConfirm.text ?? ""
       
        if !Validation.sharedInstance.checkLength(testStr: currentPassword) {
            GlobalFunctions.showToast(controller: self, message: "Please enter current password.", seconds: errorDismissTime)
            return
        }
        
        if !Validation.sharedInstance.checkLength(testStr: newPassword) {
            GlobalFunctions.showToast(controller: self, message: "Please enter new password.", seconds: errorDismissTime)
            return
        }
        
        if !Validation.sharedInstance.checkLength(testStr: confirmPassword) {
            GlobalFunctions.showToast(controller: self, message: "Please enter confirm password.", seconds: errorDismissTime)
            return
        }
        if txtConfirm.text != txtNew.text{
            GlobalFunctions.showToast(controller: self, message: "New password and confirm password must be same.", seconds: errorDismissTime)

        }
        let obj = ChangePasswordRequestModel(currentPassword: currentPassword, newPassword: newPassword)
        self.callChangePasswordApi(userObj: obj)

    }
    @IBAction func onClickSubmit(_ sender: UIButton) {
        inputValidation()
    }
}
extension ChangePasswordViewController{
    func callChangePasswordApi(userObj: ChangePasswordRequestModel) {
        ChangePasswordServices.changepassword(loginObj: userObj) { isSuccess, errorMessage in
            if isSuccess{
                GlobalFunctions.showToast(controller: self, message: "Password change successfully", seconds: errorDismissTime) {
                    
                    UserDefaults.standard.set(false, forKey: "isDefaultPassword")
                    self.redirectToNextVC()
                 
                }
            }else{
                GlobalFunctions.showToast(controller: self, message: errorMessage ?? "", seconds: errorDismissTime)
            }
        }
    }
    
    func redirectToNextVC() {
        let userTypeId = UserDefaults.standard.string(forKey: "userTypeId")
        let userData = UserSessionManager.shared.userDetail
        if let userTypeId = userTypeId, userTypeId == "2", ((userData?.distributor_id == nil) || userData?.sales_person_id == nil) {
            let vc = mainStoryboard.instantiateViewController(withIdentifier: "DefaultLoginData") as! DefaultLoginData
//            self.navigationController!.pushViewController(vc, animated: true)
            self.view?.window?.rootViewController = GlobalFunctions.setRootNavigationController(currentVC: vc)
        } else if self.isFromLogin {
            appDelegate.fetchAndStoredDataLocally()
            self.view?.window?.rootViewController = GlobalFunctions.setHomeVC()
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
}
