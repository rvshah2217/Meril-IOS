//
//  AddInventoryViewController.swift
//  Meril
//
//  Created by iMac on 24/03/22.
//

import UIKit
//import iOSDropDown

class AddInventoryViewController: BaseViewController {
    
    @IBOutlet weak var viewBC: UIView!
    
    @IBOutlet weak var scrollOuterView: UIView!
    @IBOutlet var collectionViewBackground: [UIView]!
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var constrainViewHeaderHeight: NSLayoutConstraint!
    @IBOutlet weak var DetailsScrollView: UIScrollView!
    
    @IBOutlet weak var txtCity: UITextField!
    @IBOutlet weak var txtHospital: UITextField!
    @IBOutlet weak var txtDistributor: UITextField!
    @IBOutlet weak var txtSaleperson: UITextField!
    
    @IBOutlet weak var btnScanNow: UIButton!
    
    var addInventoryReqObj: AddSurgeryRequestModel?
    let successToastTime = 1.0
    
    var hospitalsArr: [Hospitals] = []
    var cityArr: [Cities] = []
    var distributorsArr: [Hospitals] = []
    var sales_personsArr: [SalesPerson] = []
    
    var selectedHospitalId: Int?
    var selectedCityId: Int?
    var selectedDistributorId: Int?
    var selectedSalesPersonId: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        self.fetchFormData()
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
        txtCity.setPlaceholder(placeHolderStr: "Select City")
        txtDistributor.setPlaceholder(placeHolderStr: "Select Distributor")
        txtSaleperson.setPlaceholder(placeHolderStr: "Select Saleperson")
        
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
        
