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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        viewMain.layer.cornerRadius = 15
        viewMain.layer.borderColor = ColorConstant.mainThemeColor.cgColor
        viewMain.layer.borderWidth = 1
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
