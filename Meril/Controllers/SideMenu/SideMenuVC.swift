//
//  SideMenuVC.swift
//  Meril
//
//  Created by Nidhi Suhagiya on 21/03/22.
//

import UIKit

class SideMenuVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var itemsArr = [[String:String]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        itemsArr.append(["iconName": "ic_settings", "title": "Settings"])
        itemsArr.append(["iconName": "ic_signOut", "title": "Signout"])
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
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
}
