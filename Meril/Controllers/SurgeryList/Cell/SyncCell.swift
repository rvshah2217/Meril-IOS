//
//  SyncCell.swift
//  Meril
//
//  Created by Nidhi Suhagiya on 05/04/22.
//

import UIKit

class SyncCell: UITableViewCell {

    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var barCodeLbl: UILabel!
    var isFromInventory: Bool = false
    
//    var itemDetail: AddSurgeryRequestModel? = nil {
//        didSet {
//            guard let itemData = itemDetail else { return }
//            var barCodeStr: String = ""
//
//            let jsonData = (itemData.barcodes ?? "").data(using: .utf8)!
//            let barcodeObjArr = try! JSONDecoder().decode([BarCodeModel].self, from: jsonData)
//
//            if barcodeObjArr.count > 0 {
////                self.barCodeLbl.isHidden = false
//                barCodeStr = "BarCode: "
//                for i in 0..<barcodeObjArr.count {
//                    let barCodeData = barcodeObjArr[i]
//                    if i == (barcodeObjArr.count - 1) {
//                        barCodeStr += barCodeData.barcode
//                    } else {
//                        barCodeStr += barCodeData.barcode + ", "
//                    }
//                }
//                self.barCodeLbl.text = barCodeStr
//            } else {
//                self.barCodeLbl.text = ""
////                self.lblBarCode.isHidden = true
//            }
//        }
//    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        viewMain.layer.cornerRadius = 15
//        viewMain.backgroundColor = UIColor.white
//        viewMain.layer.borderColor = ColorConstant.mainThemeColor.cgColor
//        viewMain.layer.borderWidth = 1
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
