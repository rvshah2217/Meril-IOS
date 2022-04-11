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
   
    var stockArrWithSyncFalse: [AddSurgeryRequestModel] = []
//    var hospitalsArr: [Hospitals] = []
//    var doctorsArr: [Hospitals] = []
//    var salesPersonsArr: [Hospitals] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.stockAddedToServer), name: .stockAdded, object: nil)
        setUI()
//        fetch hospital, doctor and sales person data from local database
//        self.fetchStaticDataFromCoreData()
//        self.fetchInventoryList()
        if appDelegate.reachability.connection == .unavailable {
            self.fetchStockListFromCoreData(isUpdateUsingNotification: false)
        } else {
            self.fetchInventoryListFromServer(isUpdateUsingNotification: false)
        }
        fetchAddStockDataWithoutSync()
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
    
    @objc func stockAddedToServer(notification: NSNotification) {
        if let stockId = notification.userInfo?["stockId"] as? String {
            //            delete record from coreData
            AddStockToCoreData.sharedInstance.deleteStockByStockId(stockId: stockId)
        }
        self.fetchStockListFromCoreData(isUpdateUsingNotification: true)
    }
    
//    func fetchStaticDataFromCoreData() {
//        if let formDataObj = StoreFormData.sharedInstance.fetchFormData() {
//            self.hospitalsArr = formDataObj.hospitals ?? []
//            self.doctorsArr = formDataObj.doctors ?? []
//            self.salesPersonsArr = formDataObj.sales_persons ?? []
//            self.doctorsArr = formDataObj.doctors ?? []
//        }
//    }
    
    func fetchStockListFromCoreData(isUpdateUsingNotification: Bool) {
        SHOW_CUSTOM_LOADER()
        self.inventoryArr = StockList_CoreData.sharedInstance.fetchStocksData() ?? []
        if self.inventoryArr.isEmpty {
            self.fetchInventoryListFromServer(isUpdateUsingNotification: isUpdateUsingNotification)
            return
        }
        HIDE_CUSTOM_LOADER()
        self.fetchAddStockDataWithoutSync()
        self.noDataFoundLbl.isHidden = true
//        self.tblView.reloadData()
    }
    
    func fetchInventoryListFromServer(isUpdateUsingNotification: Bool = false) {
        SHOW_CUSTOM_LOADER()
        SurgeryServices.getInventories { response, error in
            HIDE_CUSTOM_LOADER()
            guard let err = error else {
                self.inventoryArr = response?.surgeryData ?? []
                self.fetchAddStockDataWithoutSync()
                self.noDataFoundLbl.isHidden = !self.inventoryArr.isEmpty
//                self.tblView.reloadData()
                if isUpdateUsingNotification {
                    DispatchQueue.global(qos: .background).async {
                        self.tblView.reloadData()
                        //                save response to the coreData
                        StockList_CoreData.sharedInstance.saveStocksToCoreData(schemeData: self.inventoryArr, isForceSave: true)
                    }
                } else {
                    self.tblView.reloadData()
                    //                save response to the coreData
                    StockList_CoreData.sharedInstance.saveStocksToCoreData(schemeData: self.inventoryArr, isForceSave: true)
                }

                return
            }
            GlobalFunctions.printToConsole(message: "Unable to fetch surgeries: \(err)")
        }
    }
    
    //    Fetch stock data from server whose sync status is false and then append it to the current stockArr to make it easier to handle UI
    func fetchAddStockDataWithoutSync() {
        stockArrWithSyncFalse = AddStockToCoreData.sharedInstance.fetchStocks() ?? []
        for surgery in stockArrWithSyncFalse { //.reversed() {
            var surgeryObj = SurgeryData()
            surgeryObj.addSurgeryTempObj = surgery
            self.inventoryArr.insert(surgeryObj, at: 0)
        }
        GlobalFunctions.printToConsole(message: "self.surgeryArr.count: \(self.inventoryArr.count)")
        self.tblView.reloadData()
    }
}
extension InventoryListVC:UITableViewDelegate,UITableViewDataSource{

    func numberOfSections(in tableView: UITableView) -> Int {
        return isFilterApplied ? filteredInventoryArr.count : inventoryArr.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return isFilterApplied ? filteredInventoryArr.count : inventoryArr.count
        let item = isFilterApplied ? filteredInventoryArr[section] : inventoryArr[section]
        if let addSurgeryObj = item.addSurgeryTempObj {
            return (addSurgeryObj.coreDataBarcodes ?? []).count
        }
        return (item.scans ?? []).count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let itemSectionData = isFilterApplied ? filteredInventoryArr[indexPath.section] : inventoryArr[indexPath.section]
        if let addSurgeryObj = itemSectionData.addSurgeryTempObj, let barcodes = addSurgeryObj.coreDataBarcodes {
            let cell = tableView.dequeueReusableCell(withIdentifier: "syncCell") as! SyncCell
            let item = barcodes[indexPath.row]
            cell.barCodeLbl.text = "Barcode: " + item.barcode
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SurgeryListTableViewCell") as! SurgeryListTableViewCell
            cell.patientNameLbl.isHidden = true
            cell.doctorNameLbl.isHidden = true
            //        cell.itemDetail = isFilterApplied ? filteredInventoryArr[indexPath.row] : inventoryArr[indexPath.row]
            cell.surgeryOrStockIdLbl.text = "Stock id: " + (itemSectionData.unique_id ?? "N/A")
            cell.lblDate.text = "Date: " + (itemSectionData.created_at ?? "N/A")
            
            //            Set hospital name
            cell.hospitalNameLbl.text = "Hospital: " + (itemSectionData.hospital?.Account_Name ?? "N/A")
            
            //            Set sales person name
            cell.salesPersonLbl.text = "Sales person: " + (itemSectionData.sales_person?.name ?? "N/A")
            if let scans = itemSectionData.scans {
                let itemSubData = scans[indexPath.row] 
                cell.lblBarCode.text = "Barcode: " + (itemSubData.barcode ?? "N/A")
                if let barCodeStatus = itemSubData.status, barCodeStatus == "invalid_barcode" {
                    cell.viewMain.layer.borderColor = UIColor.red.cgColor
                    cell.barCodeStatus.isHidden = false
                } else {
                    cell.viewMain.layer.borderColor = ColorConstant.mainThemeColor.cgColor
                    cell.barCodeStatus.isHidden = true
                }
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
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
            ($0.patient_name ?? "").localizedCaseInsensitiveContains(searchStr)
        }
        self.noDataFoundLbl.isHidden = !(isFilterApplied && self.filteredInventoryArr.isEmpty)
        self.tblView.reloadData()
    }
}
