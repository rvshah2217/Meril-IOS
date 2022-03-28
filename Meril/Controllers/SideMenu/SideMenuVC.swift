//
//  SideMenuVC.swift
//  Meril
//
//  Created by Nidhi Suhagiya on 21/03/22.
//

import UIKit

class SideMenuVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var userProfileImgVIew: UIImageView!
    @IBOutlet weak var userEmailLbl: UILabel!
    @IBOutlet weak var userNameLbl: UILabel!
    
    var itemsArr = [[String:String]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUserData()
        self.setItemsArr()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
    }
    
    private func setItemsArr() {        
        itemsArr.append(["iconName": "ic_home", "title": "Home"])
        itemsArr.append(["iconName": "ic_aboutUs", "title": "About Us"])
        itemsArr.append(["iconName": "ic_contactUs", "title": "Contact Us"])
//        itemsArr.append(["iconName": "ic_rateApp", "title": "Rate App"])
        itemsArr.append(["iconName": "ic_share", "title": "Share"])
        itemsArr.append(["iconName": "ic_privacyPolicy", "title": "Privacy Policy"])
//        itemsArr.append(["iconName": "ic_settings", "title": "Settings"])
        itemsArr.append(["iconName": "ic_signOut", "title": "Signout"])
    }
    
    func setUserData() {
        self.userProfileImgVIew.setViewCorner(radius: 10)
        if let userInfo = UserSessionManager.shared.userDetail {
            userNameLbl.text = userInfo.name ?? ""
            userEmailLbl.text = userInfo.email ?? ""
            if let profileImgStr = userInfo.profile {
                userProfileImgVIew.sd_setImage(with: URL(string: profileImgStr))
                return
            }
            userProfileImgVIew.image = UIImage(named: "ic_profile")
        }
    }
    
    @IBAction func closeBtnClicked(_ sender: Any) {
        self.sideMenuController?.hideLeftView()
    }
    
}

//#MARK: Tableview delegate and datasource methods
extension SideMenuVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemsArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? SideMenuCell {
            cell.item = itemsArr[indexPath.row]
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.sideMenuController?.hideLeftView()
        let navVC = sideMenuController?.rootViewController as! UINavigationController

        if indexPath.row == 0{
            
        }else if indexPath.row == 1{
            let vc = PrivacyPolicyViewController(nibName: "PrivacyPolicyViewController", bundle: nil)
            vc.pageName = .AboutUs
            navVC.pushViewController(vc, animated: true)
        }else if indexPath.row == 2{
            let vc = ContactUsViewController(nibName: "ContactUsViewController", bundle: nil)
            navVC.pushViewController(vc, animated: true)
        }else if indexPath.row == 3{
            let text = "Shared text...."
            let textToShare = [ text ]
            let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
            self.present(activityViewController, animated: true, completion: nil)
        }else if indexPath.row == 4{
            let vc = PrivacyPolicyViewController(nibName: "PrivacyPolicyViewController", bundle: nil)
            vc.pageName = .PrivacyPolicy
            navVC.pushViewController(vc, animated: true)
        }else if indexPath.row == 5{
            LoginServices.userLogOut(navController: navVC)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
}
