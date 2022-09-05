//
//  ProfileViewController.swift
//  Ranky
//
//  Created by iMac on 22/03/22.
//  Copyright © 2022 A K Patil. All rights reserved.
//

import UIKit

class ProfileViewController: BaseViewController {

    @IBOutlet weak var appVersionLbl: UILabel!
    @IBOutlet weak var constrainViewHeader: NSLayoutConstraint!
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblPhone: UILabel!
//    @IBOutlet weak var lblPassword: UILabel!
    @IBOutlet weak var lblGender: UILabel!
    @IBOutlet weak var lblBio: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var uniqueIdLbl: UILabel!
    
    @IBOutlet weak var uniqueIdTxt: UITextField!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var blueBgView: UIView!
    
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPhone: UITextField!
//    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtGender: UITextField!
    @IBOutlet weak var txtBio: UITextField!
    @IBOutlet weak var txtLocation: UITextField!
    
    @IBOutlet weak var DetailsView : UIView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        fetchUserProfile()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        setNavigation()
        GlobalFunctions.configureStatusNavBar(navController: self.navigationController!, bgColor: ColorConstant.mainThemeColor, textColor: .white)
        self.navigationItem.title = "Profile"
    }
    
    //MARK:- Custom Method
    func setUI(){
        imgProfile.layer.borderWidth = 1
        imgProfile.layer.masksToBounds = false
        imgProfile.layer.borderColor = UIColor.red.cgColor
        imgProfile.layer.cornerRadius = imgProfile.frame.height/2
        imgProfile.clipsToBounds = true
        
        blueBgView.addCornerAtBotttoms(radius: 30)
        
        DetailsView.layer.cornerRadius = 20
        DetailsView.layer.shadowColor = UIColor.darkGray.cgColor
        DetailsView.layer.shadowOffset = CGSize(width: 0, height: 1)
        DetailsView.layer.shadowOpacity = 0.1
        DetailsView.layer.shadowRadius = 2.0
        DetailsView.layer.masksToBounds = false
//        DetailsView.layer.cornerRadius = 20
        DetailsView.layer.borderColor = UIColor.lightGray.cgColor
        DetailsView.layer.borderWidth = 0.1

        textfiledUserInteractionFalse()
        viewHeader.backgroundColor = ColorConstant.mainThemeColor
    }
//    func setNavigation(){
//        settupHeaderView(childView: self.viewHeader, constrain: constrainViewHeader,title: "Profile")
//        navigationController?.setNavigationBarHidden(true, animated: false)
//        setBackButtononNavigation()
//        pressButtonOnNavigaion { (isBack) in
//            if(isBack){
//            }else{
//                _ =  self.navigationController?.popViewController(animated: true)
//            }
//        }
//
//    }
    
    private func fetchUserProfile() {
        if appDelegate.reachability.connection == .unavailable {
            self.setUserData()
            return
        }
//        Api call 
        LoginServices.getUserProfile { responseData, error in
            //            store user data into UserDefaults
            UserSessionManager.shared.userDetail = responseData?.userProfile
            self.setUserData()
        }
    }
    
    func setUserData() {
        appVersionLbl.text = "Version:V" + appVersion
//        let userInfo = UserDefaults.standard.string(forKey: "UserProfileData")
//        let jsonData = (userInfo ?? "").data(using: .utf8)!
//        if let userInfo = try? JSONDecoder().decode(UserProfileData.self, from: jsonData) {
//        if let userInfo = userData {
        if let userInfo = UserSessionManager.shared.userDetail {
            self.uniqueIdTxt.text = userInfo.unique_id ?? "N/A"
            if let profile = userInfo.profile {
                self.imgProfile.sd_setImage(with: URL(string: profile), completed: nil)
            } else {
                self.imgProfile.image = UIImage(named: "ic_profileLogo")
            }
            self.lblName.text = userInfo.name
            self.txtEmail.text = userInfo.email
            self.txtPhone.text = userInfo.phone
            self.txtGender.text = userInfo.gender ?? "Male"
            self.lblBio.text = "Name"
            self.txtBio.text = userInfo.name ?? "N/A"
            var address = (userInfo.city ?? "City") + ", " + (userInfo.state ?? "State") + ", "
            address = address + (userInfo.country ?? "Country") + "-" + String(userInfo.pincode ?? 0)
            self.txtLocation.text = address
        }
//        self.imgProfile.image = UIImage
    }
    
    func textfiledUserInteractionFalse(){
        txtEmail.isUserInteractionEnabled = false
        txtPhone.isUserInteractionEnabled = false
        txtGender.isUserInteractionEnabled = false
        txtBio.isUserInteractionEnabled = false
        txtLocation.isUserInteractionEnabled = false
    }
    //MARK: -@IBAction Method
    @IBAction func OnClickBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
