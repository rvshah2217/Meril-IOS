//
//  SettingsViewController.swift
//  NextPhysique
//
//  Created by iMac on 22/03/22.
//  Copyright © 2022 Sensussoft. All rights reserved.
//

import UIKit

class SettingsViewController: BaseViewController {

    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var constrainViewHeight: NSLayoutConstraint!
    @IBOutlet var collectionDataVI: [UIView]!
    @IBOutlet weak var btnLogin: UIButton!
    
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
        for i in collectionDataVI{
            i.backgroundColor = ColorConstant.mainThemeColor
            i.layer.cornerRadius = i.frame.height/2
        }
        btnLogin.layer.cornerRadius = btnLogin.frame.height/2
        self.viewHeader.backgroundColor = ColorConstant.mainThemeColor
    }
    func setNavigation(){
        settupHeaderView(childView: self.viewHeader, constrain: constrainViewHeight,title: "Settings")
        navigationController?.setNavigationBarHidden(true, animated: false)

        setBackButtononNavigation()
        pressButtonOnNavigaion { (isBack) in
            if(isBack){
            }else{
                _ =  self.navigationController?.popViewController(animated: true)
            }
        }
    }
    //MARK: -@IBAction Method
    @IBAction func OnClickLogin(_ sender: UIButton) {
    }
    @IBAction func OnClickEditProfile(_ sender: UIButton) {
    }
    @IBAction func OnClickUserName(_ sender: UIButton) {
    }
    @IBAction func OnClickPassword(_ sender: UIButton) {
    }
}
