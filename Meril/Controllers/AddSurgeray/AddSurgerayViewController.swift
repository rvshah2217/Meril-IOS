//
//  AddSurgerayViewController.swift
//  NextPhysique
//
//  Created by iMac on 23/03/22.
//  Copyright © 2022 Sensussoft. All rights reserved.
//

import UIKit
import iOSDropDown
import Reachability

class AddSurgerayViewController: BaseViewController {
    @IBOutlet weak var viewBC: UIView!
    
    @IBOutlet weak var scrollOuterView: UIView!
    @IBOutlet var collectionViewBackground: [UIView]!
    @IBOutlet var collectionViewBoarder: [UIView]!
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var constrainViewHeaderHeight: NSLayoutConstraint!
    @IBOutlet weak var DetailsScrollView: UIScrollView!
    let successToastTime = 1.0
    
    @IBOutlet weak var txtGender: UITextField!
    @IBOutlet weak var txtCity: UITextField!
    @IBOutlet weak var txtHospital: UITextField!
    @IBOutlet weak var txtDoctor: UITextField!
    @IBOutlet weak var txtDistributor: UITextField!
    @IBOutlet weak var txtSaleperson: UITextField!
    @IBOutlet weak var txtPatientScheme: UITextField!
//
//    @IBOutlet weak var genderDropDown: DropDown! {
//        didSet {
//            self.genderDropDown.selectedRowColor = ColorConstant.mainThemeColor// ?? UIColor.systemBlue
//        }
//    }
//
//    @IBOutlet weak var txtCity: DropDown! {
//        didSet {
//            self.txtCity.selectedRowColor = ColorConstant.mainThemeColor// ?? UIColor.systemBlue
//        }
//    }
//
//    @IBOutlet weak var txtHospital: DropDown! {
//        didSet {
//            //            self.txtHospital.isSearchEnable = false
//            self.txtHospital.selectedRowColor = ColorConstant.mainThemeColor// ?? UIColor.systemBlue
//        }
//    }
//
//    @IBOutlet weak var txtDoctor: DropDown! {
//        didSet {
//            self.txtDoctor.selectedRowColor = ColorConstant.mainThemeColor// ?? UIColor.systemBlue
//        }
//    }
//
//    @IBOutlet weak var txtDistributor: DropDown! {
//        didSet {
//            self.txtDistributor.selectedRowColor = ColorConstant.mainThemeColor// ?? UIColor.systemBlue
//        }
//    }
//
//    @IBOutlet weak var txtSaleperson: DropDown! {
//        didSet {
//            self.txtSaleperson.selectedRowColor = ColorConstant.mainThemeColor// ?? UIColor.systemBlue
//        }
//    }
//
//    @IBOutlet weak var txtPatientScheme: DropDown! {
//        didSet {
//            self.txtPatientScheme.isSearchEnable = false
//            self.txtPatientScheme.selectedRowColor = ColorConstant.mainThemeColor// ?? UIColor.systemBlue
//        }
//    }
//
    
    @IBOutlet weak var txtPatientName: UITextField!
    @IBOutlet weak var txtPatientNumber: UITextField!
    @IBOutlet weak var txtPatientAge: UITextField!
    @IBOutlet weak var txtIpCode: UITextField!
    @IBOutlet weak var btnScanNow: UIButton!
    @IBOutlet weak var deploymentDateTxt: UITextField!
    
    var citiesArr : [Cities] = []
    var hospitalsArr: [Hospitals] = []
    var doctorsArr: [Hospitals] = []
    var distributorsArr: [Hospitals] = []
    var sales_personsArr: [SalesPerson] = []
    var schemeArr: [Schemes] = []
    var genderArr: [String] = ["Male", "Female"]
    
