//
//  PrivacyPolicyViewController.swift
//  NextPhysique
//
//  Created by iMac on 23/03/22.
//  Copyright © 2022 Sensussoft. All rights reserved.
//

import UIKit

class PrivacyPolicyViewController: BaseViewController {
    
    @IBOutlet weak var txtView: UITextView!
    
    var pageName : pageType?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        GlobalFunctions.configureStatusNavBar(navController: self.navigationController!, bgColor: ColorConstant.mainThemeColor, textColor: .white)
    }
    
    //MARK:- Custome Method
    func setUI(){
        self.navigationItem.title = pageName == .some(.AboutUs) ? "About Us" : "Privacy Policy"
        
        let settingsData = UserDefaults.standard.string(forKey: "settingsData")
        let jsonData = (settingsData ?? "").data(using: .utf8)!
        if let settingsInfo = try? JSONDecoder().decode(SettingsData.self, from: jsonData) {
            if pageName == .some(.AboutUs){
                txtView.text = settingsInfo.app_desc
            }else{
                txtView.text = settingsInfo.privay_policy
            }
        }
    }
    
    func setNavigation(){
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        setBackButtononNavigation()
        pressButtonOnNavigaion { (isBack) in
            if(isBack){
            }else{
                _ =  self.navigationController?.popViewController(animated: true)
            }
        }
    }
}
