//
//  ManualScanEntryVC.swift
//  Meril
//
//  Created by Nidhi Suhagiya on 18/06/22.
//

import Foundation
import UIKit
import iOSDropDown

protocol ManualEntryDelegate: AnyObject {
    func addManualSurgeryData(manuallyAddedData: ManualEntryModel)
}

class ManualScanEntryVC: UIViewController {
    
//    @IBOutlet var collectionViewBackground: [UIView]!
    @IBOutlet var collectionViewBorder: [UIView]!
    @IBOutlet weak var txtProductCode: DropDown! {
        didSet {
            self.txtProductCode.selectedRowColor = ColorConstant.mainThemeColor// ?? UIColor.systemBlue
            self.txtProductCode.rowHeight = 40
        }
    }
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
    var salesPersonId: String?
    
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
//        for i in collectionViewBackground{
//            i.backgroundColor = ColorConstant.mainThemeColor
//            i.layer.cornerRadius = i.frame.height/2
//        }
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
//        self.convertDateToStr(date: Date())
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
        self.convertDateToStr(date: datePicker.date)        
    }
    
    private func convertDateToStr(date: Date, isExpiry: Bool = true) -> String? {
        let dateFormatter = DateFormatter()
        if isExpiry {
            dateFormatter.dateFormat = "YYYY-MM-dd"
        } else {
            dateFormatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
        }
        //        GlobalFunctions.printToConsole(message: "Selected date: \(dateFormatter.string(from: datePicker.date))")
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
//        self.navigationController?.popViewController(animated: true)
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

//                self.txtProductCode.isEnabled = !self.schemeArr.isEmpty
                self.txtProductCode.optionArray = self.productArr.map({ item -> String in
                    item.material ?? ""
                })
                self.txtProductCode.didSelect { selectedText, index, id in
                    self.selectedProductCode = self.productArr[index].material
//                    If product flag is "B" then batch number field is mandatory, if its "S" then serial number is mandatory, otherwise both are optional
                    self.mandatoryFieldType = ((self.productArr[index].flag == "B") ? 1 : ((self.productArr[index].flag == "S") ? 2 : 0))
                }
            }
        }
    }
}
