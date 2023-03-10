//
//  SurgerayListViewController.swift
//  Meril
//
//  Created by iMac on 24/03/22.
//

import UIKit
import Foundation

class SurgeryListViewController: UIViewController {
    
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var viewBK: UIView!
    @IBOutlet weak var tableOuterView: UIView!
    @IBOutlet weak var noDataFoundLbl: UIView!
    
    var surgeryArr: [SurgeryData] = []
    var filteredSurgeryArr: [SurgeryData] = []
    var isFilterApplied: Bool = false
    
    var surgeryArrWithSyncFalse: [AddSurgeryRequestModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        self.navigationController?.navigationBar.backItem?.title = ""
        NotificationCenter.default.addObserver(self, selector: #selector(self.surgeryAddedToServer), name: .surgeryAdded, object: nil)
        self.fetchSurgeries(isUpdateUsingNotification: false)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .surgeryAdded, object: nil)
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
    func setUI(){
        self.navigationItem.title = "Surgery Tracker"
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
    }
    
    @objc func surgeryAddedToServer(notification: NSNotification) {
        if let surgeryID = notification.userInfo?["surgeryId"] as? String {
            print("Surgery id should be deleted is: \(surgeryID)")
            //            delete record from coreData
            AddSurgeryToCoreData.sharedInstance.deleteSergeryBySurgeryId(surgeryId: surgeryID)
        }
        self.fetchSurgeries(isUpdateUsingNotification: true)
    }
    
    private func fetchSurgeries(isUpdateUsingNotification: Bool) {
        if appDelegate.reachability.connection == .unavailable {
            self.fetchSurgeryListFromCoreData(isUpdateUsingNotification: isUpdateUsingNotification)
        } else {
            self.fetchSurgeryListFromServer(isUpdateUsingNotification: isUpdateUsingNotification)
        }
    }
    
    func fetchSurgeryListFromCoreData(isUpdateUsingNotification: Bool) {
        SHOW_CUSTOM_LOADER()
        self.surgeryArr = SurgeryList_CoreData.sharedInstance.fetchSurgeryData() ?? []
        
        HIDE_CUSTOM_LOADER()
        self.fetchAddSurgeryDataWithoutSync()
        self.noDataFoundLbl.isHidden = true
    }
    
    //    Fetch surgery from server
    func fetchSurgeryListFromServer(isUpdateUsingNotification: Bool = false) {
        
        if !isUpdateUsingNotification {
            SHOW_CUSTOM_LOADER()
        }
        
        SurgeryServices.getSurgeries { response, error in
            HIDE_CUSTOM_LOADER()
            guard let err = error else {
                self.surgeryArr = response?.surgeryData ?? []
                self.fetchAddSurgeryDataWithoutSync()
                self.noDataFoundLbl.isHidden = !self.surgeryArr.isEmpty
                self.tblView.reloadData()
                //                save response to the coreData
                SurgeryList_CoreData.sharedInstance.saveSurgeriesToCoreData(schemeData: self.surgeryArr, isForceSave: true)
                return
            }
            self.noDataFoundLbl.isHidden = !self.surgeryArr.isEmpty
        }
    }
    
    //    Fetch surgery data from server whose sync status is false and then append it to the current surgeryArr to make it easier to handle UI
    func fetchAddSurgeryDataWithoutSync() {
        var surgeryOfflineData = AddSurgeryToCoreData.sharedInstance.fetchSurgeries() ?? []
        if self.surgeryArr.isEmpty {
            self.surgeryArr = surgeryOfflineData
        } else {
            //            We need data at first which are not synced yet
            surgeryOfflineData += surgeryArr
            surgeryArr = surgeryOfflineData
        }
        self.tblView.reloadData()
    }
    
}
extension SurgeryListViewController: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isFilterApplied ? filteredSurgeryArr.count : surgeryArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let itemSectionData = isFilterApplied ? filteredSurgeryArr[indexPath.row] : surgeryArr[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SurgeryListTableViewCell") as! SurgeryListTableViewCell
        if let addSurgeryObj = itemSectionData.addSurgeryTempObj {
            cell.isOfflineData = true
            cell.surgeryOrStockIdLbl.text = "Inventory Code: " + (addSurgeryObj.surgeryId ?? "N/A")
            cell.lblDate.text = "Date: " + (addSurgeryObj.DeploymentDate ?? "\(Date())")
            
            //            Set hospital name
            cell.hospitalNameLbl.text = "Hospital: " + (addSurgeryObj.hospitalName ?? "N/A")
            
            //            Set sales person name
            cell.salesPersonLbl.text = "Sales person: " + (addSurgeryObj.salesPersonName ?? "N/A")
            cell.lblBarCode.isHidden = true
            cell.barCodeStatus.isHidden = true
            cell.patientNameLbl.text = "Patient name: " + (addSurgeryObj.patientName ?? "N/A")
            cell.doctorNameLbl.text = "Doctor: " + (addSurgeryObj.doctorName ?? "N/A")
        } else {
            cell.isOfflineData = false
            cell.surgeryItemDetail = itemSectionData
        }
        
        if let barCodeStatus = itemSectionData.status, barCodeStatus != "done" {
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
        let item = isFilterApplied ? filteredSurgeryArr[indexPath.row] : surgeryArr[indexPath.row]
        let vc = BarCodeListVC()//nibName: "BarCodeListVC", bundle: nil)
        if item.addSurgeryTempObj == nil {
            vc.barCodesArr = item.scans ?? []
        } else {
            vc.offlineBarCodesArr = item.addSurgeryTempObj?.coreDataBarcodes ?? []
            vc.manualBarCodesArr = item.addSurgeryTempObj?.manualEntryCodes ?? []
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension SurgeryListViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        isFilterApplied = (textField.text ?? "").count > 0
        self.filteredArrOnSearch()
        return true
    }
    
    func filteredArrOnSearch() {
        let searchStr = txtSearch.text ?? ""
        filteredSurgeryArr = surgeryArr.filter {
            if let addSurgeryObj = $0.addSurgeryTempObj {
                return (addSurgeryObj.surgeryId ?? "").localizedCaseInsensitiveContains(searchStr) || (addSurgeryObj.hospitalName ?? "").localizedCaseInsensitiveContains(searchStr) || (addSurgeryObj.salesPersonName ?? "").localizedCaseInsensitiveContains(searchStr) ||
                (addSurgeryObj.doctorName ?? "").localizedCaseInsensitiveContains(searchStr)
            } else {
                return ($0.surgery_id ?? "").localizedCaseInsensitiveContains(searchStr) || ($0.hospital?.Account_Name ?? "").localizedCaseInsensitiveContains(searchStr) || ($0.sales_person?.fullname ?? "").localizedCaseInsensitiveContains(searchStr) || ($0.doctor?.Full_Name ?? "").localizedCaseInsensitiveContains(searchStr)
            }
        }
        self.noDataFoundLbl.isHidden = !(isFilterApplied && self.filteredSurgeryArr.isEmpty)
        self.tblView.reloadData()
    }
}
