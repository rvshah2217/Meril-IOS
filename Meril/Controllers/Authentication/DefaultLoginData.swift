//
//  DefaultLoginData.swift
//  Meril
//
//  Created by Nidhi Suhagiya on 17/06/22.
//

import UIKit
import iOSDropDown

class DefaultLoginData: UIViewController {
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var scrollOuterView: UIView!
    @IBOutlet var collectionViewBackground: [UIView]!
    @IBOutlet var collectionViewBoarder: [UIView]!
    @IBOutlet weak var DetailsScrollView: UIScrollView!
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var constrainViewHeaderHeight: NSLayoutConstraint!
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
//        self.navigationItem.hidesBackButton = true
        GlobalFunctions.configureStatusNavBar(navController: self.navigationController!, bgColor: ColorConstant.mainThemeColor, textColor: .white)
    }
    
    //MARK:- Custome Method
    func setUI(){
//        UserDefaults.standard.set(true, forKey: "isFirstTimeLogInDone")

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
        
        self.txtDoctor.rowHeight = 40
        self.txtDistributor.rowHeight = 40
        self.txtSaleperson.rowHeight = 40
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
//        guard let _ = selectedDoctorId else {
//            GlobalFunctions.showToast(controller: self, message: UserMessages.emptyDoctorError, seconds: errorDismissTime)
//            return
//        }
        
        guard let distributorId = selectedDistributorId else {
            GlobalFunctions.showToast(controller: self, message: UserMessages.emptyDistributorError, seconds: errorDismissTime)
            return
        }
        
        guard let salesPersonId = selectedSalesPersonId else {
            GlobalFunctions.showToast(controller: self, message: UserMessages.emptySalesPersonError, seconds: errorDismissTime)
            return
        }
        
        self.callUpdateHospitalApi(doctorId: selectedDoctorId, distributorId: distributorId, salesPersonId: salesPersonId)
        
//        UserDefaults.standard.set(true, forKey: "isFirstTimeLogInDone")
//        UserDefaults.standard.set(selectedDoctorId, forKey: "defaultDoctorId")
//        UserDefaults.standard.set(selectedDistributorId, forKey: "defaultDistributorId")
//        UserDefaults.standard.set(selectedSalesPersonId, forKey: "defaultSalesPersonId")
//        self.redirectToHomeVC()
    }
    
    private func callUpdateHospitalApi(doctorId: Int?, distributorId: Int, salesPersonId: Int) {
        let obj = CredentialsRequestModel(doctorId: doctorId, distributorId: distributorId, salesPersonId: salesPersonId)
        LoginServices.setDefaultCredentials(credentialObj: obj) { isSuccess, error in
//            save doctor, distributor and salesPerson id
            var userData = UserSessionManager.shared.userDetail
            userData?.sales_person_id = String(salesPersonId)
            userData?.distributor_id = String(distributorId)
            if let doctorId = doctorId {
                userData?.doctor_id = String(doctorId)
            }
            UserSessionManager.shared.userDetail = userData
            self.redirectToHomeVC()
        }
    }
    
    private func redirectToHomeVC() {
//        if let isDefaultPassword = UserDefaults.standard.string(forKey: "isDefaultPassword"), isDefaultPassword == "1" {
        if UserDefaults.standard.bool(forKey: "isDefaultPassword") {
            //                    Redirect to change password
            let vc = ChangePasswordViewController(nibName: "ChangePasswordViewController", bundle: nil)
            vc.isFromLogin = true
            self.navigationController!.pushViewController(vc, animated: true)
        } else {
            appDelegate.fetchAndStoredDataLocally()
            self.view?.window?.rootViewController = GlobalFunctions.setHomeVC()
            self.view?.window?.makeKeyAndVisible()
        }
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
            self.selectedSalesPersonId = Int(self.sales_personsArr[index].id!)
        }
        
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
            selectedSalesPersonId = Int(salesPersonId)
            self.txtSaleperson.text = sales_personsArr.filter({ item in
                item.id == String(salesPersonId)
            }).first?.name
        }

    }
}
