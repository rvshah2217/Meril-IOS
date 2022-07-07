//
//  ContactUsViewController.swift
//  Meril
//
//  Created by iMac on 26/03/22.
//

import UIKit

class ContactUsViewController: BaseViewController {
    
    @IBOutlet var collectionTextField: [UITextField]!
    @IBOutlet weak var txtView: UITextView!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtSubject: UITextField!
    @IBOutlet weak var btnSubmit: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        GlobalFunctions.configureStatusNavBar(navController: self.navigationController!, bgColor: ColorConstant.mainThemeColor, textColor: .white)
    }
    
    //MARK:- Setup UI
    func setUI(){
        self.navigationItem.title = "Contact Us"
        //        self.ViewHeader.backgroundColor = ColorConstant.mainThemeColor
        btnSubmit.backgroundColor = ColorConstant.mainThemeColor
        btnSubmit.layer.cornerRadius = btnSubmit.frame.height / 2
        
        for txt in collectionTextField{
            txt.layer.borderWidth = 1
            txt.layer.cornerRadius = 8
            txt.layer.borderColor = ColorConstant.mainThemeColor.cgColor
            let view = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: txt.frame.height))
            txt.leftViewMode = UITextField.ViewMode.always;
            txt.leftView = view;
        }
        let toolbar = UIToolbar.init()
        toolbar.sizeToFit()
        let barBtnDone = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(btnBarDoneAction))
        toolbar.items = [barBtnDone]
        txtView.inputAccessoryView = toolbar
        txtView.layer.borderWidth = 1
        txtView.layer.cornerRadius = 8
        txtView.layer.borderColor = ColorConstant.mainThemeColor.cgColor
        txtView.textContainerInset = UIEdgeInsets(top: 10,left: 10,bottom: 0 ,right: 0);
        
    }
    
    func inputValidation() {
        
        let name = txtName.text ?? ""
        let email = txtEmail.text ?? ""
        let subject = txtSubject.text ?? ""
        let message = txtSubject.text ?? ""
        
        if !Validation.sharedInstance.checkLength(testStr: name) {
            GlobalFunctions.showToast(controller: self, message: "Please enter name.", seconds: errorDismissTime)
            return
        }
        
        if !Validation.sharedInstance.checkLength(testStr: email) {
            GlobalFunctions.showToast(controller: self, message: "Please enter email.", seconds: errorDismissTime)
            return
        }
        
        if !Validation.sharedInstance.isValidEmail(testStr: email) {
            GlobalFunctions.showToast(controller: self, message: "Please enter valid email.", seconds: errorDismissTime)
            return
        }
        
        if !Validation.sharedInstance.checkLength(testStr: subject) {
            GlobalFunctions.showToast(controller: self, message: "Please enter subject.", seconds: errorDismissTime)
            return
        }
        
        if !Validation.sharedInstance.checkLength(testStr: message) {
            GlobalFunctions.showToast(controller: self, message: "Please enter message.", seconds: errorDismissTime)
        }
        
        let obj = ContactUsRequestModel(name: name, email: email, subject: subject, message: message)
        self.callcontactUsApi(userObj: obj)
    }
    //MARK:- @IBAction Method
    @objc func btnBarDoneAction() { txtView.resignFirstResponder() }
    
    @IBAction func onClickSubmit(_ sender: UIButton) {
        inputValidation()
    }
}

//#MARK: submit user data to server (ContactUs api call)
extension ContactUsViewController{
    func callcontactUsApi(userObj: ContactUsRequestModel) {
        ContactUsServices.contactUs(loginObj: userObj){ isSuccess, errorMessage in
            if isSuccess{
                GlobalFunctions.showToast(controller: self, message: "Request sent successfully", seconds: errorDismissTime)
                DispatchQueue.main.asyncAfter(deadline: .now() + errorDismissTime + 0.5){
                    self.navigationController?.popViewController(animated: true)
                }
                
            }else{
                GlobalFunctions.showToast(controller: self, message: errorMessage ?? "", seconds: errorDismissTime)
            }
        }
    }
}