        txtCity.delegate = self
        txtDistributor.delegate = self
        txtHospital.delegate = self
        txtSaleperson.delegate = self
    }
    
    func setNavigation(){
        GlobalFunctions.configureStatusNavBar(navController: self.navigationController!, bgColor: ColorConstant.mainThemeColor, textColor: .white)
        self.navigationItem.title = "Physical Inventory Verification"
    }
    
    @IBAction func OnClickScanNow(_ sender: UIButton) {
        self.inputValidation()
    }
    
    func inputValidation() {
        
        guard let _ = selectedCityId else {
            GlobalFunctions.showToast(controller: self, message: UserMessages.emptyCityError, seconds: errorDismissTime)
            return
        }
        
        guard let _ = selectedHospitalId else {
            GlobalFunctions.showToast(controller: self, message: UserMessages.emptyHospitalError, seconds: errorDismissTime)
            return
        }
        
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
        addInventoryReqObj = AddSurgeryRequestModel(hospitalId: selectedHospitalId, distributorId: selectedDistributorId, salesPersonId: selectedSalesPersonId, stockId: stockId, cityId: selectedCityId)
        addInventoryReqObj?.salesPersonName = self.txtSaleperson.text ?? ""
        addInventoryReqObj?.hospitalName = self.txtHospital.text ?? ""
        
        //        If there is no error while validation then redirect to scan the data
        self.redirectToScannerVC()
    }
    
    func redirectToScannerVC() {
        let vc = mainStoryboard.instantiateViewController(withIdentifier: "BarCodeScannerVC") as! BarCodeScannerVC
        vc.selectedSalesPersonId = selectedSalesPersonId
        vc.isFromAddSurgery = false
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension AddInventoryViewController {
    
    func fetchFormData() {
        if appDelegate.reachability.connection == .unavailable {
            if let formDataObj = StoreFormData.sharedInstance.fetchFormData() {
                self.setAllDropDownData(formDataResponse: formDataObj)
                return
            }
        } else {
            self.fetchFormDataFromServer()
        }
    }
    
    func fetchFormDataFromServer() {
        SHOW_CUSTOM_LOADER()
        CommonFunctions.getAllFormData { response in
            HIDE_CUSTOM_LOADER()
            guard let surgeryObj = response else { return }
            self.setAllDropDownData(formDataResponse: surgeryObj)
        }
    }
    
    func setAllDropDownData(formDataResponse: SurgeryInventoryModel) {
        
        //        City dropdown
        self.cityArr = formDataResponse.cities ?? []
        self.txtCity.isEnabled = !self.cityArr.isEmpty
        
        //        set distributor array
        self.distributorsArr = formDataResponse.distributors ?? []
        self.txtDistributor.isEnabled = !self.distributorsArr.isEmpty
        
        //        set salesperson array
        self.sales_personsArr = formDataResponse.sales_persons ?? []
        self.txtSaleperson.isEnabled = !self.sales_personsArr.isEmpty
        
        setDefaultData()
    }
    
    //   reload hospitals by city selection
    func refreshHospitalByCity(selectedCityIndex: Int) {
        self.hospitalsArr = cityArr[selectedCityIndex].hospitals ?? []
        self.txtHospital.isEnabled = !self.hospitalsArr.isEmpty
    }
    
    private func setDefaultData() {
        guard let userTypeId = UserDefaults.standard.string(forKey: "userTypeId"), userTypeId == "2" else {
            return
        }
        
        let storedUserData = UserSessionManager.shared.userDetail
        
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
        
        if let city = storedUserData?.city {
            for i in 0..<cityArr.count {
                let item = cityArr[i]
                if item.name == city {
                    self.txtCity.text = item.name
                    selectedCityId = item.id
                    //                    set hospital by city selection
                    if (self.txtHospital.text ?? "").count == 0 {
                        self.refreshHospitalByCity(selectedCityIndex: i)
                    }
                    break
                }
            }
        }
        
        if let hospitalId = storedUserData?.id {
            let hospitalData = hospitalsArr.filter({ item in
                item.id == hospitalId
            }).first
            self.txtHospital.text = hospitalData?.name
            selectedHospitalId = hospitalId
        }
        
        if (self.txtHospital.text ?? "").count > 0 {
            setRightButton(txtHospital, image: UIImage(named: "ic_right") ?? UIImage())
        }
        
        if (self.txtCity.text ?? "").count > 0 {
            setRightButton(txtCity, image: UIImage(named: "ic_right") ?? UIImage())
        }
        
        if (self.txtDistributor.text ?? "").count > 0 {
            setRightButton(txtDistributor, image: UIImage(named: "ic_right") ?? UIImage())
        }
        if (self.txtSaleperson.text ?? "").count > 0 {
            setRightButton(txtSaleperson, image: UIImage(named: "ic_right") ?? UIImage())
        }
    }
}

//#MARK: Scan barcode delegate
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
                return theJSONText
            }
            return nil
        }
        
        addInventoryReqObj?.manualEntry = convertArrayToJsonString(dict: manualDataDict)
        addInventoryReqObj?.barcodes = convertArrayToJsonString(dict: barCodeDict)
        
        if appDelegate.reachability.connection == .unavailable {
            self.saveInventoryToCoreData(onSubmitAction: true)
        } else {
            self.callAddInventoryApi()
        }
    }
    
    func callAddInventoryApi() {
        guard let inventoryObj = addInventoryReqObj else {
            HIDE_CUSTOM_LOADER()
            return
        }
        SurgeryServices.addInventoryStock(surgeryObj: inventoryObj) { response, error in
            HIDE_CUSTOM_LOADER()
            guard let err = error else {
                UserDefaults.standard.removeObject(forKey: "scannedBarcodes")
                UserDefaults.standard.removeObject(forKey: "manualEntryData")
                GlobalFunctions.showToast(controller: self, message: "Record saved successfully.", seconds: self.successToastTime) {
                    self.navigationController?.popToRootViewController(animated: true)
                }
                return
            }
            GlobalFunctions.showToast(controller: self, message: err, seconds: errorDismissTime)
        }
    }
    
    func saveInventoryToCoreData(onSubmitAction: Bool = false) {
        
        guard let stockObj = addInventoryReqObj else {
            HIDE_CUSTOM_LOADER()
            return
        }
        
        //        Save records to Core data
        AddStockToCoreData.sharedInstance.saveStockData(stockData: stockObj)
        HIDE_CUSTOM_LOADER()
        if onSubmitAction {
            GlobalFunctions.showToast(controller: self, message: "Record saved successfully.", seconds: self.successToastTime) {
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
    }
}

//#MARK: Textfield delegate
extension AddInventoryViewController: UITextFieldDelegate {
    
    public func  textFieldDidBeginEditing(_ textField: UITextField) {
        self.view.endEditing(true)
        let vc = mainStoryboard.instantiateViewController(withIdentifier: "DropDownMenuVC") as! DropDownMenuVC
        vc.delegate = self
        
        //MenuType: 0: city, 1: SalesPerson, 2: schemeArr, 3: gender, 4: hospital, 5: doctors, 6: distributors
        switch textField {
        case txtCity:
            vc.menuType = 0
            vc.citiesArr = cityArr
            vc.titleStr = "Select City"
            break
        case txtSaleperson:
            vc.menuType = 1
            vc.sales_personsArr = sales_personsArr
            vc.titleStr = "Select Sales Person"
            break
        case txtHospital:
            if selectedCityId == nil {
                GlobalFunctions.showToast(controller: self, message: UserMessages.priorCitySelectionError, seconds: errorDismissTime)
                return
            }
            vc.menuType = 4
            vc.objArr = hospitalsArr
            vc.titleStr = "Select Hospital"
            break
        default:
            vc.menuType = 6
            vc.objArr = distributorsArr
            vc.titleStr = "Select Distributor"
        }
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        self.navigationController?.present(vc, animated: false, completion: nil)
    }
}

//#MARK: DropDown delegate
extension AddInventoryViewController: DropDownMenuDelegate {
    
    //MenuType: 0: city, 1: SalesPerson, 2: schemeArr, 3: gender, 4: hospital, 5: doctors, 6: distributors
    func selectedDropDownItem(menuType: Int, menuObj: Any) {
        print("selected menu object: \(menuObj)")
        switch menuType {
        case 0:
            guard let obj = menuObj as? Cities else { return }
            txtCity.text = obj.name
            selectedCityId = obj.id
            let index = cityArr.firstIndex { city in
                city.id == obj.id
            }
            self.refreshHospitalByCity(selectedCityIndex: Int(index!))
            break
        case 1:
            guard let obj = menuObj as? SalesPerson else { return }
            txtSaleperson.text = obj.name
            selectedSalesPersonId = obj.id
            break
        case 4:
            guard let obj = menuObj as? Hospitals else { return }
            txtHospital.text = obj.name
            selectedHospitalId = obj.id
        default:
            guard let obj = menuObj as? Hospitals else { return }
            txtDistributor.text = obj.name
            selectedDistributorId = obj.id
        }
    }
}
