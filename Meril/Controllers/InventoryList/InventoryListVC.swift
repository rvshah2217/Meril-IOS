//
//  SurgerayListViewController.swift
//  Meril
//
//  Created by iMac on 24/03/22.
//

import UIKit

class InventoryListVC: UIViewController {
    
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var viewBK: UIView!
    @IBOutlet weak var tableOuterView: UIView!
    @IBOutlet weak var noDataFoundLbl: UIView!
    
    var inventoryArr: [SurgeryData] = []
    var filteredInventoryArr: [SurgeryData] = []
    var isFilterApplied: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.stockAddedToServer), name: .stockAdded, object: nil)
        setUI()
        fetchInventory(isUpdateUsingNotification: false)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .stockAdded, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    @IBAction func backBtnClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK:- Custome Method
    func setUI() {
        
        txtSearch.delegate = self
        txtSearch.returnKeyType = .done
        
        txtSearch.layer.cornerRadius = txtSearch.frame.height / 2
        txtSearch.backgroundColor = UIColor.white
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: txtSearch.frame.height))
        txtSearch.leftViewMode = UITextField.ViewMode.always;
        txtSearch.leftView = view;
        
        viewBK.backgroundColor = ColorConstant.mainThemeColor
        viewBK.addCornerAtBotttoms(radius: 30)
        
        tblView.register(UINib.init(nibName:"SurgeryListTableViewCell", bundle: nil), forCellReuseIdentifier: "SurgeryListTableViewCell")
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
    }
    
    @objc func stockAddedToServer(notification: NSNotification) {
        if let stockId = notification.userInfo?["stockId"] as? String {
            //            delete record from coreData
            AddStockToCoreData.sharedInstance.deleteStockByStockId(stockId: stockId)
        }
        self.fetchInventory(isUpdateUsingNotification: true)
    }
    
    func fetchStockListFromCoreData(isUpdateUsingNotification: Bool) {
        SHOW_CUSTOM_LOADER()
        self.inventoryArr = StockList_CoreData.sharedInstance.fetchStocksData() ?? []
        HIDE_CUSTOM_LOADER()
        self.fetchAddStockDataWithoutSync()
        self.noDataFoundLbl.isHidden = true
    }
    
    func fetchInventoryListFromServer(isUpdateUsingNotification: Bool = false) {
        if !isUpdateUsingNotification {
            SHOW_CUSTOM_LOADER()
        }
        SurgeryServices.getInventories { response, error in
            HIDE_CUSTOM_LOADER()
            guard let _ = error else {
                self.inventoryArr = response?.surgeryData ?? []
                self.fetchAddStockDataWithoutSync()
                self.noDataFoundLbl.isHidden = !self.inventoryArr.isEmpty
                self.tblView.reloadData()
                //                save response to the coreData
                StockList_CoreData.sharedInstance.saveStocksToCoreData(schemeData: self.inventoryArr, isForceSave: true)
                return
            }
            self.noDataFoundLbl.isHidden = !self.inventoryArr.isEmpty
        }
    }
    
    private func fetchInventory(isUpdateUsingNotification: Bool) {
        if appDelegate.reachability.connection == .unavailable {
            self.fetchStockListFromCoreData(isUpdateUsingNotification: isUpdateUsingNotification)
        } else {
            self.fetchInventoryListFromServer(isUpdateUsingNotification: isUpdateUsingNotification)
        }
    }
    
    //    Fetch stock data from server whose sync status is false and then append it to the current stockArr to make it easier to handle UI
    func fetchAddStockDataWithoutSync() {
        var stockArrWithSyncFalse = AddStockToCoreData.sharedInstance.fetchStocks() ?? []
        if self.inventoryArr.isEmpty {
            self.inventoryArr = stockArrWithSyncFalse
        } else {
            stockArrWithSyncFalse += inventoryArr
            inventoryArr = stockArrWithSyncFalse
        }
        self.tblView.reloadData()
    }
}
extension InventoryListVC:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isFilterApplied ? filteredInventoryArr.count : inventoryArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let itemDetail = isFilterApplied ? filteredInventoryArr[indexPath.row] : inventoryArr[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "SurgeryListTableViewCell") as! SurgeryListTableViewCell
        cell.patientNameLbl.isHidden = true
        cell.doctorNameLbl.isHidden = true
        
        if let addSurgeryObj = itemDetail.addSurgeryTempObj {
            cell.isOfflineData = true
            cell.surgeryOrStockIdLbl.text = "Inventory Code: " + (addSurgeryObj.surgeryId ?? "N/A")
            cell.lblDate.text = "Date: " + (addSurgeryObj.DeploymentDate ?? "\(Date())")
            
            //            Set hospital name
            cell.hospitalNameLbl.text = "Hospital: " + (addSurgeryObj.hospitalName ?? "N/A")
            
            //            Set sales person name
            cell.salesPersonLbl.text = "Sales person: " + (addSurgeryObj.salesPersonName ?? "N/A")
        } else {
            cell.isOfflineData = false
            cell.surgeryOrStockIdLbl.text = "Inventory Code: " + (itemDetail.unique_id ?? "N/A")
            cell.lblDate.text = "Date: " + (itemDetail.created_at ?? "\(Date())")
            
            //            Set hospital name
            cell.hospitalNameLbl.text = "Hospital: " + (itemDetail.hospital?.Account_Name ?? "N/A")
            
            //            Set sales person name
            cell.salesPersonLbl.text = "Sales person: " + (itemDetail.sales_person?.fullname ?? "N/A")
        }
        if let barCodeStatus = itemDetail.status, barCodeStatus != "done" {
            cell.viewMain.layer.borderColor = UIColor.red.cgColor
            cell.barCodeStatus.isHidden = false
            cell.barCodeStatus.text = "Status: " + barCodeStatus
        } else {
            cell.viewMain.layer.borderColor = ColorConstant.mainThemeColor.cgColor
            cell.barCodeStatus.isHidden = true
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = isFilterApplied ? filteredInventoryArr[indexPath.row] : inventoryArr[indexPath.row]
        let vc = BarCodeListVC()//nibName: "BarCodeListVC", bundle: nil)
        
        if item.addSurgeryTempObj == nil {
            vc.barCodesArr = item.scans ?? []
        }  else {
            vc.offlineBarCodesArr = item.addSurgeryTempObj?.coreDataBarcodes ?? []
            vc.manualBarCodesArr = item.addSurgeryTempObj?.manualEntryCodes ?? []
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension InventoryListVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        isFilterApplied = (textField.text ?? "").count > 0
        self.filteredArrOnSearch()
        return true
    }
    
    func filteredArrOnSearch() {
        let searchStr = txtSearch.text ?? ""
        filteredInventoryArr = inventoryArr.filter {
            if let addSurgeryObj = $0.addSurgeryTempObj {
                return (addSurgeryObj.surgeryId ?? "").localizedCaseInsensitiveContains(searchStr) || (addSurgeryObj.hospitalName ?? "").localizedCaseInsensitiveContains(searchStr) || (addSurgeryObj.salesPersonName ?? "").localizedCaseInsensitiveContains(searchStr)
            } else {
                return ($0.unique_id ?? "").localizedCaseInsensitiveContains(searchStr) || ($0.hospital?.Account_Name ?? "").localizedCaseInsensitiveContains(searchStr) || ($0.sales_person?.fullname ?? "").localizedCaseInsensitiveContains(searchStr)
            }
        }
        self.noDataFoundLbl.isHidden = !(isFilterApplied && self.filteredInventoryArr.isEmpty)
        self.tblView.reloadData()
    }
}
