//
//  ViewController.swift
//  Meril
//
//  Created by Nidhi Suhagiya on 21/03/22.
//

import UIKit
import LGSideMenuController
import ImageSlideshow

class HomeVC: UIViewController {
    
    @IBOutlet weak var bannerView: UIView!
    @IBOutlet weak var imageSlidesView: ImageSlideshow!
    
    @IBOutlet weak var addSurgeryBtn: UIButton!
    @IBOutlet weak var addInventoryBtn: UIButton!
    @IBOutlet weak var displaySurgeriesBtn: UIButton!
    @IBOutlet weak var displayInventoriesBtn: UIButton!
    @IBOutlet weak var syncDataBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.setNavBar()
        self.setUI()
        self.fetchBanners()
    }
    
    private func setNavBar() {
        let menuBtn = UIBarButtonItem(image: UIImage(named: "ic_menu"), style: .plain, target: self, action: #selector(self.sideMenuBtnPressed))
        self.navigationItem.leftBarButtonItem = menuBtn
        self.navigationItem.title = ""
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        GlobalFunctions.configureStatusNavBar(navController: self.navigationController!, bgColor: .white, textColor: ColorConstant.mainThemeColor)
//        self.navigationController?.navigationBar.barTintColor = .white
    }
    
    private func setUI() {
        self.addSurgeryBtn.setViewCorner(radius: 20.0)
        self.addInventoryBtn.setViewCorner(radius: 20.0)
        self.displaySurgeriesBtn.setViewCorner(radius: 20.0)
        self.displayInventoriesBtn.setViewCorner(radius: 20.0)
        self.bannerView.setViewCorner(radius: 20.0)
        self.imageSlidesView.setViewCorner(radius: 20.0)
        self.syncDataBtn.setViewCorner(radius: 10.0)
        
        self.addSurgeryBtn.addBorderToView(borderWidth: 1.0, borderColor: ColorConstant.mainThemeColor)
        self.addInventoryBtn.addBorderToView(borderWidth: 1.0, borderColor: ColorConstant.mainThemeColor)
        self.displaySurgeriesBtn.addBorderToView(borderWidth: 1.0, borderColor: ColorConstant.mainThemeColor)
        self.displayInventoriesBtn.addBorderToView(borderWidth: 1.0, borderColor: ColorConstant.mainThemeColor)
        self.bannerView.addBorderToView(borderWidth: 1.0, borderColor: ColorConstant.mainThemeColor)
        
        self.addSurgeryBtn.setTitle("", for: .normal)
        self.addInventoryBtn.setTitle("", for: .normal)
        self.displaySurgeriesBtn.setTitle("", for: .normal)
        self.displayInventoriesBtn.setTitle("", for: .normal)
        
        imageSlidesView.slideshowInterval = 3.0
        imageSlidesView.activityIndicator = DefaultActivityIndicator()
        imageSlidesView.contentMode = .scaleToFill
        imageSlidesView.contentScaleMode = .scaleToFill
    }
    
    @objc func sideMenuBtnPressed() {
        self.sideMenuController?.toggleLeftView()
    }
    
    func fetchBanners() {
        HomeServices.getBannerList { response, error in
            guard let responseData = response else {
                //                hide banner view if there is error
                return
            }
            
            var images: [SDWebImageSource] = []
            for item in responseData.userTypes ?? [] {
                images.append(SDWebImageSource(urlString: item.image ?? "")!)
            }
            self.imageSlidesView.setImageInputs(images)
        }
    }
}

extension HomeVC {
    @IBAction func addSurgeryBtnClicked(_ sender: Any) {
        let vc = AddSurgerayViewController(nibName: "AddSurgerayViewController", bundle: nil)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func addInventoryBtnClicked(_ sender: Any) {
        let vc = AddInventoryViewController(nibName: "AddInventoryViewController", bundle: nil)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func listAllSurgeriesBtnClicked(_ sender: Any) {
        let vc = SurgerayListViewController(nibName: "SurgerayListViewController", bundle: nil)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func listAllInventoriesBtnClicked(_ sender: Any) {
//        let vc = SurgerayListViewController(nibName: "SurgerayListViewController", bundle: nil)
//        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func syncDataBtnClicked(_ sender: Any) {
    }
    
}

