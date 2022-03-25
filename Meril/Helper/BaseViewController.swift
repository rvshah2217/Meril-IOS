//
//  BaseViewController.swift
//  CityOfWishes
//
//  Created by Sensu Soft on 22/01/18.
//  Copyright © 2018 sensussoft. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    typealias completionBlock = (_ isCartButton:Bool)->()
    typealias completionMenuBlock = ()->()
    var btnClickBlock : completionBlock!
    var customNavigationBar : UINavigationBar?
    var lblDescTotalHeight1 = 0.0


    var lblCount:UILabel!
    var btnSwitch = UIButton(type: .custom)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setBackButtononNavigation() {
        self.navigationController?.navigationBar.isHidden = false
        let btnback = UIButton(type: .custom)
        btnback.setImage(UIImage(named: "ic_back"), for: .normal)
        btnback.frame = CGRect(x: -10, y: 0, width: 35, height: 40)
        btnback.showsTouchWhenHighlighted = true
        btnback.addTarget(self, action: #selector(self.btnback_Click), for: .touchUpInside)
        let leftBarButtonItems = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 40))
        leftBarButtonItems.addSubview(btnback)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftBarButtonItems)
    }
    
    func settupHeaderView(childView : UIView, constrain : NSLayoutConstraint , title : String){
        if IS_IPHONE_X() || IS_IPHONE_XR() || IS_IPHONE_PRO_MAX(){
            constrain.constant = 84
            customNavigationBar = UINavigationBar(frame: CGRect(x: 0, y: 44, width: view.frame.size.width, height: childView.frame.height))
        }else{
            constrain.constant = 64
            customNavigationBar = UINavigationBar(frame: CGRect(x: 0, y: 20, width: view.frame.size.width, height: childView.frame.height))
        }
        
        customNavigationBar?.isTranslucent = false
        customNavigationBar?.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        customNavigationBar?.shadowImage = UIImage()
        
        for views in childView.subviews{
            views.removeFromSuperview()
        }
        let title = title
        let firstFrame = CGRect(x: -SCREEN_WIDTH / 100, y: 10, width: (navigationController?.navigationBar.frame.width)! - 80, height: (navigationController?.navigationBar.frame.height)!)
        let firstLabel = UILabel(frame: firstFrame)
        firstLabel.text = title
        firstLabel.numberOfLines = 1
        firstLabel.lineBreakMode = .byClipping
//        firstLabel.font = UIFont(name: , size: 19)
        firstLabel.textColor = UIColor.white
        
        firstLabel.layer.masksToBounds = false
        firstLabel.clipsToBounds = true
        firstLabel.sizeToFit()
        firstLabel.adjustsFontSizeToFitWidth = true
                
        let leftBarButtonItems = UIView(frame: CGRect(x: -SCREEN_WIDTH / 5.5, y: 0, width: (navigationController?.navigationBar.frame.width)! - 80, height: (navigationController?.navigationBar.frame.height)!))
        leftBarButtonItems.addSubview(firstLabel)
        navigationItem.titleView = leftBarButtonItems
        
        customNavigationBar?.setItems([navigationItem], animated: false)
        childView.addSubview(customNavigationBar!)
    }
    
    func setMenuButtonNavigation() {
        let btnMenu = UIButton(type: .custom)
        let img: UIImage = UIImage(named: "ic_menu")!
        btnMenu.setImage(img, for: .normal)
        btnMenu.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        btnMenu.showsTouchWhenHighlighted = true
        btnMenu.addTarget(self, action: #selector(self.btnmenu_Click), for: .touchUpInside)
        let leftBarButtonItems = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        leftBarButtonItems.addSubview(btnMenu)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftBarButtonItems)
    }
    
    func setRightMenu(imageName: String) {
        let btnMenu = UIButton(type: .custom)
        
        btnMenu.setImage(UIImage(named: imageName), for: .normal)
        btnMenu.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        btnMenu.showsTouchWhenHighlighted = true
        btnMenu.addTarget(self, action: #selector(self.btnMenu_Click), for: .touchUpInside)
        
        let rightBarButtonItems = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 40))
        rightBarButtonItems.addSubview(btnMenu)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightBarButtonItems)
    }
    
    func setRightSwitch() {
        
        btnSwitch.setImage(UIImage(named: "ic_on"), for: .selected)
        btnSwitch.setImage(UIImage(named: "ic_off"), for: .normal)
        btnSwitch.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        btnSwitch.showsTouchWhenHighlighted = true
        btnSwitch.addTarget(self, action: #selector(self.btnSwitch_Click), for: .touchUpInside)
        
        let rightBarButtonItems = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 40))
        rightBarButtonItems.addSubview(btnSwitch)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightBarButtonItems)
    }
    
    @IBAction func btnSwitch_Click(_ sender: Any) {
        self.btnClickBlock(true)
    }
    
    @IBAction func btnMenu_Click(_ sender: Any) {
        self.btnClickBlock(true)
    }
    @IBAction func btnback_Click(_ sender: Any) {
        self.btnClickBlock(false)
    }
    @IBAction func btnmenu_Click(_ sender: Any) {
        self.setSideMenu()
    }
   
    func setNavigationTitle(str:String) {
        self.title = str
    }
    
    func setSideMenu() {
    }
    
    func setHelp() {
    }
    
    func pressButtonOnNavigaion(completion : @escaping completionBlock) {
        btnClickBlock = completion
    }
    
    func popViewController(){
        self.navigationController?.popViewController(animated: true)
    }
}


