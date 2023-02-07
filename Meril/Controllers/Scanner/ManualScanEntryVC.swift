//
//  ManualScanEntryVC.swift
//  Meril
//
//  Created by Nidhi Suhagiya on 18/06/22.
//

import Foundation
import UIKit
//import iOSDropDown

protocol ManualEntryDelegate: AnyObject {
    func addManualSurgeryData(manuallyAddedData: ManualEntryModel)
}

class ManualScanEntryVC: UIViewController {
    
    @IBOutlet var collectionViewBorder: [UIView]!
    @IBOutlet weak var txtProductCode: UITextField!
    @IBOutlet weak var txtSerialNumber: UITextField!
    @IBOutlet weak var txtBatchNumber: UITextField!
    @IBOutlet weak var expiryDateTxt: UITextField!
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    
    var datePicker: UIDatePicker!
    var delegate: ManualEntryDelegate?
    var selectedExpiryTimeStamp: String?
    
    var productArr = [ProductBarCode]()
    var selectedProductCode: String?
    var mandatoryFieldType: Int = 0//0: None, 1: Batch, 2: Serial(Product code and expiry date are always mendatory)
    var salesPersonId: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        fetchProductData()
    }
    
    //MARK:- Custome Method
    func setUI(){
        setDatePicker()
        cancelBtn.setTitle("", for: .normal)
        for i in collectionViewBorder {
            i.layer.borderColor = ColorConstant.mainThemeColor.cgColor
            i.layer.borderWidth = 1
            i.layer.cornerRadius = i.frame.height/2
        }
        
        submitBtn.layer.cornerRadius = submitBtn.frame.height/2
        
        txtProductCode.attributedPlaceholder = NSAttributedString(
            string: "Product Code",
            attributes: [NSAttributedString.Key.foregroundColor: ColorConstant.mainThemeColor.withAlphaComponent(0.5)]
        )
        
        txtBatchNumber.attributedPlaceholder = NSAttributedString(
            string: "Batch Number",
            attributes: [NSAttributedString.Key.foregroundColor: ColorConstant.mainThemeColor.withAlphaComponent(0.5)]
        )
        
        txtSerialNumber.attributedPlaceholder = NSAttributedString(
            string: "Serial Number",
            attributes: [NSAttributedString.Key.foregroundColor: ColorConstant.mainThemeColor.withAlphaComponent(0.5)]
        )
        
        expiryDateTxt.attributedPlaceholder = NSAttributedString(
            string: "Select deployment date",
            attributes: [NSAttributedString.Key.foregroundColor: ColorConstant.mainThemeColor.withAlphaComponent(0.5)]
        )
        
        setRightButton(self.txtProductCode, image: UIImage(named: "ic_dropdown") ?? UIImage())
    }
    
    func setDatePicker() {
        let datePickerWidth = self.view.frame.width - 40
        let datePickerHeight = self.view.frame.height * 0.4
        datePicker = UIDatePicker(frame: CGRect(x: (self.view.frame.width / 2) - (datePickerWidth / 2), y: (self.view.frame.height / 2) - (datePickerHeight / 2), width: datePickerWidth, height: datePickerHeight))
        datePicker.datePickerMode = .date
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }
        self.expiryDateTxt.inputView = datePicker
        self.datePicker.backgroundColor = .white
        self.datePicker.addTarget(self, action: #selector(self.handleDatePicker(_:)), for: .valueChanged)
    }
    
    @objc func handleDatePicker(_ sender: UIDatePicker) {        
        _ =  self.convertDateToStr(date: datePicker.date)
    }
    
    private func convertDateToStr(date: Date, isExpiry: Bool = true) -> String? {
        let dateFormatter = DateFormatter()
        if isExpiry {
            dateFormatter.dateFormat = "YYYY-MM-dd"
        } else {
            dateFormatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
        }
        
        let convertedDateStr = dateFormatter.string(from: date)
        if isExpiry {
            self.expiryDateTxt.text = convertedDateStr
            selectedExpiryTimeStamp = "\(Date.currentTimeStamp)"
        }
        return convertedDateStr
    }
    
    @IBAction func cancelBtnClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func submitBtnClicked(_ sender: Any) {
        validateUserInput()
    }
    
    private func validateUserInput() {
        let productCode = selectedProductCode ?? (txtProductCode.text ?? "")
        let batchNo = txtBatchNumber.text ?? ""
        let serialNo = txtSerialNumber.text ?? ""
        let expiryDate = expiryDateTxt.text ?? ""
        
        if !Validation.sharedInstance.checkLength(testStr: productCode) {
            GlobalFunctions.showToast(controller: self, message: UserMessages.productCode, seconds: errorDismissTime)
            return
        }
        
        //                    If mandatoryFieldType is 1 then batch number field is mandatory, if its 2 then serial number is mandatory, otherwise both are optional
        switch mandatoryFieldType {
        case 1:
            if !Validation.sharedInstance.checkLength(testStr: batchNo) {
                GlobalFunctions.showToast(controller: self, message: UserMessages.batchNo, seconds: errorDismissTime)
                return
            }
        case 2:
            if !Validation.sharedInstance.checkLength(testStr: serialNo) {
                GlobalFunctions.showToast(controller: self, message: UserMessages.serialNo, seconds: errorDismissTime)
                return
            }
        default:
            break
        }
        
        if !Validation.sharedInstance.checkLength(testStr: expiryDate) {
            GlobalFunctions.showToast(controller: self, message: UserMessages.emptyDateError, seconds: errorDismissTime)
            return
        }
        
        let obj = ManualEntryModel(sku: productCode, expiry: selectedExpiryTimeStamp, batch: batchNo, serial: serialNo, dateTime: convertDateToStr(date: Date(), isExpiry: false))
        delegate?.addManualSurgeryData(manuallyAddedData: obj)
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension ManualScanEntryVC {
    
    func fetchProductData() {
        guard let salesPersonId = salesPersonId else { return }
        if appDelegate.reachability.connection != .unavailable {
            SHOW_CUSTOM_LOADER()
            SurgeryServices.getProductData(salesPersonId: salesPersonId) { responseData, error in
                HIDE_CUSTOM_LOADER()
                guard let response = responseData else {
                    return
                }
                
                self.productArr = response.productData ?? []
                self.txtProductCode.delegate = self
            }
        }
    }
}

//#MARK: Textfield delegate
extension ManualScanEntryVC: UITextFieldDelegate {
    
    public func  textFieldDidBeginEditing(_ textField: UITextField) {
        self.view.resignFirstResponder()
        self.view.endEditing(true)
        let vc = mainStoryboard.instantiateViewController(withIdentifier: "DropDownMenuVC") as! DropDownMenuVC
        vc.menuType = 88
        vc.productArr = productArr
        vc.delegate = self
        vc.titleStr = "Select Product Barcode"
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true, completion: nil)
    }
}

//#MARK: DropDown delegate
extension ManualScanEntryVC: DropDownMenuDelegate {
    
    //MenuType: 88 ProductBarCode
    func selectedDropDownItem(menuType: Int, menuObj: Any) {
        guard let obj = menuObj as? ProductBarCode else { return }
        txtProductCode.text = obj.material
        selectedProductCode = obj.material
        //                    If product flag is "B" then batch number field is mandatory, if its "S" then serial number is mandatory, otherwise both are optional
        self.mandatoryFieldType = ((obj.flag == "B") ? 1 : ((obj.flag == "S") ? 2 : 0))
        
    }
}