    var selectedCityId: Int?
    var selectedHospitalId: Int?
    var selectedDoctorId: Int?
    var selectedDistributorId: Int?
    var selectedSalesPersonId: String?
    var selectedSchemeId: Int?
    var selectedGender: String?
    var addSurgeryReqObj: AddSurgeryRequestModel?
    var datePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        NotificationCenter.default.addObserver(self, selector: #selector(self.internetConnectionLost), name: .networkLost, object: nil)
        setUI()
        self.setDatePicker()
        self.fetchFormData()
    }
    
//    deinit {
//        NotificationCenter.default.removeObserver(self, name: .networkLost, object: nil)
//    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigation()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        NotificationCenter.default.removeObserver(self, name: .networkLost, object: nil)
    }
    
    //MARK:- Custome Method
    func setUI() {
        self.navigationItem.title = ""
        for i in collectionViewBoarder {
            i.layer.borderColor = ColorConstant.mainThemeColor.cgColor
            i.layer.borderWidth = 1
            i.layer.cornerRadius = i.frame.height/2
            i.backgroundColor = UIColor.white
        }
        for i in collectionViewBackground {
            i.backgroundColor = ColorConstant.mainThemeColor
            i.layer.cornerRadius = i.frame.height/2
        }
        viewBC.backgroundColor = ColorConstant.mainThemeColor
        viewBC.addCornerAtBotttoms(radius: 30)
        
        btnScanNow.layer.cornerRadius = btnScanNow.frame.height/2
        self.viewHeader.backgroundColor = ColorConstant.mainThemeColor
        
        txtCity.setPlaceholder(placeHolderStr: "Select City")
        txtHospital.setPlaceholder(placeHolderStr: "Select Hospital")
        txtDistributor.setPlaceholder(placeHolderStr: "Select Distributor")
        txtSaleperson.setPlaceholder(placeHolderStr: "Select Saleperson")
        txtGender.setPlaceholder(placeHolderStr: "Select Gender", textColor: ColorConstant.mainThemeColor)
        txtPatientScheme.setPlaceholder(placeHolderStr: "Select Scheme", textColor: ColorConstant.mainThemeColor)
        txtDoctor.setPlaceholder(placeHolderStr: "Select Doctor", textColor: ColorConstant.mainThemeColor)
        
//        self.txtCity.rowHeight = 40
//        self.txtHospital.rowHeight = 40
//        self.txtDoctor.rowHeight = 40
//        self.txtDistributor.rowHeight = 40
//        self.txtSaleperson.rowHeight = 40
//        self.txtPatientScheme.rowHeight = 40
//        self.genderDropDown.rowHeight = 40
        self.txtCity.delegate = self
        self.txtHospital.delegate = self
        self.txtDoctor.delegate = self
        self.txtDistributor.delegate = self
        self.txtSaleperson.delegate = self
        self.txtPatientScheme.delegate = self
        self.txtGender.delegate = self
        
        setRightButton(txtCity, image: UIImage(named: "ic_dropdown") ?? UIImage())
        setRightButton(txtHospital, image: UIImage(named: "ic_dropdown") ?? UIImage())
        setRightButton(txtDistributor, image: UIImage(named: "ic_dropdown") ?? UIImage())
        setRightButton(txtSaleperson, image: UIImage(named: "ic_dropdown") ?? UIImage())
        //        setRightButton(txtUDT, image: UIImage(named: "ic_dropdown") ?? UIImage())
        let img = UIImage(named: "ic_dropdown")?.withRenderingMode(.alwaysTemplate)
        
        let imgView: UIImageView = UIImageView(image: img)
        imgView.tintColor = ColorConstant.mainThemeColor
        setBlueArrowRightButton(txtDoctor, imageView: imgView)
        
        let imgView1: UIImageView = UIImageView(image: img)
        imgView1.tintColor = ColorConstant.mainThemeColor
        setBlueArrowRightButton(txtGender, imageView: imgView1)
        
        let imgView2: UIImageView = UIImageView(image: img)
        imgView2.tintColor = ColorConstant.mainThemeColor
        setBlueArrowRightButton(txtPatientScheme, imageView: imgView2)
        
        let imgView3: UIImageView = UIImageView(image: img)
        imgView3.tintColor = ColorConstant.mainThemeColor
        setBlueArrowRightButton(deploymentDateTxt, imageView: imgView3)
        
        deploymentDateTxt.attributedPlaceholder = NSAttributedString(
            string: "Select deployment date",
            attributes: [NSAttributedString.Key.foregroundColor: ColorConstant.mainThemeColor.withAlphaComponent(0.5)]
        )
        
        txtPatientName.attributedPlaceholder = NSAttributedString(
            string: "Patient Name",
            attributes: [NSAttributedString.Key.foregroundColor: ColorConstant.mainThemeColor.withAlphaComponent(0.5)]
        )
        
        txtPatientNumber.attributedPlaceholder = NSAttributedString(          string: "Patient Mobile Number",
                                                                              attributes: [NSAttributedString.Key.foregroundColor: ColorConstant.mainThemeColor.withAlphaComponent(0.5)]
        )
        
        txtPatientAge.attributedPlaceholder = NSAttributedString(          string: "Patient Age",
                                                                           attributes: [NSAttributedString.Key.foregroundColor: ColorConstant.mainThemeColor.withAlphaComponent(0.5)]
        )
        txtIpCode.attributedPlaceholder = NSAttributedString(
            string: "Ip Code",
            attributes: [NSAttributedString.Key.foregroundColor: ColorConstant.mainThemeColor.withAlphaComponent(0.5)]
        )
        
        DetailsScrollView.addCornerAtTops(radius: 20)
        
        //        Add Shadow
        scrollOuterView.layer.masksToBounds = false
        scrollOuterView.layer.shadowRadius = 3
        scrollOuterView.layer.shadowOpacity = 0.5
        scrollOuterView.layer.shadowOffset = CGSize(width: 0, height: 0)
        scrollOuterView.layer.shadowColor = UIColor.black.cgColor
        
        self.convertDateToStr(date: Date())
    }
    
    func setDatePicker() {
        let datePickerWidth = self.view.frame.width - 40
        let datePickerHeight = self.view.frame.height * 0.4
        datePicker = UIDatePicker(frame: CGRect(x: (self.view.frame.width / 2) - (datePickerWidth / 2), y: (self.view.frame.height / 2) - (datePickerHeight / 2), width: datePickerWidth, height: datePickerHeight))
        datePicker.datePickerMode = .date
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }
        self.deploymentDateTxt.inputView = datePicker
        self.datePicker.backgroundColor = .white
        self.datePicker.addTarget(self, action: #selector(self.handleDatePicker(_:)), for: .valueChanged)        
    }
    
    @objc func handleDatePicker(_ sender: UIDatePicker) {
        self.convertDateToStr(date: datePicker.date)
    }
    
    private func convertDateToStr(date: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        //        //GlobalFunctions.printToConsole(message: "Selected date: \(dateFormatter.string(from: datePicker.date))")
        self.deploymentDateTxt.text = dateFormatter.string(from: date)
    }
    
    func setNavigation(){
        GlobalFunctions.configureStatusNavBar(navController: self.navigationController!, bgColor: ColorConstant.mainThemeColor, textColor: .white)
        self.navigationItem.title = "Add Surgery"
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
        
        let selectedDate = deploymentDateTxt.text ?? ""
        if !Validation.sharedInstance.checkLength(testStr: selectedDate) {
            GlobalFunctions.showToast(controller: self, message: UserMessages.emptyDateError, seconds: errorDismissTime)
            return
        }
        let patientName = txtPatientName.text ?? ""
        let patientNumber = txtPatientNumber.text ?? ""
        let patientAge = txtPatientAge.text ?? ""
        let ipCode = txtIpCode.text ?? ""
        let userId = UserDefaults.standard.integer(forKey: "userId")
        let surgeryId = "D\(Date.currentTimeStamp)U\(userId)"
        addSurgeryReqObj = AddSurgeryRequestModel(cityId: selectedCityId, hospitalId: selectedHospitalId, distributorId: selectedDistributorId, doctorId: selectedDoctorId, surgeryId: surgeryId, schemeId: selectedSchemeId, patientName: patientName, patientMobile: patientNumber, age: Int(patientAge), ipCode: ipCode, salesPersonId: selectedSalesPersonId, gender: selectedGender, DeploymentDate: selectedDate)
        addSurgeryReqObj?.salesPersonName = self.txtSaleperson.text ?? ""
        addSurgeryReqObj?.hospitalName = self.txtHospital.text ?? ""
        addSurgeryReqObj?.doctorName = self.txtDoctor.text ?? ""
        //        If there is no error while validation then redirect to scan the data
        self.redirectToScannerVC()
    }
    
    func redirectToScannerVC() {
        let vc = mainStoryboard.instantiateViewController(withIdentifier: "BarCodeScannerVC") as! BarCodeScannerVC
        vc.selectedSalesPersonId = selectedSalesPersonId
        vc.isFromAddSurgery = true
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension AddSurgerayViewController {
    
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
        CommonFunctions.getAllFormData { response in
            guard let surgeryObj = response else { return }
            self.setAllDropDownData(formDataResponse: surgeryObj)
        }
    }
    
    func setAllDropDownData(formDataResponse: SurgeryInventoryModel) {
        //        Gender dropdown
        self.txtGender.isEnabled = !self.genderArr.isEmpty
//        self.genderDropDown.optionArray = self.genderArr
//        self.genderDropDown.didSelect { selectedText, index, id in
//            self.selectedGender = self.genderArr[index]
//        }
//
        //        City dropdown
        self.citiesArr = formDataResponse.cities ?? []
        self.txtCity.isEnabled = !self.citiesArr.isEmpty
//        self.txtCity.optionArray = self.citiesArr.map({ item -> String in
//            item.name ?? ""
//        })
        
//        self.txtCity.didSelect { selectedText, index, id in
//            self.selectedCityId = self.citiesArr[index].id
//            //            refresh hospital data when user select particular city
//            self.refreshHospitalByCity(selectedCityIndex: index)
//        }
        
        //        set doctor array
        self.doctorsArr = formDataResponse.doctors ?? []
        self.txtDoctor.isEnabled = !self.doctorsArr.isEmpty
//        self.txtDoctor.optionArray = self.doctorsArr.map({ item -> String in
//            item.fullname ?? ""
//        })
//        self.txtDoctor.didSelect { selectedText, index, id in
//            self.selectedDoctorId = self.doctorsArr[index].id
//        }
        
        //        set distributor array
        self.distributorsArr = formDataResponse.distributors ?? []
        self.txtDistributor.isEnabled = !self.distributorsArr.isEmpty
//        self.txtDistributor.optionArray = self.distributorsArr.map({ item -> String in
//            item.name ?? ""
//        })
//        self.txtDistributor.didSelect { selectedText, index, id in
//            self.selectedDistributorId = self.distributorsArr[index].id
//        }
        
        //        set salesperson array
        self.sales_personsArr = formDataResponse.sales_persons ?? []
        self.txtSaleperson.isEnabled = !self.sales_personsArr.isEmpty
//        self.txtSaleperson.optionArray = self.sales_personsArr.map({ item -> String in
//            item.name ?? ""
//        })
//        self.txtSaleperson.didSelect { selectedText, index, id in
//            self.selectedSalesPersonId = self.sales_personsArr[index].id
//        }
        
        //        set scheme array
        self.schemeArr = formDataResponse.schemes ?? []
        self.txtPatientScheme.isEnabled = !self.schemeArr.isEmpty
//        self.txtPatientScheme.optionArray = self.schemeArr.map({ item -> String in
//            item.scheme_name ?? ""
//        })
//        self.txtPatientScheme.didSelect { selectedText, index, id in
//            self.selectedSchemeId = self.schemeArr[index].id
//        }
                
        setDefaultData()
        
    }
    
    //   reload hospitals by city selection
    func refreshHospitalByCity(selectedCityIndex: Int) {
        self.hospitalsArr = citiesArr[selectedCityIndex].hospitals ?? []
        self.txtHospital.isEnabled = !self.hospitalsArr.isEmpty
//        self.txtHospital.optionArray = self.hospitalsArr.map({ item -> String in
//            item.name ?? ""
//        })
//        self.txtHospital.didSelect { selectedText, index, id in
//            self.selectedHospitalId = self.hospitalsArr[index].id
//        }
        
    }
    
    private func setDefaultData() {
        guard let userTypeId = UserDefaults.standard.string(forKey: "userTypeId"), userTypeId == "2" else {
            print("user type id")
            return
        }
        print("user type id: \(userTypeId)")
        
        let storedUserData = UserSessionManager.shared.userDetail
        //        let userDefault = UserDefaults.standard
        if let doctorId = storedUserData?.doctor_id {
            selectedDoctorId = Int(doctorId)//userDefault.integer(forKey: "defaultDoctorId")
            self.txtDoctor.text = doctorsArr.filter({ item in
                item.id == selectedDoctorId
            }).first?.fullname
        }
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
            for i in 0..<citiesArr.count {
                let item = citiesArr[i]
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
        
        if (self.txtDoctor.text ?? "").count > 0 {
            setRightButton(txtDoctor, image: UIImage(named: "ic_right") ?? UIImage())
        }
    }
}

extension AddSurgerayViewController: BarCodeScannerDelegate {
    
    //    Call api to add surgery with scanned barcodes and then redirect to display surgeries
    func submitScannedData() {
        SHOW_CUSTOM_LOADER()
        
        let manualEntryArr: [ManualEntryModel] = UserSessionManager.shared.manualEntryData
        
        let barCodeArr: [BarCodeModel] = UserSessionManager.shared.barCodes
        
        let barCodeDict = barCodeArr.compactMap { $0.dict }
        let manualDataDict = manualEntryArr.compactMap { $0.dict }
        
        func convertArrayToJsonString(dict: [[String:Any]]) -> String? {
            if let theJSONData = try? JSONSerialization.data(
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
        
        addSurgeryReqObj?.manualEntry = convertArrayToJsonString(dict: manualDataDict)
        addSurgeryReqObj?.barcodes = convertArrayToJsonString(dict: barCodeDict)
        
        if appDelegate.reachability.connection == .unavailable {
            self.saveSurgeryToCoreData(onSubmitAction: true)
        } else {
            self.callAddSurgeryApi()
        }
        
    }
    
    //    #MARK: Add surgery data api call
    func callAddSurgeryApi() {
        guard let surgeryObj = addSurgeryReqObj else {
            HIDE_CUSTOM_LOADER()
            return
        }
        SurgeryServices.addSurgery(surgeryObj: surgeryObj) { response, error in
            HIDE_CUSTOM_LOADER()
            guard let _ = error else {
                //                Remove scanned barcodes from userdefaults
                UserDefaults.standard.removeObject(forKey: "scannedBarcodes")
                UserDefaults.standard.removeObject(forKey: "manualEntryData")
                GlobalFunctions.showToast(controller: self, message: "Record saved successfully.", seconds: self.successToastTime) {
                    self.navigationController?.popToRootViewController(animated: true)
                }
                //                self.navigationController?.popViewController(animated: true)
                return
            }
        }
    }
    
    //    #MARK: Save surgery data to CoreData
    func saveSurgeryToCoreData(onSubmitAction: Bool = false) {
        guard let surgeryObj = addSurgeryReqObj else {
            HIDE_CUSTOM_LOADER()
            return
        }
        //        Save records to Core data
        AddSurgeryToCoreData.sharedInstance.saveSurgeryData(surgeryData: surgeryObj)
        HIDE_CUSTOM_LOADER()
        if onSubmitAction {
            GlobalFunctions.showToast(controller: self, message: "Record saved successfully.", seconds: self.successToastTime) {
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
    }
}

//#MARK: Textfield delegate
extension AddSurgerayViewController: UITextFieldDelegate {
    
    public func  textFieldDidBeginEditing(_ textField: UITextField) {
        let vc = mainStoryboard.instantiateViewController(withIdentifier: "DropDownMenuVC") as! DropDownMenuVC
        vc.delegate = self
        //MenuType: 0: city, 1: SalesPerson, 2: schemeArr, 3: gender, 4: hospital, 5: doctors, 6: distributors
        switch textField {
        case txtCity:
            vc.menuType = 0
            vc.citiesArr = citiesArr
            break
        case txtSaleperson:
            vc.menuType = 1
            vc.sales_personsArr = sales_personsArr
            break
        case txtPatientScheme:
            vc.menuType = 2
            vc.schemeArr = schemeArr
        case txtGender:
            vc.menuType = 3
            vc.genderArr = genderArr
        case txtHospital:
            vc.menuType = 4
            vc.objArr = hospitalsArr
            break
        case txtDoctor:
            vc.menuType = 5
            vc.objArr = doctorsArr
        default:
            vc.menuType = 6
            vc.objArr = distributorsArr
        }
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true, completion: nil)
    }
}

//#MARK: DropDown delegate
extension AddSurgerayViewController: DropDownMenuDelegate {
    
//MenuType: 0: city, 1: SalesPerson, 2: schemeArr, 3: gender, 4: hospital, 5: doctors, 6: distributors
    func selectedDropDownItem(menuType: Int, menuObj: Any) {
        print("selected menu object: \(menuObj)")
        switch menuType {
        case 0:
            guard let obj = menuObj as? Cities else { return }
            txtCity.text = obj.name
            selectedCityId = obj.id
            let index = citiesArr.firstIndex { city in
                city.id == obj.id
            }
            self.refreshHospitalByCity(selectedCityIndex: Int(index!))
            break
        case 1:
            guard let obj = menuObj as? SalesPerson else { return }
            txtSaleperson.text = obj.name
            selectedSalesPersonId = obj.id
            break
        case 2:
            guard let obj = menuObj as? Schemes else { return }
            txtPatientScheme.text = obj.scheme_name
            selectedSchemeId = obj.id
        case 3:
            guard let obj = menuObj as? String else { return }
            txtGender.text = obj
            selectedGender = obj
        case 4:
            guard let obj = menuObj as? Hospitals else { return }
            txtHospital.text = obj.name
            selectedHospitalId = obj.id
        case 5:
            guard let obj = menuObj as? Hospitals else { return }
            txtDoctor.text = obj.fullname
            selectedDoctorId = obj.id
        default:
            guard let obj = menuObj as? Hospitals else { return }
            txtDistributor.text = obj.name
            selectedDistributorId = obj.id
        }
    }
}


