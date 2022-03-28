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
    
    
    @IBOutlet weak var btnScanNow: UIButton!
    
    var hospitalsArr: [Hospitals] = []
    var doctorsArr: [Hospitals] = []
    var distributorsArr: [Hospitals] = []
    var sales_personsArr: [Hospitals] = []
    
    var selectedHospitalId: Int?
    var selectedDoctorId: Int?
    var selectedDistributorId: Int?
    var selectedSalesPersonId: Int?
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
        
        for i in collectionViewBackground{
            i.backgroundColor = ColorConstant.mainThemeColor
            i.layer.cornerRadius = i.frame.height/2
        }
//        scrollOuterView.layer.cornerRadius = 20
//        scrollOuterView.layer.borderWidth = 0.5
//        scrollOuterView.layer.borderColor = UIColor.lightGray.cgColor
        
        //        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
        //            let rectShape = CAShapeLayer()
        //            rectShape.bounds = self.viewBC.frame
        //            rectShape.position = self.viewBC.center
        //            rectShape.path = UIBezierPath(roundedRect: self.viewBC.bounds, byRoundingCorners: [.bottomLeft , .bottomRight], cornerRadii: CGSize(width: 50, height: 50)).cgPath
        //            self.viewBC.layer.mask = rectShape
        //        }
        viewBC.backgroundColor = ColorConstant.mainThemeColor
        viewBC.addCornerAtBotttoms(radius: 30)
        
        btnScanNow.layer.cornerRadius = btnScanNow.frame.height/2
        self.viewHeader.backgroundColor = ColorConstant.mainThemeColor
        
        txtHospital.setPlaceholder(placeHolderStr: "Select Hospital")
        txtDoctor.setPlaceholder(placeHolderStr: "Select Doctor")
        txtDistributor.setPlaceholder(placeHolderStr: "Select Distributor")
        txtSaleperson.setPlaceholder(placeHolderStr: "Select Saleperson")
        
        
        self.txtHospital.rowHeight = 40
        self.txtDoctor.rowHeight = 40
        self.txtDistributor.rowHeight = 40
        self.txtSaleperson.rowHeight = 40
        
        setRightButton(txtHospital, image: UIImage(named: "ic_dropdown") ?? UIImage())
        setRightButton(txtDoctor, image: UIImage(named: "ic_dropdown") ?? UIImage())
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
        
        guard let _ = selectedSalesPersonId else {
            GlobalFunctions.showToast(controller: self, message: UserMessages.emptySalesPersonError, seconds: errorDismissTime)
            return
        }
        
        let userId = UserDefaults.standard.integer(forKey: "userId")
        let stockId = "D\(Date.currentTimeStamp)U\(userId)"
        addSurgeryReqObj = AddSurgeryRequestModel(hospitalId: selectedHospitalId, distributorId: selectedDistributorId, doctorId: selectedDoctorId, salesPersonId: selectedSalesPersonId, stockId: stockId)
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
            self.selectedSalesPersonId = self.sales_personsArr[index].id
        }
        
        self.hospitalsArr = formDataResponse.hospitals ?? []
        self.txtHospital.isEnabled = !self.hospitalsArr.isEmpty
        self.txtHospital.optionArray = self.hospitalsArr.map({ item -> String in
            item.name ?? ""
        })
        self.txtHospital.didSelect { selectedText, index, id in
            self.selectedHospitalId = self.hospitalsArr[index].id
        }
        
    }
}

extension AddInventoryViewController: BarCodeScannerDelegate {
    
    // Call api to add Inventory with scanned barcodes and then redirect to display inventories
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
        SurgeryServices.addInventoryStock(surgeryObj: addSurgeryReqObj!) { response, error in
            guard let err = error else {
                UserDefaults.standard.removeObject(forKey: "scannedBarcodes")
                self.navigationController?.popViewController(animated: true)
                return
            }
            GlobalFunctions.showToast(controller: self, message: err, seconds: errorDismissTime)
            
        }
    }
}
