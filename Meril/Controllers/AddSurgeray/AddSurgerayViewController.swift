//
//  AddSurgerayViewController.swift
//  NextPhysique
//
//  Created by iMac on 23/03/22.
//  Copyright © 2022 Sensussoft. All rights reserved.
//

import UIKit
import iOSDropDown

class AddSurgerayViewController: BaseViewController {
    @IBOutlet weak var viewBC: UIView!
    
    @IBOutlet weak var scrollOuterView: UIView!
    @IBOutlet var collectionViewBackground: [UIView]!
    @IBOutlet var collectionViewBoarder: [UIView]!
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var constrainViewHeaderHeight: NSLayoutConstraint!
    @IBOutlet weak var DetailsScrollView: UIScrollView!
    
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
    
    @IBOutlet weak var txtDoctor: DropDown! {
        didSet {
            self.txtDoctor.selectedRowColor = ColorConstant.mainThemeColor// ?? UIColor.systemBlue
        }
    }
    
    @IBOutlet weak var txtDistributor: DropDown! {
        didSet {
            self.txtDistributor.selectedRowColor = ColorConstant.mainThemeColor// ?? UIColor.systemBlue
        }
    }
    
    @IBOutlet weak var txtSaleperson: DropDown! {
        didSet {
            self.txtSaleperson.selectedRowColor = ColorConstant.mainThemeColor// ?? UIColor.systemBlue
        }
    }
    
    @IBOutlet weak var txtUDT: DropDown! {
        didSet {
            self.txtUDT.selectedRowColor = ColorConstant.mainThemeColor// ?? UIColor.systemBlue
        }
    }
    
    @IBOutlet weak var txtPatientScheme: DropDown! {
        didSet {
            self.txtPatientScheme.selectedRowColor = ColorConstant.mainThemeColor// ?? UIColor.systemBlue
        }
    }
    
    
    @IBOutlet weak var txtPatientName: UITextField!
    @IBOutlet weak var txtPatientNumber: UITextField!
    @IBOutlet weak var txtPatientAge: UITextField!
    @IBOutlet weak var txtIpCode: UITextField!
    @IBOutlet weak var btnScanNow: UIButton!
    
    
    //    var schemeArr: [Schemes] = []
    //    var udtArr: [Schemes] = []
    //    var departmentsArr: [Schemes] = []
    
    var citiesArr : [Cities] = []
    var hospitalsArr: [Hospitals] = []
    var doctorsArr: [Hospitals] = []
    var distributorsArr: [Hospitals] = []
    var sales_personsArr: [Hospitals] = []
    var schemeArr: [Schemes] = []
    var udtArr: [Schemes] = []
    
    var selectedCityId: Int?
    var selectedHospitalId: Int?
    var selectedDoctorId: Int?
    var selectedDistributorId: Int?
    var selectedSalesPaersonId: Int?
    var selectedSchemeId: Int?
    var selectedUdtId: Int?
    var addSurgeryReqObj: AddSurgeryRequestModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        self.fetchFormData()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigation()
    }
    //MARK:- Custome Method
    func setUI(){
        self.navigationItem.title = ""
        for i in collectionViewBoarder{
            i.layer.borderColor = ColorConstant.mainThemeColor.cgColor
            i.layer.borderWidth = 1
            i.layer.cornerRadius = i.frame.height/2
        }
        for i in collectionViewBackground{
            i.backgroundColor = ColorConstant.mainThemeColor
            i.layer.cornerRadius = i.frame.height/2
        }
        scrollOuterView.layer.cornerRadius = 20
        scrollOuterView.layer.borderWidth = 0.5
        scrollOuterView.layer.borderColor = UIColor.lightGray.cgColor
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
            let rectShape = CAShapeLayer()
            rectShape.bounds = self.viewBC.frame
            rectShape.position = self.viewBC.center
            rectShape.path = UIBezierPath(roundedRect: self.viewBC.bounds, byRoundingCorners: [.bottomLeft , .bottomRight], cornerRadii: CGSize(width: 50, height: 50)).cgPath
            self.viewBC.layer.mask = rectShape
        }
        viewBC.backgroundColor = ColorConstant.mainThemeColor
        
        btnScanNow.layer.cornerRadius = btnScanNow.frame.height/2
        self.viewHeader.backgroundColor = ColorConstant.mainThemeColor
        
        txtCity.setPlaceholder(placeHolderStr: "Select City")
        txtHospital.setPlaceholder(placeHolderStr: "Select Hospital")
        txtDoctor.setPlaceholder(placeHolderStr: "Select Doctor")
        txtDistributor.setPlaceholder(placeHolderStr: "Select Distributor")
        txtSaleperson.setPlaceholder(placeHolderStr: "Select Saleperson")
        txtPatientScheme.setPlaceholder(placeHolderStr: "Select Scheme")
        txtUDT.setPlaceholder(placeHolderStr: "Select UDT")

