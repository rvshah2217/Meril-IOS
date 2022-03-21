//
//  ViewController.swift
//  Meril
//
//  Created by Nidhi Suhagiya on 21/03/22.
//

import UIKit
import LGSideMenuController

class HomeVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.setNavBar()
    }

    private func setNavBar() {
        self.navigationController?.navigationBar.barTintColor = .white
        let menuBtn = UIBarButtonItem(image: UIImage(named: "ic_menu"), style: .plain, target: self, action: #selector(self.sideMenuBtnPressed))
        self.navigationItem.leftBarButtonItem = menuBtn
    }
    
    @objc func sideMenuBtnPressed() {
        self.sideMenuController?.toggleLeftView()
    }
}

