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
    
    var bannerArr: [UserTypesModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.stopSyncButtonAnimation), name: .stopSyncBtnAnimation, object: nil)
        // Do any additional setup after loading the view.
        self.setNavBar()
        self.setUI()
        self.fetchBanners()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .stopSyncBtnAnimation, object: nil)
    }
    
    private func setNavBar() {
        let menuBtn = UIBarButtonItem(image: UIImage(named: "ic_menu"), style: .plain, target: self, action: #selector(self.sideMenuBtnPressed))
        self.navigationItem.leftBarButtonItem = menuBtn
        
        let profileBtn = UIBarButtonItem(image: UIImage(named: "ic_homeProfile"), style: .plain, target: self, action: #selector(self.profileBtnPressed))
        self.navigationItem.rightBarButtonItem = profileBtn
        
        self.navigationItem.title = ""
        self.navigationItem.titleView = navTitleView()

        //Set navigation header
        func navTitleView() -> UIView {
            let titleView = UIView(frame: CGRect(x: (DeviceConstant.deviceWidth / 2) - 70, y: 0, width: 130, height: 40))
            
            let logo = UIImage(named: "ic_launchIcon")
            let imageView = UIImageView(image: logo)
            imageView.clipsToBounds = true
            imageView.contentMode = .scaleAspectFit
            imageView.frame = titleView.bounds
            
            titleView.addSubview(imageView)
            titleView.backgroundColor = ColorConstant.mainThemeColor
            imageView.frame.size.height = 25
            imageView.frame.origin.y = 7.5
            return titleView
        }
        
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
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.bannerImageViewTapped))
        imageSlidesView.addGestureRecognizer(gestureRecognizer)
    }
    
    @objc func sideMenuBtnPressed() {        
        self.sideMenuController?.toggleLeftView()
    }
    
    @objc func profileBtnPressed() {
        let profileVC = ProfileViewController(nibName: "ProfileViewController", bundle: nil)
        self.navigationController?.pushViewController(profileVC, animated: true)
    }
    
    func fetchBanners() {
        SHOW_CUSTOM_LOADER()
//        Fetch banners from local database
        bannerArr = HomeBanners_CoreData.sharedInstance.fetchBanners() ?? []
//        if it is empty then fetch it from server
        if bannerArr.isEmpty {
            HomeServices.getBannerList { response, error in
                HIDE_CUSTOM_LOADER()
                guard let responseData = response else {
                    //                hide banner view if there is error
                    return
                }
                self.bannerArr = responseData.userTypes ?? []
    //            save bannerresponse to coreData
                HomeBanners_CoreData.sharedInstance.saveBanners(schemeData: responseData.userTypes ?? [])
                self.setBannerImages()
            }
            return
        }
        HIDE_CUSTOM_LOADER()
        self.setBannerImages()
    }
    
    func setBannerImages() {
        var images: [SDWebImageSource] = []
        for item in bannerArr {
            images.append(SDWebImageSource(urlString: item.image ?? "")!)
        }
        self.imageSlidesView.setImageInputs(images)
    }
    
//    Handle banner click
    @objc func bannerImageViewTapped() {
        let selectedIndex = self.imageSlidesView.currentPage
        if let urlStr = bannerArr[selectedIndex].link, let url = URL(string: urlStr) {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
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
        let vc = SurgeryListViewController(nibName: "SurgerayListViewController", bundle: nil)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func listAllInventoriesBtnClicked(_ sender: Any) {
        
        let vc = InventoryListVC(nibName: "InventoryListVC", bundle: nil)
        self.navigationController?.pushViewController(vc, animated: true)
//        let vc = SurgerayListViewController(nibName: "SurgerayListViewController", bundle: nil)
//        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func syncDataBtnClicked(_ sender: Any) {
        self.syncDataBtn.imageView?.rotate()
        AddSurgeryInventory().fetchSurgeryBySyncStatus()
    }
    
    @objc func stopSyncButtonAnimation() {
            // Put your code which should be executed with a delay here
            self.syncDataBtn.imageView?.stopRotation()
    }
}


