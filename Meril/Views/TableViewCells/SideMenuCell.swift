//
//  SideMenuCell.swift
//  Meril
//
//  Created by Nidhi Suhagiya on 21/03/22.
//

import UIKit

class SideMenuCell: UITableViewCell {
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    
    var item: [String:String]? = nil {
        didSet {
            guard let currentItem = item else { return }
            self.titleLbl.text = currentItem["title"]
            if let imgName = currentItem["iconName"] {
                self.imgView?.image = UIImage(named: imgName)
            }
        }
    }
}

class BarCodeCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.setViewCorner(radius: 5)
        self.contentView.layer.borderColor = ColorConstant.mainThemeColor.cgColor
        self.contentView.layer.borderWidth = 1
        self.titleLbl.textAlignment = .left
    }
}
