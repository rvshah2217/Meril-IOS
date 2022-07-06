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
//    var hospitalsArr: [Hospitals] = []
//    var doctorsArr: [Hospitals] = []
//    var salesPersonsArr: [Hospitals] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        NotificationCenter.default.addObserver(self, selector: #selector(self.surgeryAddedToServer), name: .surgeryAdded, object: nil)
//        self.fetchStaticDataFromCoreData()
        //        self.fetchAddSurgeryDataWithoutSync()
        if appDelegate.reachability.connection == .unavailable {
            self.fetchSurgeryListFromCoreData(isUpdateUsingNotification: false)
        } else {
            self.fetchSurgeryListFromServer(isUpdateUsingNotification: false)
        }
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
        self.fetchSurgeryListFromCoreData(isUpdateUsingNotification: true)
    }
    
    func fetchSurgeryListFromCoreData(isUpdateUsingNotification: Bool) {
        SHOW_CUSTOM_LOADER()
        self.surgeryArr = SurgeryList_CoreData.sharedInstance.fetchSurgeryData() ?? []
        if self.surgeryArr.isEmpty {
            self.fetchSurgeryListFromServer(isUpdateUsingNotification: isUpdateUsingNotification)
            return
        }
        HIDE_CUSTOM_LOADER()
        self.fetchAddSurgeryDataWithoutSync()
        self.noDataFoundLbl.isHidden = true
        self.tblView.reloadData()
    }
    
//    func fetchStaticDataFromCoreData() {
//        if let formDataObj = StoreFormData.sharedInstance.fetchFormData() {
//            self.hospitalsArr = formDataObj.hospitals ?? []
//            self.doctorsArr = formDataObj.doctors ?? []
//            self.salesPersonsArr = formDataObj.sales_persons ?? []
//            self.doctorsArr = formDataObj.doctors ?? []
//        }
//    }
    
    //    Fetch surgery from server
    func fetchSurgeryListFromServer(isUpdateUsingNotification: Bool = false) {
        SHOW_CUSTOM_LOADER()
        SurgeryServices.getSurgeries { response, error in
            HIDE_CUSTOM_LOADER()
            guard let err = error else {
                self.surgeryArr = response?.surgeryData ?? []
                self.fetchAddSurgeryDataWithoutSync()
                self.noDataFoundLbl.isHidden = !self.surgeryArr.isEmpty
//                if isUpdateUsingNotification {
//                    DispatchQueue.global(qos: .background).async {
                        self.tblView.reloadData()
                        //                save response to the coreData
                        SurgeryList_CoreData.sharedInstance.saveSurgeriesToCoreData(schemeData: self.surgeryArr, isForceSave: true)
//                    }
//                } else {
//                    self.tblView.reloadData()
//                    //                save response to the coreData
//                    SurgeryList_CoreData.sharedInstance.saveSurgeriesToCoreData(schemeData: self.surgeryArr, isForceSave: true)
//                }
                return
            }
            GlobalFunctions.printToConsole(message: "Unable to fetch surgeries: \(err)")
        }
    }
    
    //    Fetch surgery data from server whose sync status is false and then append it to the current surgeryArr to make it easier to handle UI
    func fetchAddSurgeryDataWithoutSync() {
        GlobalFunctions.printToConsole(message: "before self.surgeryArr.count: \(self.surgeryArr.count)")
        var surgeryOfflineData = AddSurgeryToCoreData.sharedInstance.fetchSurgeries() ?? []
        if self.surgeryArr.isEmpty {
            self.surgeryArr = surgeryOfflineData
        } else {
            GlobalFunctions.printToConsole(message: "before merging total rows: \(surgeryArr.count)")
            surgeryOfflineData += surgeryArr
            surgeryArr = surgeryOfflineData
            GlobalFunctions.printToConsole(message: "After merging total rows: \(surgeryArr.count)")
        }
//        surgeryArrWithSyncFalse = AddSurgeryToCoreData.sharedInstance.fetchSurgeries() ?? []
//        for surgery in surgeryArrWithSyncFalse {//.reversed() {
//            var surgeryObj = SurgeryData()
//            surgeryObj.addSurgeryTempObj = surgery
//            self.surgeryArr.insert(surgeryObj, at: 0)
//        }
        GlobalFunctions.printToConsole(message: "self.surgeryArr.count: \(self.surgeryArr.count)")
        self.tblView.reloadData()
    }
    
}
extension SurgeryListViewController: UITableViewDelegate,UITableViewDataSource{
    
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return isFilterApplied ? filteredSurgeryArr.count : surgeryArr.count
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        let item = isFilterApplied ? filteredSurgeryArr[section] : surgeryArr[section]
//        if let addSurgeryObj = item.addSurgeryTempObj {
//            return (addSurgeryObj.coreDataBarcodes ?? []).count
//        }
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
            cell.salesPersonLbl.text = "Sales person: " + (addSurgeryObj.salesPersonName ?? "N/A")//(itemDetail.sales_person?.fullname ?? "N/A")
            cell.lblBarCode.isHidden = true
            cell.barCodeStatus.isHidden = true
            cell.patientNameLbl.text = addSurgeryObj.patientName
            cell.doctorNameLbl.text = addSurgeryObj.doctorName
        } else {
            cell.isOfflineData = false
            cell.surgeryItemDetail = itemSectionData
        }
//            cell.surgeryOrStockIdLbl.text = "Surgery id: " + (itemSectionData.surgery_id ?? "N/A")
//            cell.lblDate.text = "Date: " + (itemSectionData.created_at ?? "N/A")
//            cell.patientNameLbl.text = "Patient name: " + (itemSectionData.patient_name ?? "N/A")
//
//            //            Set hospital name
//            cell.hospitalNameLbl.text = "Hospital: " + (itemSectionData.hospital?.Account_Name ?? "N/A")
//            cell.hospitalNameLbl.numberOfLines = 2
//
//            //            Set sales person name
//            cell.salesPersonLbl.text = "Sales person: " + (itemSectionData.sales_person?.fullname ?? "N/A")
//            cell.lblBarCode.isHidden = true
//            cell.barCodeStatus.isHidden = true
//            //            Set doctor name
//            cell.doctorNameLbl.text = "Doctor: " + (itemSectionData.doctor?.Full_Name ?? "N/A")

            return cell
//        }
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
            ($0.patient_name ?? "").localizedCaseInsensitiveContains(searchStr)
        }
        self.noDataFoundLbl.isHidden = !(isFilterApplied && self.filteredSurgeryArr.isEmpty)
        
        self.tblView.reloadData()
    }
}
