//
//  DefaultLoginData.swift
//  Meril
//
//  Created by Nidhi Suhagiya on 17/06/22.
//

import UIKit

class DefaultLoginData: UIViewController {
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var scrollOuterView: UIView!
    @IBOutlet var collectionViewBackground: [UIView]!
    @IBOutlet var collectionViewBoarder: [UIView]!
    @IBOutlet weak var DetailsScrollView: UIScrollView!
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var constrainViewHeaderHeight: NSLayoutConstraint!
    
    @IBOutlet weak var txtDoctor: UITextField!
    @IBOutlet weak var txtDistributor: UITextField!
    @IBOutlet weak var txtSaleperson: UITextField!
    @IBOutlet weak var submitBtn: UIButton!
    
    var doctorsArr: [Hospitals] = []
    var distributorsArr: [Hospitals] = []
    var sales_personsArr: [SalesPerson] = []
    
    var selectedDoctorId: Int?
    var selectedDistributorId: Int?
    var selectedSalesPersonId: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigation()
        setUI()
        self.fetchFormData()
    }
    
    func setNavigation() {
        self.navigationItem.title = "Default Credentials"
        GlobalFunctions.configureStatusNavBar(navController: self.navigationController!, bgColor: ColorConstant.mainThemeColor, textColor: .white)
    }
    
    //MARK:- Custome Method
    func setUI(){
        
        for i in collectionViewBoarder{
            i.layer.borderColor = ColorConstant.mainThemeColor.cgColor
            i.layer.borderWidth = 1
            i.layer.cornerRadius = i.frame.height/2
        }
        for i in collectionViewBackground{
            i.backgroundColor = ColorConstant.mainThemeColor
            i.layer.cornerRadius = i.frame.height/2
        }
        
        backgroundView.backgroundColor = ColorConstant.mainThemeColor
        backgroundView.addCornerAtBotttoms(radius: 30)
        
        submitBtn.layer.cornerRadius = submitBtn.frame.height/2
        self.viewHeader.backgroundColor = ColorConstant.mainThemeColor
        
        txtDoctor.setPlaceholder(placeHolderStr: "Select Doctor")
        txtDistributor.setPlaceholder(placeHolderStr: "Select Distributor")
        txtSaleperson.setPlaceholder(placeHolderStr: "Select Saleperson")
        
        self.txtDoctor.delegate = self
        self.txtDistributor.delegate = self
        self.txtSaleperson.delegate = self
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
    
    @IBAction func submitBtnClicked(_ sender: UIButton) {
        
        guard let distributorId = selectedDistributorId else {
            GlobalFunctions.showToast(controller: self, message: UserMessages.emptyDistributorError, seconds: errorDismissTime)
            return
        }
        
        guard let salesPersonId = selectedSalesPersonId else {
            GlobalFunctions.showToast(controller: self, message: UserMessages.emptySalesPersonError, seconds: errorDismissTime)
            return
        }
        
        self.callUpdateHospitalApi(doctorId: selectedDoctorId, distributorId: distributorId, salesPersonId: salesPersonId)
    }
    
    private func callUpdateHospitalApi(doctorId: Int?, distributorId: Int, salesPersonId: Int) {
        let obj = CredentialsRequestModel(doctorId: doctorId, distributorId: distributorId, salesPersonId: salesPersonId)
        LoginServices.setDefaultCredentials(credentialObj: obj) { isSuccess, error in
            //            save doctor, distributor and salesPerson id
            var userData = UserSessionManager.shared.userDetail
            userData?.sales_person_id = salesPersonId
            userData?.distributor_id = distributorId
            if let doctorId = doctorId {
                userData?.doctor_id = doctorId
            }
            UserSessionManager.shared.userDetail = userData
            self.redirectToHomeVC()
        }
    }
    
    private func redirectToHomeVC() {
        appDelegate.fetchAndStoredDataLocally()
        self.view?.window?.rootViewController = GlobalFunctions.setHomeVC()
        self.view?.window?.makeKeyAndVisible()
    }
}

extension DefaultLoginData {
    
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
        
        //        set doctor array
        self.doctorsArr = formDataResponse.doctors ?? []
        self.txtDoctor.isEnabled = !self.doctorsArr.isEmpty
        
        //        set distributor array
        self.distributorsArr = formDataResponse.distributors ?? []
        self.txtDistributor.isEnabled = !self.distributorsArr.isEmpty
        
        //        set salesperson array
        self.sales_personsArr = formDataResponse.sales_persons ?? []
        self.txtSaleperson.isEnabled = !self.sales_personsArr.isEmpty
        self.setDefaultData()
    }
    
    func setDefaultData() {
        let storedUserData = UserSessionManager.shared.userDetail
        
        if let doctorId = storedUserData?.doctor_id {
            selectedDoctorId = Int(doctorId)
            self.txtDoctor.text = doctorsArr.filter({ item in
                item.id == selectedDoctorId
            }).first?.fullname
        }
        
        if let distributorId = storedUserData?.distributor_id {
            selectedDistributorId = Int(distributorId)
            self.txtDistributor.text = distributorsArr.filter({ item in
                item.id == selectedDistributorId
            }).first?.name
        }
        
        if let salesPersonId = storedUserData?.sales_person_id {
            selectedSalesPersonId = salesPersonId
            self.txtSaleperson.text = sales_personsArr.filter({ item in
                item.id == salesPersonId
            }).first?.name
        }
    }
}

//#MARK: Textfield delegate
extension DefaultLoginData: UITextFieldDelegate {
    
    public func  textFieldDidBeginEditing(_ textField: UITextField) {
        let vc = mainStoryboard.instantiateViewController(withIdentifier: "DropDownMenuVC") as! DropDownMenuVC
        vc.delegate = self
        //MenuType: 0: city, 1: SalesPerson, 2: schemeArr, 3: gender, 4: hospital, 5: doctors, 6: distributors
        switch textField {
        case txtSaleperson:
            vc.menuType = 1
            vc.sales_personsArr = sales_personsArr
            vc.titleStr = "Select Sales Person"
            break
        case txtDoctor:
            vc.menuType = 5
            vc.objArr = doctorsArr
            vc.titleStr = "Select Doctor"
            break
        default:
            vc.menuType = 6
            vc.objArr = distributorsArr
            vc.titleStr = "Select Distrbutor"
        }
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        self.navigationController?.present(vc, animated: true, completion: nil)
    }
}

//#MARK: DropDown delegate
extension DefaultLoginData: DropDownMenuDelegate {
    
    //MenuType: 0: city, 1: SalesPerson, 2: schemeArr, 3: gender, 4: hospital, 5: doctors, 6: distributors
    func selectedDropDownItem(menuType: Int, menuObj: Any) {
        print("selected menu object: \(menuObj)")
        switch menuType {
        case 1:
            guard let obj = menuObj as? SalesPerson else { return }
            txtSaleperson.text = obj.name
            selectedSalesPersonId = obj.id
            break
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
