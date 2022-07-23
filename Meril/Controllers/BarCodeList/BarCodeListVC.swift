//
//  BarCodeListVC.swift
//  Meril
//
//  Created by Nidhi Suhagiya on 11/04/22.
//

import UIKit

class BarCodeListVC: UIViewController {
    
//    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var viewBg: UIView!
    @IBOutlet weak var tableOuterView: UIView!
    @IBOutlet weak var noDataFoundLbl: UIView!

    var barCodesArr: [Scans] = []
    var offlineBarCodesArr: [BarCodeModel] = []
    var manualBarCodesArr: [ManualEntryModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    //MARK:- Custome Method
    func setUI() {
        GlobalFunctions.configureStatusNavBar(navController: self.navigationController!, bgColor: ColorConstant.mainThemeColor, textColor: UIColor.white)
        self.navigationItem.title = "Barcodes"
        viewBg.backgroundColor = ColorConstant.mainThemeColor
        viewBg.addCornerAtBotttoms(radius: 30)

        tblView.register(UINib.init(nibName:"SurgeryListTableViewCell", bundle: nil), forCellReuseIdentifier: "SurgeryListTableViewCell")
        tblView.register(UINib.init(nibName:"SyncCell", bundle: nil), forCellReuseIdentifier: "syncCell")
        tblView.delegate = self
        tblView.dataSource = self
        tblView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)

        tblView.addCornerAtTops(radius: 20)
        
        //        Add Shadow
        tableOuterView.layer.masksToBounds = false
        tableOuterView.layer.shadowRadius = 3
        tableOuterView.layer.shadowOpacity = 0.5
        tableOuterView.layer.shadowOffset = CGSize(width: 0, height: 0)
        tableOuterView.layer.shadowColor = UIColor.black.cgColor
        
        if barCodesArr.isEmpty && offlineBarCodesArr.isEmpty && manualBarCodesArr.isEmpty {
            noDataFoundLbl.isHidden = false
        }
    }
    
}

extension BarCodeListVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if !barCodesArr.isEmpty {
            return 1
        }
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !barCodesArr.isEmpty {
            return barCodesArr.count
        } else {
            switch section {
            case 0:
                return manualBarCodesArr.count
            default:
                return offlineBarCodesArr.count
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if !barCodesArr.isEmpty {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SurgeryListTableViewCell") as! SurgeryListTableViewCell
            cell.barCodeDetail = barCodesArr[indexPath.row]
            return cell
        } else {
            switch indexPath.section {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: "SurgeryListTableViewCell") as! SurgeryListTableViewCell
                let item = manualBarCodesArr[indexPath.row]
                cell.barCodeDetail = Scans(product_code: item.sku, exp_date: item.expiry, batch_no: item.batch, serial_no: item.serial)
                return cell
            default:
                let cell = tableView.dequeueReusableCell(withIdentifier: "syncCell") as! SyncCell
                let item = offlineBarCodesArr[indexPath.row]
                cell.barCodeLbl.text = "Barcode: " + item.barcode
                return cell
            }
        }
//        if !manualBarCodesArr.isEmpty {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "SurgeryListTableViewCell") as! SurgeryListTableViewCell
//            let item = manualBarCodesArr[indexPath.row]
//            cell.barCodeDetail = Scans(product_code: item.sku, exp_date: item.expiry, batch_no: item.batch, serial_no: item.serial)           
//            return cell
//        } else {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "syncCell") as! SyncCell
//            let item = offlineBarCodesArr[indexPath.row]
//            cell.barCodeLbl.text = "Barcode: " + item.barcode
//            return cell
//        }

    }
}
