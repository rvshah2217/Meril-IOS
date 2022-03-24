//
//  PrivacyPolicyViewController.swift
//  NextPhysique
//
//  Created by iMac on 23/03/22.
//  Copyright © 2022 Sensussoft. All rights reserved.
//

import UIKit

class PrivacyPolicyViewController: BaseViewController {

    @IBOutlet weak var constrainViewHeight: NSLayoutConstraint!
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var txtView: UITextView!
    
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
    }
    func setNavigation(){
        settupHeaderView(childView: self.viewHeader, constrain: constrainViewHeight,title: "Privacy Policy")
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
