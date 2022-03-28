//
//  SurgeriListTableViewCell.swift
//  Meril
//
//  Created by iMac on 24/03/22.
//

import UIKit

class SurgeryListTableViewCell: UITableViewCell {

    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblCode: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblBarCode: UILabel!
    @IBOutlet weak var surgeryOrStockIdLbl: UILabel!
    var isFromInventory: Bool = false
    
    var itemDetail: SurgeryData? = nil {
        didSet {
            guard let itemData = itemDetail else { return }
            self.surgeryOrStockIdLbl.text = isFromInventory ? "Stock ID: " + (itemData.stock_id ?? "N/A") : "Surgery ID: " + (itemData.surgery_id ?? "N/A")
            self.lblTitle.text = "Patient Name: " + (itemData.patient_name ?? "N/A")
            self.lblCode.text = "Hospital Code: " + (itemData.ip_code ?? "N/A")
            self.lblDate.text = "Date: " + (itemData.created_at ?? "N/A")
            var barCodeStr: String = ""
            
            if let scanArr = itemData.scans, scanArr.count > 0 {
                self.lblBarCode.isHidden = false
                barCodeStr = "BarCode: "
                for i in 0..<scanArr.count {
                    let barCodeData = scanArr[i]
                    if i == (scanArr.count - 1) {
                        barCodeStr += barCodeData.barcode ?? ""
                    } else {
                        barCodeStr += (barCodeData.barcode ?? "") + ", "
                    }
                }
                self.lblBarCode.text = barCodeStr
            } else {
                self.lblBarCode.text = ""
                self.lblBarCode.isHidden = true
            }
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        viewMain.layer.cornerRadius = 15
        viewMain.backgroundColor = UIColor.white
        lblTitle.textColor = ColorConstant.mainThemeColor
        lblCode.textColor = ColorConstant.mainThemeColor
        lblDate.textColor = ColorConstant.mainThemeColor
        lblBarCode.textColor = ColorConstant.mainThemeColor
        surgeryOrStockIdLbl.textColor = ColorConstant.mainThemeColor
        viewMain.layer.borderColor = ColorConstant.mainThemeColor.cgColor
        viewMain.layer.borderWidth = 1
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
