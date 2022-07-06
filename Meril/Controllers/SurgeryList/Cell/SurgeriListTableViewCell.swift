//
//  SurgeriListTableViewCell.swift
//  Meril
//
//  Created by iMac on 24/03/22.
//

import UIKit

class SurgeryListTableViewCell: UITableViewCell {

    @IBOutlet weak var surgeryOrStockIdLbl: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var doctorNameLbl: UILabel!
    @IBOutlet weak var hospitalNameLbl: UILabel!
    @IBOutlet weak var salesPersonLbl: UILabel!
    @IBOutlet weak var patientNameLbl: UILabel!
    @IBOutlet weak var lblBarCode: UILabel!
    @IBOutlet weak var barCodeStatus: UILabel!
    
    var isFromInventory: Bool = false
    var isOfflineData: Bool = false
    
    var barCodeDetail: Scans? = nil {
        didSet {
            guard let barCodeData = barCodeDetail else {
                return
            }
            self.surgeryOrStockIdLbl.text = "Barcode: " + (barCodeData.barcode ?? "N/A")
            self.lblDate.text = "Product Code: " + (barCodeData.product_code ?? "N/A")
            self.doctorNameLbl.text = "Description: " + (barCodeData.product_data?.description ?? "N/A")
            self.hospitalNameLbl.text = "Batch no: " + (barCodeData.batch_no ?? "N/A")
            self.salesPersonLbl.text = "Serial no: " + (barCodeData.serial_no ?? "N/A")
            self.patientNameLbl.text = "Expiry date: " + (barCodeData.exp_date ?? "\(Date())")
            self.lblBarCode.isHidden = true
            if let barCodeStatus = barCodeData.status, barCodeStatus == "invalid_barcode" {
                self.viewMain.layer.borderColor = UIColor.red.cgColor
                self.barCodeStatus.isHidden = false
            } else {
                self.viewMain.layer.borderColor = ColorConstant.mainThemeColor.cgColor
                self.barCodeStatus.isHidden = true
            }
        }
    }
    
    var surgeryItemDetail: SurgeryData? = nil {
        didSet {
            guard let itemSectionData = surgeryItemDetail else { return }
            self.surgeryOrStockIdLbl.text = "Surgery id: " + (itemSectionData.surgery_id ?? "N/A")
            self.lblDate.text = "Date: " + (itemSectionData.created_at ?? "N/A")
            self.patientNameLbl.text = "Patient name: " + (itemSectionData.patient_name ?? "N/A")
            
            //            Set hospital name
            self.hospitalNameLbl.text = "Hospital: " + (itemSectionData.hospital?.Account_Name ?? "N/A")
            self.hospitalNameLbl.numberOfLines = 2

            //            Set sales person name
            self.salesPersonLbl.text = "Sales person: " + (itemSectionData.sales_person?.fullname ?? "N/A")
            self.lblBarCode.isHidden = true
            self.barCodeStatus.isHidden = true
            //            Set doctor name
            self.doctorNameLbl.text = "Doctor: " + (itemSectionData.doctor?.Full_Name ?? "N/A")
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        viewMain.layer.cornerRadius = 15
        viewMain.layer.borderColor = ColorConstant.mainThemeColor.cgColor
        viewMain.layer.borderWidth = 1

        self.barCodeStatus.isHidden = true
        self.lblBarCode.isHidden = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        hospitalNameLbl.textColor = isOfflineData ? .white : ColorConstant.mainThemeColor
        doctorNameLbl.textColor = isOfflineData ? .white : ColorConstant.mainThemeColor
        salesPersonLbl.textColor = isOfflineData ? .white : ColorConstant.mainThemeColor
        patientNameLbl.textColor = isOfflineData ? .white : ColorConstant.mainThemeColor
        lblDate.textColor = isOfflineData ? .white : ColorConstant.mainThemeColor
        lblBarCode.textColor = isOfflineData ? .white : ColorConstant.mainThemeColor
        surgeryOrStockIdLbl.textColor = isOfflineData ? .white : ColorConstant.mainThemeColor
        viewMain.backgroundColor = isOfflineData ? ColorConstant.mainThemeColor : .white

        // Configure the view for the selected state
    }
    
}
