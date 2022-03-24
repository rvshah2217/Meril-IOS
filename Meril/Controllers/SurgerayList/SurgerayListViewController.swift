//
//  SurgerayListViewController.swift
//  Meril
//
//  Created by iMac on 24/03/22.
//

import UIKit

class SurgerayListViewController: UIViewController {

    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var constrainScrollViewTop: NSLayoutConstraint!
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var constrainTblheight: NSLayoutConstraint!
    @IBOutlet weak var viewBK: UIView!
    @IBOutlet weak var scrollviewData: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigation()
    }
    //MARK:- Custome Method
    func setUI(){
        btnSubmit.layer.cornerRadius = btnSubmit.frame.height / 2
        btnSubmit.backgroundColor = ColorConstant.mainThemeColor
        btnSubmit.setTitleColor(UIColor.white, for: .normal)
        txtSearch.layer.cornerRadius = txtSearch.frame.height / 2
        txtSearch.backgroundColor = UIColor.white
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: txtSearch.frame.height))
        txtSearch.leftViewMode = UITextField.ViewMode.always;
        txtSearch.leftView = view;

        viewBK.backgroundColor = ColorConstant.mainThemeColor
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
            let rectShape = CAShapeLayer()
            rectShape.bounds = self.viewBK.frame
            rectShape.position = self.viewBK.center
            rectShape.path = UIBezierPath(roundedRect: self.viewBK.bounds, byRoundingCorners: [.bottomLeft , .bottomRight], cornerRadii: CGSize(width: 50, height: 50)).cgPath
            self.viewBK.layer.mask = rectShape
        }
        tblView.register(UINib.init(nibName:"SurgeriListTableViewCell", bundle: nil), forCellReuseIdentifier: "SurgeriListTableViewCell")
        tblView.delegate = self
        tblView.dataSource = self
        
        scrollviewData.layer.cornerRadius = 20
        scrollviewData.layer.borderWidth = 0.5
        scrollviewData.layer.borderColor = UIColor.lightGray.cgColor
        if IS_IPHONE_X() || IS_IPHONE_XR() || IS_IPHONE_PRO_MAX(){
            constrainScrollViewTop.constant = 130
        }
        
    }
    func setNavigation(){
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
}
extension SurgerayListViewController:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SurgeriListTableViewCell") as! SurgeriListTableViewCell
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1){
            self.constrainTblheight.constant = self.tblView.contentSize.height
        }
        
        if indexPath.row == 0 || indexPath.row == 3{
            cell.viewMain.backgroundColor = ColorConstant.mainThemeColor
            cell.lblTitle.textColor = UIColor.white
            cell.lblCode.textColor = UIColor.white
            cell.lblDate.textColor = UIColor.white
            cell.lblQuCode.textColor = UIColor.white
        }else{
            cell.viewMain.backgroundColor = UIColor.white
            cell.lblTitle.textColor = ColorConstant.mainThemeColor
            cell.lblCode.textColor = ColorConstant.mainThemeColor
            cell.lblDate.textColor = ColorConstant.mainThemeColor
            cell.lblQuCode.textColor = ColorConstant.mainThemeColor
            cell.viewMain.layer.borderColor = ColorConstant.mainThemeColor.cgColor
            cell.viewMain.layer.borderWidth = 1
        }
        
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
