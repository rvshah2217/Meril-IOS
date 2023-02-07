//
//  AddSurgerayViewController.swift
//  NextPhysique
//
//  Created by iMac on 23/03/22.
//  Copyright © 2022 Sensussoft. All rights reserved.
//

import UIKit
//import iOSDropDown
import Reachability

class AddSurgerayViewController: BaseViewController {
    @IBOutlet weak var viewBC: UIView!
    
    @IBOutlet weak var scrollOuterView: UIView!
    @IBOutlet var collectionViewBackground: [UIView]!
    @IBOutlet var collectionViewBoarder: [UIView]!
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var constrainViewHeaderHeight: NSLayoutConstraint!
    @IBOutlet weak var DetailsScrollView: UIScrollView!
    
    @IBOutlet weak var txtGender: UITextField!
    @IBOutlet weak var txtCity: UITextField!
    @IBOutlet weak var txtHospital: UITextField!
    @IBOutlet weak var txtDoctor: UITextField!
    @IBOutlet weak var txtDistributor: UITextField!
    @IBOutlet weak var txtSaleperson: UITextField!
    @IBOutlet weak var txtPatientScheme: UITextField!
    
    @IBOutlet weak var txtPatientName: UITextField!
    @IBOutlet weak var txtPatientNumber: UITextField!
    @IBOutlet weak var txtPatientAge: UITextField!
    @IBOutlet weak var txtIpCode: UITextField!
    @IBOutlet weak var btnScanNow: UIButton!
    @IBOutlet weak var deploymentDateTxt: UITextField!
    
    let successToastTime = 1.0
    
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
    var selectedSalesPersonId: Int?
    var selectedSchemeId: Int?
    var selectedGender: String?
    var addSurgeryReqObj: AddSurgeryRequestModel?
    var datePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        self.setDatePicker()
        self.fetchFormData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigation()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
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
        SHOW_CUSTOM_LOADER()
        CommonFunctions.getAllFormData { response in
            HIDE_CUSTOM_LOADER()
            guard let surgeryObj = response else { return }
            self.setAllDropDownData(formDataResponse: surgeryObj)
        }
    }
    
    func setAllDropDownData(formDataResponse: SurgeryInventoryModel) {
        //        Gender dropdown
        self.txtGender.isEnabled = !self.genderArr.isEmpty
        
        //        City dropdown
        self.citiesArr = formDataResponse.cities ?? []
        self.txtCity.isEnabled = !self.citiesArr.isEmpty
        
        //        set doctor array
        self.doctorsArr = formDataResponse.doctors ?? []
        self.txtDoctor.isEnabled = !self.doctorsArr.isEmpty
        
        //        set distributor array
        self.distributorsArr = formDataResponse.distributors ?? []
        self.txtDistributor.isEnabled = !self.distributorsArr.isEmpty
        
        //        set salesperson array
        self.sales_personsArr = formDataResponse.sales_persons ?? []
        self.txtSaleperson.isEnabled = !self.sales_personsArr.isEmpty
        
        //        set scheme array
        self.schemeArr = formDataResponse.schemes ?? []
        self.txtPatientScheme.isEnabled = !self.schemeArr.isEmpty
        
        setDefaultData()
    }
    
    //   reload hospitals by city selection
    func refreshHospitalByCity(selectedCityIndex: Int) {
        self.hospitalsArr = citiesArr[selectedCityIndex].hospitals ?? []
        self.txtHospital.isEnabled = !self.hospitalsArr.isEmpty
    }
    
    private func setDefaultData() {
        guard let userTypeId = UserDefaults.standard.string(forKey: "userTypeId"), userTypeId == "2" else {
            return
        }
        
        let storedUserData = UserSessionManager.shared.userDetail
        
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
        self.view.endEditing(true)
        let vc = mainStoryboard.instantiateViewController(withIdentifier: "DropDownMenuVC") as! DropDownMenuVC
        vc.delegate = self
        //MenuType: 0: city, 1: SalesPerson, 2: schemeArr, 3: gender, 4: hospital, 5: doctors, 6: distributors
        switch textField {
        case txtCity:
            vc.menuType = 0
            vc.citiesArr = citiesArr
            vc.titleStr = "Select City"
            break
        case txtSaleperson:
            vc.menuType = 1
            vc.sales_personsArr = sales_personsArr
            vc.titleStr = "Select Sales Person"
            break
        case txtPatientScheme:
            vc.menuType = 2
            vc.schemeArr = schemeArr
            vc.titleStr = "Select Scheme"
        case txtGender:
            vc.menuType = 3
            vc.genderArr = genderArr
            vc.titleStr = "Select Gender"
        case txtHospital:
            if selectedCityId == nil {
                GlobalFunctions.showToast(controller: self, message: UserMessages.priorCitySelectionError, seconds: errorDismissTime)
                return
            }
            vc.menuType = 4
            vc.objArr = hospitalsArr
            vc.titleStr = "Select Hospital"
            break
        case txtDoctor:
            vc.menuType = 5
            vc.objArr = doctorsArr
            vc.titleStr = "Select Doctor"
        default:
            vc.menuType = 6
            vc.objArr = distributorsArr
            vc.titleStr = "Select Distributor"
        }
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        self.navigationController?.present(vc, animated: true, completion: nil)
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


