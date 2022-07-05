//
//  AddInventoryViewController.swift
//  Meril
//
//  Created by iMac on 24/03/22.
//

import UIKit
import iOSDropDown

class AddInventoryViewController: BaseViewController {
    
    @IBOutlet weak var viewBC: UIView!
    
    @IBOutlet weak var scrollOuterView: UIView!
    @IBOutlet var collectionViewBackground: [UIView]!
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var constrainViewHeaderHeight: NSLayoutConstraint!
    @IBOutlet weak var DetailsScrollView: UIScrollView!
    var addInventoryReqObj: AddSurgeryRequestModel?

    @IBOutlet weak var txtCity: DropDown! {
        didSet {
            self.txtCity.selectedRowColor = ColorConstant.mainThemeColor// ?? UIColor.systemBlue
        }
    }
    
    @IBOutlet weak var txtHospital: DropDown! {
        didSet {
            self.txtHospital.selectedRowColor = ColorConstant.mainThemeColor// ?? UIColor.systemBlue
        }
    }
    
//    @IBOutlet weak var txtDoctor: DropDown! {
//        didSet {
//            self.txtDoctor.selectedRowColor = ColorConstant.mainThemeColor// ?? UIColor.systemBlue
//        }
//    }
//
    @IBOutlet weak var txtDistributor: DropDown! {
        didSet {
//            self.txtDistributor.isSearchEnable = false
            self.txtDistributor.selectedRowColor = ColorConstant.mainThemeColor// ?? UIColor.systemBlue
        }
    }
    
    @IBOutlet weak var txtSaleperson: DropDown! {
        didSet {
//            self.txtSaleperson.isSearchEnable = false
            self.txtSaleperson.selectedRowColor = ColorConstant.mainThemeColor// ?? UIColor.systemBlue
        }
    }
    
    
    @IBOutlet weak var btnScanNow: UIButton!
    
    var hospitalsArr: [Hospitals] = []
    var cityArr: [Cities] = []
    var distributorsArr: [Hospitals] = []
    var sales_personsArr: [SalesPerson] = []
    