//        txtCity.attributedPlaceholder = NSAttributedString(
//            string: "Select City",
//            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white]
//        )
//        txtHospital.attributedPlaceholder = NSAttributedString(
//            string: "Select Hospital",
//            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white]
//        )
//        txtDoctor.attributedPlaceholder = NSAttributedString(
//            string: "Select Doctor",
//            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white]
//        )
//        txtDistributor.attributedPlaceholder = NSAttributedString(
//            string: "Select Distributor",
//            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white]
//        )
//        txtSaleperson.attributedPlaceholder = NSAttributedString(          string: "Select Saleperson",
//                                                                           attributes: [NSAttributedString.Key.foregroundColor: UIColor.white]
//        )
//
//        txtPatientScheme.attributedPlaceholder = NSAttributedString(          string: "Select Scheme",
//                                                                           attributes: [NSAttributedString.Key.foregroundColor: UIColor.white]
//        )
//
//        txtUDT.attributedPlaceholder = NSAttributedString(          string: "Select UDT",
//                                                                           attributes: [NSAttributedString.Key.foregroundColor: UIColor.white]
//        )
        
        
        self.txtCity.rowHeight = 40
        self.txtHospital.rowHeight = 40
        self.txtDoctor.rowHeight = 40
        self.txtDistributor.rowHeight = 40
        self.txtSaleperson.rowHeight = 40
        self.txtPatientScheme.rowHeight = 40
        self.txtUDT.rowHeight = 40

        setRightButton(txtCity, image: UIImage(named: "ic_dropdown") ?? UIImage())
        setRightButton(txtHospital, image: UIImage(named: "ic_dropdown") ?? UIImage())
        setRightButton(txtDoctor, image: UIImage(named: "ic_dropdown") ?? UIImage())
        setRightButton(txtDistributor, image: UIImage(named: "ic_dropdown") ?? UIImage())
        setRightButton(txtSaleperson, image: UIImage(named: "ic_dropdown") ?? UIImage())
        setRightButton(txtPatientScheme, image: UIImage(named: "ic_dropdown") ?? UIImage())
        setRightButton(txtUDT, image: UIImage(named: "ic_dropdown") ?? UIImage())

        txtPatientName.attributedPlaceholder = NSAttributedString(
            string: "Patient Name",
            attributes: [NSAttributedString.Key.foregroundColor: ColorConstant.mainThemeColor]
        )
        txtPatientNumber.attributedPlaceholder = NSAttributedString(          string: "Patient Mobile Number",
                                                                              attributes: [NSAttributedString.Key.foregroundColor: ColorConstant.mainThemeColor]
        )
        txtPatientAge.attributedPlaceholder = NSAttributedString(          string: "Patient Age",
                                                                           attributes: [NSAttributedString.Key.foregroundColor: ColorConstant.mainThemeColor]
        )
        txtIpCode.attributedPlaceholder = NSAttributedString(
            string: "Ip Code",
            attributes: [NSAttributedString.Key.foregroundColor: ColorConstant.mainThemeColor]
        )
    }
    
    func setNavigation(){
        settupHeaderView(childView: self.viewHeader, constrain: constrainViewHeaderHeight,title: "Add Surgeray")
        //        navigationController?.setNavigationBarHidden(true, animated: false)
        
        setBackButtononNavigation()
        pressButtonOnNavigaion { (isBack) in
            if(isBack){
            }else{
                _ =  self.navigationController?.popViewController(animated: true)
            }
        }
        GlobalFunctions.configureStatusNavBar(navController: self.navigationController!, bgColor: ColorConstant.mainThemeColor, textColor: .white)
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
        
        guard let _ = selectedDoctorId else {
            GlobalFunctions.showToast(controller: self, message: UserMessages.emptyDoctorError, seconds: errorDismissTime)
            return
        }
        
        guard let _ = selectedDistributorId else {
            GlobalFunctions.showToast(controller: self, message: UserMessages.emptyDistributorError, seconds: errorDismissTime)
            return
        }
        
        guard let _ = selectedSalesPaersonId else {
            GlobalFunctions.showToast(controller: self, message: UserMessages.emptySalesPersonError, seconds: errorDismissTime)
            return
        }
        
        
        let patientName = txtPatientName.text ?? ""
        let patientNumber = txtPatientNumber.text ?? ""
        let patientAge = txtPatientAge.text ?? ""
        let ipCode = txtIpCode.text ?? ""
       
        if !Validation.sharedInstance.checkLength(testStr: patientName) {
            GlobalFunctions.showToast(controller: self, message: "Please enter patient name.", seconds: errorDismissTime)
            return
        }
        
        if !Validation.sharedInstance.checkLength(testStr: patientNumber) {
            GlobalFunctions.showToast(controller: self, message: "Please enter patient number.", seconds: errorDismissTime)
            return
        }
        
        if !Validation.sharedInstance.checkLength(testStr: patientName) {
            GlobalFunctions.showToast(controller: self, message: "Please enter patient age.", seconds: errorDismissTime)
            return
        }
        
        if !Validation.sharedInstance.checkLength(testStr: patientName) {
            GlobalFunctions.showToast(controller: self, message: "Please enter IP Code.", seconds: errorDismissTime)
            return
        }
        
        let userId = UserDefaults.standard.integer(forKey: "userId")
        let surgeryId = "D\(Date.currentTimeStamp)U\(userId)"
        addSurgeryReqObj = AddSurgeryRequestModel(cityId: selectedCityId, hospitalId: selectedHospitalId, distributorId: selectedDistributorId, doctorId: selectedDoctorId, surgeryId: surgeryId, schemeId: selectedSchemeId, udtId: selectedUdtId, patientName: patientName, patientMobile: patientNumber, age: Int(patientAge), ipCode: ipCode)
        self.redirectToScannerVC()
//        If there is no error while validation then redirect to scan the data
//        let scannerVC = mainStoryboard.instantiateViewController(withIdentifier: "BarCodeScannerVC") as! BarCodeScannerVC
//        scannerVC.delegate = self
//        self.navigationController?.pushViewController(scannerVC, animated: true)
    }
    
    func redirectToScannerVC() {
        let vc = mainStoryboard.instantiateViewController(withIdentifier: "BarCodeScannerVC") as! BarCodeScannerVC
        vc.isFromAddSurgery = true
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension AddSurgerayViewController {
    
    func fetchFormData() {
        SurgeryServices.getAllFormData { response, error in
            guard let responseData = response else {
                GlobalFunctions.printToConsole(message: "Fetch form-data failed: \(error)")
                return
            }
            if let formDataObj = responseData.suregeryInventoryData {
                self.setAllDropDownData(formDataResponse: formDataObj)
            }
        }
    }
    
    func setAllDropDownData(formDataResponse: SurgeryInventoryModel) {
        //        City dropdown
        self.citiesArr = formDataResponse.cities ?? []
        self.txtCity.isEnabled = !self.citiesArr.isEmpty
        self.txtCity.optionArray = self.citiesArr.map({ item -> String in
            item.name ?? ""
        })
        
        self.txtCity.didSelect { selectedText, index, id in
            self.selectedCityId = self.citiesArr[index].id
            //            refresh hospital data when user select particular city
            self.refreshHospitalByCity(selectedCityIndex: index)
        }
        
        
        //        set doctor array
        self.doctorsArr = formDataResponse.doctors ?? []
        self.txtDoctor.isEnabled = !self.doctorsArr.isEmpty
        self.txtDoctor.optionArray = self.doctorsArr.map({ item -> String in
            item.fullname ?? ""
        })
        self.txtDoctor.didSelect { selectedText, index, id in
            self.selectedDoctorId = self.doctorsArr[index].id
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
            self.selectedSalesPaersonId = self.sales_personsArr[index].id
        }
        
        //        set scheme array
        self.schemeArr = formDataResponse.schemes ?? []
        self.txtPatientScheme.isEnabled = !self.schemeArr.isEmpty
        self.txtPatientScheme.optionArray = self.schemeArr.map({ item -> String in
            item.scheme_name ?? ""
        })
        self.txtPatientScheme.didSelect { selectedText, index, id in
            self.selectedSchemeId = self.schemeArr[index].id
        }
        
        //        set scheme array
        self.udtArr = formDataResponse.udt ?? []
        self.txtUDT.isEnabled = !self.udtArr.isEmpty
        self.txtUDT.optionArray = self.udtArr.map({ item -> String in
            item.udt_name ?? ""
        })
        self.txtUDT.didSelect { selectedText, index, id in
            self.selectedUdtId = self.udtArr[index].id
        }
    }
    
    //   reload hospitals by city selection
    func refreshHospitalByCity(selectedCityIndex: Int) {
        self.hospitalsArr = citiesArr[selectedCityIndex].hospitals ?? []
        self.txtHospital.isEnabled = !self.hospitalsArr.isEmpty
        self.txtHospital.optionArray = self.hospitalsArr.map({ item -> String in
            item.name ?? ""
        })
        self.txtHospital.didSelect { selectedText, index, id in
            self.selectedHospitalId = self.hospitalsArr[index].id
        }
    }
}

extension AddSurgerayViewController: BarCodeScannerDelegate {
    
//TODO:    Call api to add surgery with scanned barcodes and then redirect to display surgeries
    func submitScannedData() {
        let barCodeArr: [BarCodeModel] = UserSessionManager.shared.barCodes

        let dict = barCodeArr.compactMap { $0.dict }
        
        func convertArrayToJsonString() {
            if let theJSONData = try?  JSONSerialization.data(
                withJSONObject: dict,
                options: .prettyPrinted
            ),
               let theJSONText = String(data: theJSONData,
                                        encoding: String.Encoding.ascii) {
                print("JSON string = \n\(theJSONText)")
                addSurgeryReqObj?.barcodes = theJSONText
            }
        }
        
        convertArrayToJsonString()
        GlobalFunctions.printToConsole(message: "\(addSurgeryReqObj?.barcodes)")
        self.callAddSurgeryApi()
    }
    
    func callAddSurgeryApi() {
        SurgeryServices.addSurgery(surgeryObj: addSurgeryReqObj!) { response, error in
            guard let err = error else {                
                UserDefaults.standard.removeObject(forKey: "scannedBarcodes")
                self.navigationController?.popViewController(animated: true)
                return
            }
            GlobalFunctions.showToast(controller: self, message: err, seconds: errorDismissTime)
            
        }
    }
}
