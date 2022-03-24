//
//  AddSurgerayViewController.swift
//  NextPhysique
//
//  Created by iMac on 23/03/22.
//  Copyright © 2022 Sensussoft. All rights reserved.
//

import UIKit

class AddSurgerayViewController: BaseViewController
{
    @IBOutlet weak var viewBC: UIView!
    @IBOutlet var collectionViewBackground: [UIView]!
    @IBOutlet var collectionViewBoarder: [UIView]!
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var constrainViewHeaderHeight: NSLayoutConstraint!
    @IBOutlet weak var DetailsScrollView: UIScrollView!
    
    @IBOutlet weak var txtCity: UITextField!
    @IBOutlet weak var txtHospital: UITextField!
    @IBOutlet weak var txtDoctor: UITextField!
    @IBOutlet weak var txtDistributor: UITextField!
    @IBOutlet weak var txtSaleperson: UITextField!
    @IBOutlet weak var txtPatientName: UITextField!
    @IBOutlet weak var txtPatientNumber: UITextField!
    @IBOutlet weak var txtPatientAge: UITextField!
    @IBOutlet weak var txtIpCode: UITextField!
    @IBOutlet weak var txtOther1: UITextField!
    @IBOutlet weak var txtOther2: UITextField!
    @IBOutlet weak var txtOther3: UITextField!
    
    @IBOutlet weak var btnScanNow: UIButton!
    
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
        for i in collectionViewBoarder{
            i.layer.borderColor = ColorConstant.mainThemeColor.cgColor
            i.layer.borderWidth = 1
            i.layer.cornerRadius = i.frame.height/2
        }
        for i in collectionViewBackground{
            i.backgroundColor = ColorConstant.mainThemeColor
            i.layer.cornerRadius = i.frame.height/2
        }
        DetailsScrollView.layer.cornerRadius = 20
        DetailsScrollView.layer.borderWidth = 0.5
        DetailsScrollView.layer.borderColor = UIColor.lightGray.cgColor
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
            let rectShape = CAShapeLayer()
            rectShape.bounds = self.viewBC.frame
            rectShape.position = self.viewBC.center
            rectShape.path = UIBezierPath(roundedRect: self.viewBC.bounds, byRoundingCorners: [.bottomLeft , .bottomRight], cornerRadii: CGSize(width: 50, height: 50)).cgPath
            self.viewBC.layer.mask = rectShape
        }
        viewBC.backgroundColor = ColorConstant.mainThemeColor
        
        btnScanNow.layer.cornerRadius = btnScanNow.frame.height/2
        self.viewHeader.backgroundColor = ColorConstant.mainThemeColor
        
        txtCity.attributedPlaceholder = NSAttributedString(
            string: "Select City",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white]
        )
        txtHospital.attributedPlaceholder = NSAttributedString(
            string: "Select Hospital",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white]
        )
        txtDoctor.attributedPlaceholder = NSAttributedString(
            string: "Select Doctor",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white]
        )
        txtDistributor.attributedPlaceholder = NSAttributedString(
            string: "Select Distributor",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white]
        )
        txtSaleperson.attributedPlaceholder = NSAttributedString(          string: "Select Saleperson",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white]
        )
        setRightButton(txtCity, image: UIImage(named: "ic_dropdown") ?? UIImage())
        setRightButton(txtHospital, image: UIImage(named: "ic_dropdown") ?? UIImage())
        setRightButton(txtDoctor, image: UIImage(named: "ic_dropdown") ?? UIImage())
        setRightButton(txtDistributor, image: UIImage(named: "ic_dropdown") ?? UIImage())
        setRightButton(txtSaleperson, image: UIImage(named: "ic_dropdown") ?? UIImage())

        txtPatientName.attributedPlaceholder = NSAttributedString(
            string: "Patient Name",
                                                                            attributes: [NSAttributedString.Key.foregroundColor: ColorConstant.mainThemeColor]
        )
        txtPatientNumber.attributedPlaceholder = NSAttributedString(          string: "Patient Mobile Number",
            attributes: [NSAttributedString.Key.foregroundColor: ColorConstant.mainThemeColor]
        )
        txtPatientAge.attributedPlaceholder = NSAttributedString(          string: "Patient Age",
            attributes: [NSAttributedString.Key.foregroundColor: ColorConstant.mainThemeColor]
        )
        txtIpCode.attributedPlaceholder = NSAttributedString(
            string: "Ip Code",
            attributes: [NSAttributedString.Key.foregroundColor: ColorConstant.mainThemeColor]
        )
    }
    func setNavigation(){
        settupHeaderView(childView: self.viewHeader, constrain: constrainViewHeaderHeight,title: "Add Surgeray")
        navigationController?.setNavigationBarHidden(true, animated: false)

        setBackButtononNavigation()
        pressButtonOnNavigaion { (isBack) in
            if(isBack){
            }else{
                _ =  self.navigationController?.popViewController(animated: true)
            }
        }
    }

    @IBAction func OnClickScanNow(_ sender: UIButton) {
    }
}