    var selectedHospitalId: Int?
    var selectedCityId: Int?
    var selectedDistributorId: Int?
    var selectedSalesPersonId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.internetConnectionLost), name: .networkLost, object: nil)
        setUI()
        self.fetchFormData()
        // Do any additional setup after loading the view.
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .networkLost, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigation()
    }
    
    //MARK:- Custome Method
    func setUI(){
        self.navigationItem.title = "Physical Inventory Count"
        
        for i in collectionViewBackground{
            i.backgroundColor = ColorConstant.mainThemeColor
            i.layer.cornerRadius = i.frame.height/2
        }
        viewBC.backgroundColor = ColorConstant.mainThemeColor
        viewBC.addCornerAtBotttoms(radius: 30)
        
        btnScanNow.layer.cornerRadius = btnScanNow.frame.height/2
        self.viewHeader.backgroundColor = ColorConstant.mainThemeColor
        
        txtHospital.setPlaceholder(placeHolderStr: "Select Hospital")
//        txtDoctor.setPlaceholder(placeHolderStr: "Select Doctor")
        txtDistributor.setPlaceholder(placeHolderStr: "Select Distributor")
        txtSaleperson.setPlaceholder(placeHolderStr: "Select Saleperson")
        
        
        self.txtHospital.rowHeight = 40
//        self.txtDoctor.rowHeight = 40
        self.txtDistributor.rowHeight = 40
        self.txtSaleperson.rowHeight = 40
        
        setRightButton(txtHospital, image: UIImage(named: "ic_dropdown") ?? UIImage())
        setRightButton(txtCity, image: UIImage(named: "ic_dropdown") ?? UIImage())
        setRightButton(txtDistributor, image: UIImage(named: "ic_dropdown") ?? UIImage())
        setRightButton(txtSaleperson, image: UIImage(named: "ic_dropdown") ?? UIImage())
     
        DetailsScrollView.addCornerAtTops(radius: 20)
        
//        Add Shadow
        scrollOuterView.layer.masksToBounds = false
        scrollOuterView.layer.shadowRadius = 3
        scrollOuterView.layer.shadowOpacity = 0.5
        scrollOuterView.layer.shadowOffset = CGSize(width: 0, height: 0)
        scrollOuterView.layer.shadowColor = UIColor.black.cgColor

    }
    
    func setNavigation(){
//        settupHeaderView(childView: self.viewHeader, constrain: constrainViewHeaderHeight,title: "Add Surgeray")
//        //        navigationController?.setNavigationBarHidden(true, animated: false)
//
//        setBackButtononNavigation()
//        pressButtonOnNavigaion { (isBack) in
//            if(isBack){
//            }else{
//                _ =  self.navigationController?.popViewController(animated: true)
//            }
//        }
        GlobalFunctions.configureStatusNavBar(navController: self.navigationController!, bgColor: ColorConstant.mainThemeColor, textColor: .white)
        self.navigationItem.title = "Physical Inventory Verification"
    }
    
    @IBAction func OnClickScanNow(_ sender: UIButton) {
        self.inputValidation()
    }
    
    func inputValidation() {
        
        guard let _ = selectedHospitalId else {
            GlobalFunctions.showToast(controller: self, message: UserMessages.emptyHospitalError, seconds: errorDismissTime)
            return
        }
//
//        guard let _ = selectedDoctorId else {
//            GlobalFunctions.showToast(controller: self, message: UserMessages.emptyDoctorError, seconds: errorDismissTime)
//            return
//        }
        
        guard let _ = selectedDistributorId else {
            GlobalFunctions.showToast(controller: self, message: UserMessages.emptyDistributorError, seconds: errorDismissTime)
            return
        }
        
        guard let _ = selectedSalesPersonId else {
            GlobalFunctions.showToast(controller: self, message: UserMessages.emptySalesPersonError, seconds: errorDismissTime)
            return
        }
        
        let userId = UserDefaults.standard.integer(forKey: "userId")
        let stockId = "D\(Date.currentTimeStamp)U\(userId)"
        addInventoryReqObj = AddSurgeryRequestModel(hospitalId: selectedHospitalId, distributorId: selectedDistributorId, salesPersonId: selectedSalesPersonId, stockId: stockId)
        self.redirectToScannerVC()
        //        If there is no error while validation then redirect to scan the data
        //        let scannerVC = mainStoryboard.instantiateViewController(withIdentifier: "BarCodeScannerVC") as! BarCodeScannerVC
        //        scannerVC.delegate = self
        //        self.navigationController?.pushViewController(scannerVC, animated: true)
    }
    
    func redirectToScannerVC() {
        let vc = mainStoryboard.instantiateViewController(withIdentifier: "BarCodeScannerVC") as! BarCodeScannerVC
        vc.isFromAddSurgery = false
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension AddInventoryViewController {
    
    func fetchFormData() {
        if let formDataObj = StoreFormData.sharedInstance.fetchFormData() {
            self.setAllDropDownData(formDataResponse: formDataObj)
            return
        }
        self.fetchFormDataFromServer()
    }
    
    func fetchFormDataFromServer() {
        CommonFunctions.getAllFormData { response in
            guard let surgeryObj = response else { return }
            self.setAllDropDownData(formDataResponse: surgeryObj)
        }
    }
    
    func setAllDropDownData(formDataResponse: SurgeryInventoryModel) {
        
        //        City dropdown
        self.cityArr = formDataResponse.cities ?? []
        self.txtCity.isEnabled = !self.cityArr.isEmpty
        self.txtCity.optionArray = self.cityArr.map({ item -> String in
            item.name ?? ""
        })
        
        self.txtCity.didSelect { selectedText, index, id in
            self.selectedCityId = self.cityArr[index].id
            //            refresh hospital data when user select particular city
            self.refreshHospitalByCity(selectedCityIndex: index)
        }

        //        set distributor array
        self.distributorsArr = formDataResponse.distributors ?? []
        self.txtDistributor.isEnabled = !self.distributorsArr.isEmpty
        self.txtDistributor.optionArray = self.distributorsArr.map({ item -> String in
            item.name ?? ""
        })
        self.txtDistributor.didSelect { selectedText, index, id in
            self.selectedDistributorId = self.distributorsArr[index].id
        }
        
        //        set salesperson array
        self.sales_personsArr = formDataResponse.sales_persons ?? []
        self.txtSaleperson.isEnabled = !self.sales_personsArr.isEmpty
        self.txtSaleperson.optionArray = self.sales_personsArr.map({ item -> String in
            item.name ?? ""
        })
        self.txtSaleperson.didSelect { selectedText, index, id in
            self.selectedSalesPersonId = self.sales_personsArr[index].id
        }
        
//        self.hospitalsArr = formDataResponse.hospitals ?? []
//        self.txtHospital.isEnabled = !self.hospitalsArr.isEmpty
//        self.txtHospital.optionArray = self.hospitalsArr.map({ item -> String in
//            item.name ?? ""
//        })
//        self.txtHospital.didSelect { selectedText, index, id in
//            self.selectedHospitalId = self.hospitalsArr[index].id
//        }
        setDefaultData()
    }
    
    //   reload hospitals by city selection
    func refreshHospitalByCity(selectedCityIndex: Int) {
        self.hospitalsArr = cityArr[selectedCityIndex].hospitals ?? []
        self.txtHospital.isEnabled = !self.hospitalsArr.isEmpty
        self.txtHospital.optionArray = self.hospitalsArr.map({ item -> String in
            item.name ?? ""
        })
        self.txtHospital.didSelect { selectedText, index, id in
            self.selectedHospitalId = self.hospitalsArr[index].id
        }
        
    }
    
    private func setDefaultData() {
        guard let userTypeId = UserDefaults.standard.string(forKey: "userTypeId"), userTypeId == "2" else {
            return
        }
        
        let storedUserData = UserSessionManager.shared.userDetail

//        let userDefault = UserDefaults.standard
        //        set distributor
        if let distributorId = storedUserData?.distributor_id {
            selectedDistributorId = Int(distributorId)
            self.txtDistributor.text = distributorsArr.filter({ item in
                item.id == selectedDistributorId
            }).first?.name
        }
        
        //        set sales person
        if let salesPersonId = storedUserData?.sales_person_id {
            selectedSalesPersonId = salesPersonId
            self.txtSaleperson.text = sales_personsArr.filter({ item in
                item.id == selectedSalesPersonId
            }).first?.name
        }
        
//        if let city = storedUserData?.city {
//            let cityDetail = cityArr.filter({ item in
//                item.name == city
//            }).first
//            self.txtCity.text = cityDetail?.name
//            selectedCityId = cityDetail?.id
//        }
        
//        if (self.txtCity.text ?? "").count > 0 {
//            setRightButton(txtCity, image: UIImage(named: "ic_right") ?? UIImage())
//        }
        
        
        if (self.txtDistributor.text ?? "").count > 0 {
            setRightButton(txtDistributor, image: UIImage(named: "ic_right") ?? UIImage())
        }
        if (self.txtSaleperson.text ?? "").count > 0 {
            setRightButton(txtSaleperson, image: UIImage(named: "ic_right") ?? UIImage())
        }
    }
}

extension AddInventoryViewController: BarCodeScannerDelegate {
    
    // Call api to add Inventory with scanned barcodes and then redirect to display inventories
    func submitScannedData() {
        SHOW_CUSTOM_LOADER()
        
        let manualEntryArr: [ManualEntryModel] = UserSessionManager.shared.manualEntryData

        let barCodeArr: [BarCodeModel] = UserSessionManager.shared.barCodes
        
        let barCodeDict = barCodeArr.compactMap { $0.dict }
        let manualDataDict = manualEntryArr.compactMap { $0.dict }

//        func convertArrayToJsonString() {
        func convertArrayToJsonString(dict: [[String:Any]]) -> String? {
            if let theJSONData = try?  JSONSerialization.data(
                withJSONObject: dict,
                options: .prettyPrinted
            ),
               let theJSONText = String(data: theJSONData,
                                        encoding: String.Encoding.ascii) {
                print("JSON string = \n\(theJSONText)")
//                addInventoryReqObj?.barcodes = theJSONText
                return theJSONText
            }
            return nil
        }
        
        addInventoryReqObj?.manualEntry = convertArrayToJsonString(dict: manualDataDict)
        addInventoryReqObj?.barcodes = convertArrayToJsonString(dict: barCodeDict)

//        convertArrayToJsonString()
        GlobalFunctions.printToConsole(message: "\(addInventoryReqObj?.barcodes)")
        if appDelegate.reachability.connection == .unavailable {
            self.saveInventoryToCoreData(onSubmitAction: true)
        } else {
        self.callAddInventoryApi()
        }
    }
    
    func callAddInventoryApi() {
        guard let inventoryObj = addInventoryReqObj else { return }
        SurgeryServices.addInventoryStock(surgeryObj: inventoryObj) { response, error in
            HIDE_CUSTOM_LOADER()
            guard let err = error else {
                UserDefaults.standard.removeObject(forKey: "scannedBarcodes")
                UserDefaults.standard.removeObject(forKey: "manualEntryData")
//                self.navigationController?.popViewController(animated: true)
                self.navigationController?.popToRootViewController(animated: true)
                return
            }
            GlobalFunctions.showToast(controller: self, message: err, seconds: errorDismissTime)
            
        }
    }
    
    func saveInventoryToCoreData(onSubmitAction: Bool = false) {
        guard let stockObj = addInventoryReqObj else { return }
        //        Save records to Core data
        AddStockToCoreData.sharedInstance.saveStockData(stockData: stockObj)
        if onSubmitAction {
            HIDE_CUSTOM_LOADER()
            GlobalFunctions.showToast(controller: self, message: "Record saved successfully.", seconds: successDismissTime) {
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
    }
    
    @objc func internetConnectionLost() {
//        self.saveInventoryToCoreData()
    }
}
