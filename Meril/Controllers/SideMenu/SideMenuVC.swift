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
        itemsArr.append(["iconName": "ic_menu", "title": "Home"])
        itemsArr.append(["iconName": "ic_menu", "title": "About Us"])
        itemsArr.append(["iconName": "ic_menu", "title": "Contact Us"])
        itemsArr.append(["iconName": "ic_menu", "title": "Rate App"])
        itemsArr.append(["iconName": "ic_menu", "title": "Share"])
        itemsArr.append(["iconName": "ic_menu", "title": "Privacy Policy"])
        itemsArr.append(["iconName": "ic_menu", "title": "Settings"])
        itemsArr.append(["iconName": "ic_menu", "title": "Signout"])
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
//            cell.textLabel?.text = itemsArr[indexPath.row]["title"]
//            if let imgName = itemsArr[indexPath.row]["iconName"] {
//                cell.imageView?.image = UIImage(named: imgName)
//            }
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
