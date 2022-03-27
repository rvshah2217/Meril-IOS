//
//  SurgerayListViewController.swift
//  Meril
//
//  Created by iMac on 24/03/22.
//

import UIKit

class InventoryListVC: UIViewController {

    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var viewBK: UIView!
    @IBOutlet weak var tableOuterView: UIView!
    @IBOutlet weak var noDataFoundLbl: UIView!

    var inventoryArr: [SurgeryData] = []
    var filteredInventoryArr: [SurgeryData] = []
    var isFilterApplied: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        self.fetchInventoryList()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    @IBAction func backBtnClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK:- Custome Method
    func setUI() {
        txtSearch.delegate = self
        txtSearch.returnKeyType = .done

        txtSearch.layer.cornerRadius = txtSearch.frame.height / 2
        txtSearch.backgroundColor = UIColor.white
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: txtSearch.frame.height))
        txtSearch.leftViewMode = UITextField.ViewMode.always;
        txtSearch.leftView = view;

        viewBK.backgroundColor = ColorConstant.mainThemeColor
        viewBK.addCornerAtBotttoms(radius: 30)

        tblView.register(UINib.init(nibName:"SurgeryListTableViewCell", bundle: nil), forCellReuseIdentifier: "SurgeryListTableViewCell")
        tblView.delegate = self
        tblView.dataSource = self
        tblView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)

        tblView.addCornerAtTops(radius: 20)
        
        //        Add Shadow
        tableOuterView.layer.masksToBounds = false
        tableOuterView.layer.shadowRadius = 3
        tableOuterView.layer.shadowOpacity = 0.5
        tableOuterView.layer.shadowOffset = CGSize(width: 0, height: 0)
        tableOuterView.layer.shadowColor = UIColor.black.cgColor
    }
    
    func fetchInventoryList() {
        SurgeryServices.getInventories { response, error in
            guard let err = error else {
                self.inventoryArr = response?.surgeryData ?? []
                self.noDataFoundLbl.isHidden = !self.inventoryArr.isEmpty
                self.tblView.reloadData()
                return
            }
            GlobalFunctions.printToConsole(message: "Unable to fetch surgeries: \(err)")
        }
    }
}
extension InventoryListVC:UITableViewDelegate,UITableViewDataSource{

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isFilterApplied ? filteredInventoryArr.count : inventoryArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SurgeryListTableViewCell") as! SurgeryListTableViewCell
        cell.itemDetail = isFilterApplied ? filteredInventoryArr[indexPath.row] : inventoryArr[indexPath.row]

        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension InventoryListVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        isFilterApplied = (textField.text ?? "").count > 0
        self.filteredArrOnSearch()
        return true
    }
    
    func filteredArrOnSearch() {
        let searchStr = txtSearch.text ?? ""
        filteredInventoryArr = inventoryArr.filter {
            ($0.patient_name ?? "").localizedCaseInsensitiveContains(searchStr)
        }
        self.noDataFoundLbl.isHidden = !(isFilterApplied && self.filteredInventoryArr.isEmpty)
        self.tblView.reloadData()
    }
}
