//
//  ProfileViewController.swift
//  Ranky
//
//  Created by iMac on 22/03/22.
//  Copyright © 2022 A K Patil. All rights reserved.
//

import UIKit

class ProfileViewController: BaseViewController {

    @IBOutlet weak var constrainViewHeader: NSLayoutConstraint!
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblPhone: UILabel!
    @IBOutlet weak var lblPassword: UILabel!
    @IBOutlet weak var lblGender: UILabel!
    @IBOutlet weak var lblBio: UILabel!
    @IBOutlet weak var lblLocation: UILabel!

    @IBOutlet weak var imgProfile: UIImageView!
    
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPhone: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtGender: UITextField!
    @IBOutlet weak var txtBio: UITextField!
    @IBOutlet weak var txtLocation: UITextField!
    
    @IBOutlet weak var DetailsView : UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigation()
    }
    //MARK:- Custom Method
    func setUI(){
        imgProfile.layer.borderWidth = 1
        imgProfile.layer.masksToBounds = false
        imgProfile.layer.borderColor = UIColor.red.cgColor
        imgProfile.layer.cornerRadius = imgProfile.frame.height/2
        imgProfile.clipsToBounds = true
        
        DetailsView.layer.cornerRadius = 20
        DetailsView.layer.shadowColor = UIColor.darkGray.cgColor
        DetailsView.layer.shadowOffset = CGSize(width: 0, height: 1)
        DetailsView.layer.shadowOpacity = 0.1
        DetailsView.layer.shadowRadius = 2.0
        DetailsView.layer.masksToBounds = false
        DetailsView.layer.cornerRadius = 20
        DetailsView.layer.borderColor = UIColor.lightGray.cgColor
        DetailsView.layer.borderWidth = 0.1

        textfiledUserInteractionFalse()
        viewHeader.backgroundColor = ColorConstant.mainThemeColor
    }
    func setNavigation(){
        settupHeaderView(childView: self.viewHeader, constrain: constrainViewHeader,title: "Profile")
        navigationController?.setNavigationBarHidden(true, animated: false)
        setBackButtononNavigation()
        pressButtonOnNavigaion { (isBack) in
            if(isBack){
            }else{
                _ =  self.navigationController?.popViewController(animated: true)
            }
        }
        
    }
    func textfiledUserInteractionFalse(){
        txtEmail.isUserInteractionEnabled = false
        txtPhone.isUserInteractionEnabled = false
        txtPassword.isUserInteractionEnabled = false
        txtGender.isUserInteractionEnabled = false
        txtBio.isUserInteractionEnabled = false
        txtLocation.isUserInteractionEnabled = false
    }
    //MARK: -@IBAction Method
    @IBAction func OnClickBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
