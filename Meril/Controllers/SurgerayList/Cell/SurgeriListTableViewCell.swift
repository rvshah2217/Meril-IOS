//
//  SurgeriListTableViewCell.swift
//  Meril
//
//  Created by iMac on 24/03/22.
//

import UIKit

class SurgeriListTableViewCell: UITableViewCell {

    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblCode: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblQuCode: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        viewMain.layer.cornerRadius = 10
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
