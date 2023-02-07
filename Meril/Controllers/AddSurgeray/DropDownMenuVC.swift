//
//  DropDownMenuVC.swift
//  Meril
//
//  Created by Nidhi Suhagiya on 22/07/22.
//

import Foundation
import UIKit

protocol DropDownMenuDelegate {
    func selectedDropDownItem(menuType: Int, menuObj: Any)
}

class DropDownMenuVC: UIViewController {
    
    @IBOutlet weak var cancelSearchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var outerView: UIView!
    @IBOutlet weak var titleOuterView: UIView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var cancelBtn: UIButton!
    
    var objArr: [Hospitals] = []
    var citiesArr : [Cities] = []
    var sales_personsArr: [SalesPerson] = []
    var schemeArr: [Schemes] = []
    var genderArr: [String] = ["Male", "Female"]
    
    var filteredObjArr: [Hospitals] = []
    var filteredCitiesArr : [Cities] = []
    var filteredSales_personsArr: [SalesPerson] = []
    var filteredSchemeArr: [Schemes] = []
    
    var productArr = [ProductBarCode]()
    var filteredProductArr: [ProductBarCode] = []
    
    var titleStr: String = "Select Item"
    var delegate: DropDownMenuDelegate?
    var menuType: Int = 0//0: city, 1: SalesPerson, 2: schemeArr, 3: gender, 4: hospital, 5: doctors, 6: distributors, 88: ProductBarCode
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        cancelBtn.setViewCorner(radius: self.cancelBtn.frame.height/2)
        cancelSearchBar.delegate = self
        self.setTableData()
        tableView.delegate = self
        tableView.dataSource = self
        self.titleLbl.text = titleStr
        self.outerView.setViewCorner(radius: 15)
        self.titleOuterView.addCornerAtTops(radius: 14)
    }
    
    private func setTableData() {
        switch menuType {
        case 0:
            filteredCitiesArr = citiesArr
            break
        case 1:
            filteredSales_personsArr = sales_personsArr
            break
        case 2:
            filteredSchemeArr = schemeArr
            break
        case 3:
            break
        case 88:
            filteredProductArr = productArr
            break
        default:
            filteredObjArr = objArr
        }
    }
    @IBAction func cancelBtnClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension DropDownMenuVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch menuType {
        case 0:
            return filteredCitiesArr.count
        case 1:
            return filteredSales_personsArr.count
        case 2:
            return filteredSchemeArr.count
        case 3:
            return genderArr.count
        case 88:
            return filteredProductArr.count
        default:
            return filteredObjArr.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        switch menuType {
        case 0:
            cell.textLabel?.text = filteredCitiesArr[indexPath.row].name
        case 1:
            cell.textLabel?.text = filteredSales_personsArr[indexPath.row].name
        case 2:
            cell.textLabel?.text = filteredSchemeArr[indexPath.row].scheme_name
        case 3:
            cell.textLabel?.text = genderArr[indexPath.row]
        case 5:
            cell.textLabel?.text = filteredObjArr[indexPath.row].fullname
        case 88:
            cell.textLabel?.text = filteredProductArr[indexPath.row].material
        default:
            cell.textLabel?.text = filteredObjArr[indexPath.row].name
        }
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.contentView.backgroundColor = ColorConstant.mainThemeColor
        var item: Any
        
        switch menuType {
        case 0:
            item = filteredCitiesArr[indexPath.row]
        case 1:
            item = filteredSales_personsArr[indexPath.row]
        case 2:
            item = filteredSchemeArr[indexPath.row]
        case 3:
            item = genderArr[indexPath.row]
        case 88:
            item = filteredProductArr[indexPath.row]
        default:
            item = filteredObjArr[indexPath.row]
        }
        self.dismiss(animated: true, completion: {
            self.delegate?.selectedDropDownItem(menuType: self.menuType, menuObj: item)
        })
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
}

extension DropDownMenuVC: UISearchBarDelegate {
    
    // This method updates filteredData based on the text in the Search Box
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        // When there is no text, filteredData is the same as the original data
        // When user has entered text into the search box
        // Use the filter method to iterate over all items in the data array
        // For each item, return true if the item should be included and false if the
        // item should NOT be included
        switch menuType {
        case 0:
            filteredCitiesArr = searchText.isEmpty ? citiesArr : citiesArr.filter({ city -> Bool in
                city.name?.range(of: searchText, options: .caseInsensitive) != nil
            })
            break
        case 1:
            filteredSales_personsArr = searchText.isEmpty ? sales_personsArr : sales_personsArr.filter({ salesPerson -> Bool in
                salesPerson.name?.range(of: searchText, options: .caseInsensitive) != nil
            })
            break
        case 2:
            filteredSchemeArr = searchText.isEmpty ? schemeArr : schemeArr.filter({ scheme -> Bool in
                scheme.scheme_name?.range(of: searchText, options: .caseInsensitive) != nil
            })
            break
        case 3:
            break
        case 88:
            filteredProductArr = searchText.isEmpty ? productArr : productArr.filter({ product -> Bool in
                product.material?.range(of: searchText, options: .caseInsensitive) != nil
            })
            break
        default:
            filteredObjArr = searchText.isEmpty ? objArr : objArr.filter({ hospitalObj -> Bool in
                hospitalObj.name?.range(of: searchText, options: .caseInsensitive) != nil
            })
            break
        }
        tableView.reloadData()
    }
}


