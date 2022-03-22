//
//  ViewController.swift
//  Meril
//
//  Created by Nidhi Suhagiya on 21/03/22.
//

import UIKit
import LGSideMenuController

class HomeVC: UIViewController {
    
    @IBOutlet weak var bannerView: UIView!
    
    @IBOutlet weak var addSurgeryBtn: UIButton!
    @IBOutlet weak var addInventoryBtn: UIButton!
    @IBOutlet weak var displaySurgeriesBtn: UIButton!
    @IBOutlet weak var displayInventoriesBtn: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.setNavBar()
        self.setUI()
    }

    private func setNavBar() {
        self.navigationController?.navigationBar.barTintColor = .white
        let menuBtn = UIBarButtonItem(image: UIImage(named: "ic_menu"), style: .plain, target: self, action: #selector(self.sideMenuBtnPressed))
        self.navigationItem.leftBarButtonItem = menuBtn
    }
    
    private func setUI() {
        self.addSurgeryBtn.setViewCorner(radius: 15.0)
        self.addInventoryBtn.setViewCorner(radius: 15.0)
        self.displaySurgeriesBtn.setViewCorner(radius: 15.0)
        self.displayInventoriesBtn.setViewCorner(radius: 15.0)
        self.bannerView.setViewCorner(radius: 15.0)

        self.addSurgeryBtn.addBorderToView(borderWidth: 0.8, borderColor: ColorConstant.mainThemeColor)
        self.addInventoryBtn.addBorderToView(borderWidth: 0.8, borderColor: ColorConstant.mainThemeColor)
        self.displaySurgeriesBtn.addBorderToView(borderWidth: 0.8, borderColor: ColorConstant.mainThemeColor)
        self.displayInventoriesBtn.addBorderToView(borderWidth: 0.8, borderColor: ColorConstant.mainThemeColor)
        self.bannerView.addBorderToView(borderWidth: 0.8, borderColor: ColorConstant.mainThemeColor)

    }
    
    @objc func sideMenuBtnPressed() {
        self.sideMenuController?.toggleLeftView()
    }
}

extension HomeVC {
    
    
    @IBAction func addSurgeryBtnClicked(_ sender: Any) {
    }

    @IBAction func addInventoryBtnClicked(_ sender: Any) {
    }

    @IBAction func listAllSurgeriesBtnClicked(_ sender: Any) {
    }

    @IBAction func listAllInventoriesBtnClicked(_ sender: Any) {
    }


}

