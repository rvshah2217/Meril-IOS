//
//  SideMenuCell.swift
//  Meril
//
//  Created by Nidhi Suhagiya on 21/03/22.
//

import UIKit

class SideMenuCell: UITableViewCell {
    
    var item: [String:String]? = nil {
        didSet {
            guard let currentItem = item else { return }
            self.textLabel?.text = currentItem["title"]
            if let imgName = currentItem["iconName"] {
                self.imageView?.image = UIImage(named: imgName)
            }
        }
    }
}
