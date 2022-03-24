//
//  ScanAgainPopUpVC.swift
//  Meril
//
//  Created by Nidhi Suhagiya on 24/03/22.
//

import Foundation
import UIKit

protocol ScanAgainViewDelegate: AnyObject {
    func scanAgain()
    func submitScannedBarCodes()
}

class ScanAgainPopUpVC: UIViewController {
    
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var titleLbl: UIView!
    @IBOutlet weak var successMsgLbl: UIView!
    @IBOutlet weak var askScanAgainLbl: UIView!
    
    @IBOutlet weak var scanAgainBtn: UIView!
    @IBOutlet weak var submitBtn: UIView!
    
    weak var delegate: ScanAgainViewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    func setUI() {
        popUpView.layer.shadowColor = UIColor.black.cgColor
        popUpView.layer.shadowRadius = 0.5
        popUpView.layer.shadowOpacity = 0.8
        popUpView.layer.shadowOffset = CGSize(width: 0, height: 0)
        popUpView.setViewCorner(radius: 10)
        
        scanAgainBtn.setViewCorner(radius: scanAgainBtn.frame.height / 2)
        submitBtn.setViewCorner(radius: submitBtn.frame.height / 2)
    }
    
    @IBAction func scanAgainBtnClicked(_ sender: Any) {
        self.willMove(toParent: nil)
        self.view.removeFromSuperview()
        self.removeFromParent()
        self.delegate?.scanAgain()
    }
    
    @IBAction func submitBtnClicked(_ sender: Any) {
        self.willMove(toParent: nil)
        self.view.removeFromSuperview()
        self.removeFromParent()
        
        self.delegate?.submitScannedBarCodes()
        
    }
    
}
