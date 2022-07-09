//
//  BarCodeScannerVC.swift
//  Meril
//
//  Created by Nidhi Suhagiya on 23/03/22.
//

import UIKit
import AVFoundation

protocol BarCodeScannerDelegate: AnyObject {
    func submitScannedData()
}

class BarCodeScannerVC: UIViewController {
    
    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var barcodeScanCollectionView: UICollectionView!
    @IBOutlet weak var manualBarcodeCollectionView: UICollectionView!
    @IBOutlet weak var scanAgainBtn: UIButton!
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var barcodeScanCVHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var manualBarcodeCVHeightConstraint: NSLayoutConstraint!

    var captureSession:AVCaptureSession!
    var videoPreviewLayer:AVCaptureVideoPreviewLayer!
    var isFromAddSurgery: Bool = false
    var isBarCodeAvailable: Bool = false
    weak var delegate: BarCodeScannerDelegate?
    var flashBtn: UIBarButtonItem!
    
    var manualEntryArr: [ManualEntryModel] = []
    var barCodeArr: [BarCodeModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        UserDefaults.standard.removeObject(forKey: "scannedBarcodes")
        UserDefaults.standard.removeObject(forKey: "manualEntryData")

        setNavBar()
        self.setBackCamera()
        self.setUI()
//        checkCameraPermission()
    }
    
    func setUI() {
        self.barcodeScanCollectionView.delegate = self
        self.barcodeScanCollectionView.dataSource = self
        self.manualBarcodeCollectionView.delegate = self
        self.manualBarcodeCollectionView.dataSource = self
        scanAgainBtn.setViewCorner(radius: scanAgainBtn.frame.height / 2)
        submitBtn.setViewCorner(radius: submitBtn.frame.height / 2)
        self.barcodeScanCVHeightConstraint.constant = 0
        self.manualBarcodeCVHeightConstraint.constant = 0
        self.barcodeScanCollectionView.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        self.manualBarcodeCollectionView.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
      
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        self.barcodeScanCollectionView.collectionViewLayout = flowLayout
        
        let flowLayout1 = UICollectionViewFlowLayout()
        flowLayout1.scrollDirection = .horizontal
        self.manualBarcodeCollectionView.collectionViewLayout = flowLayout1
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        GlobalFunctions.configureStatusNavBar(navController: self.navigationController!, bgColor: ColorConstant.mainThemeColor, textColor: UIColor.white)

        if (captureSession?.isRunning == false) {
            captureSession.startRunning()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        videoPreviewLayer?.frame = cameraView.layer.bounds
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        GlobalFunctions.printToConsole(message: "View did disappear")
//        UserDefaults.standard.removeObject(forKey: "scannedBarcodes")
//        UserDefaults.standard.removeObject(forKey: "manualEntryData")
    }
    
    func setNavBar() {
        self.navigationController?.navigationBar.backgroundColor = ColorConstant.mainThemeColor
        self.navigationItem.title = "Scan"

        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "ic_back"), style: .plain, target: self, action: #selector(self.backButtonPressed))
        
//        if isFromAddSurgery {
//            let addBtn = UIBarButtonItem(image: UIImage(named: "ic_add"), style: .plain, target: self, action: #selector(self.addManualSurgeryBtnCicked))
//            self.navigationItem.rightBarButtonItems = [addBtn]
//        }
        
        flashBtn = UIBarButtonItem(image: UIImage(named: "ic_flashOn"), style: .plain, target: self, action: #selector(self.toggleFlash))
//        self.navigationItem.rightBarButtonItems?.append(flashBtn)
        
        let addBtn = UIBarButtonItem(image: UIImage(named: "ic_add"), style: .plain, target: self, action: #selector(self.addManualSurgeryBtnCicked))
        if isFromAddSurgery {
            self.navigationItem.rightBarButtonItems = [addBtn, flashBtn]
        } else {
            self.navigationItem.rightBarButtonItems = [flashBtn]
        }
        
//        self.navigationItem.rightBarButtonItems = [flashBtn]
    }
    
    @objc func toggleFlash() {
        guard let device = AVCaptureDevice.default(for: AVMediaType.video) else { return }
            guard device.hasTorch else { return }
            do {
                try device.lockForConfiguration()
                if (device.torchMode == AVCaptureDevice.TorchMode.on) {
                    device.torchMode = AVCaptureDevice.TorchMode.off
                    flashBtn.image = UIImage(named: "ic_flashOff")
                } else {
                    do {
                        try device.setTorchModeOn(level: 1.0)
                        flashBtn.image = UIImage(named: "ic_flashOn")
                    } catch {
                        print(error)
                    }
                }

                device.unlockForConfiguration()
            } catch {
                print(error)
            }
    }
    
    @objc func addManualSurgeryBtnCicked() {
        let nextVC = mainStoryboard.instantiateViewController(withIdentifier: "ManualScanEntryVC") as! ManualScanEntryVC
        nextVC.modalPresentationStyle = .overCurrentContext
        nextVC.modalTransitionStyle = .crossDissolve
        nextVC.view.backgroundColor = .black.withAlphaComponent(0.5)
        nextVC.delegate = self
        self.navigationController?.present(nextVC, animated: true, completion: nil)
    }
    
    @objc func backButtonPressed() {
        if (captureSession?.isRunning == true) {
            captureSession.stopRunning()
        }
        if isBarCodeAvailable {
            let alertController = UIAlertController(title: "Warning", message: "Would you like to save data?", preferredStyle: .alert)
            let yesAction = UIAlertAction(title: "YES", style: .default) { _ in
//                self.submitScannedBarCodes()
                self.submitBtnClicked(self.submitBtn!)
            }
            let noAction = UIAlertAction(title: "NO", style: .default) { _ in
                self.navigationController?.popViewController(animated: true)
            }
            alertController.addAction(yesAction)
            alertController.addAction(noAction)
            self.present(alertController, animated: true, completion: nil)
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if (captureSession?.isRunning == true) {
            captureSession.stopRunning()
        }
    }
    
    func checkCameraPermission() {
        let authorizationStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)

           switch authorizationStatus {
           case .notDetermined:
               AVCaptureDevice.requestAccess(for: AVMediaType.video) { granted in
                   if granted {
                       print("access granted")
                               self.setBackCamera()
                   }
                   else {
                       print("access denied")
                   }
               }
           case .authorized:
               print("Access authorized")
           case .denied, .restricted:
               print("restricted")
           default:
               print("Miscellaneous")
           }
    }
    
    func setBackCamera() {
        
        captureSession = AVCaptureSession()
        
        // Get the back-facing camera for capturing videos
        guard let captureDevice = AVCaptureDevice.default(for: .video) else {
            print("Failed to get the camera device")
            return
        }

        do {
            // Get an instance of the AVCaptureDeviceInput class using the previous device object.
            let input = try AVCaptureDeviceInput(device: captureDevice)
            
            // Set the input device on the capture session.
            captureSession?.addInput(input)
            // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession.addOutput(captureMetadataOutput)
            // Set delegate and use the default dispatch queue to execute the call back
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.code39, AVMetadataObject.ObjectType.code128, AVMetadataObject.ObjectType.code39Mod43, AVMetadataObject.ObjectType.code93, AVMetadataObject.ObjectType.ean8, AVMetadataObject.ObjectType.ean13, AVMetadataObject.ObjectType.aztec, AVMetadataObject.ObjectType.pdf417, AVMetadataObject.ObjectType.itf14, AVMetadataObject.ObjectType.interleaved2of5, AVMetadataObject.ObjectType.dataMatrix, AVMetadataObject.ObjectType.upce, AVMetadataObject.ObjectType.qr]
            
            // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            videoPreviewLayer?.frame = cameraView.layer.bounds
            videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
            cameraView.layer.addSublayer(videoPreviewLayer!)
            
            captureSession.startRunning()
            
        } catch {
            // If any error occurs, simply print it out and don't continue any more.
            print(error)
            return
        }
    }
    
    func failed() {
        let ac = UIAlertController(title: "Scanning not supported", message: "Your device does not support scanning a code from an item. Please use a device with a camera.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
        captureSession = nil
    }
}

extension BarCodeScannerVC: AVCaptureMetadataOutputObjectsDelegate {
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        captureSession.stopRunning()
        
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            AudioServicesPlayAlertSoundWithCompletion(SystemSoundID(kSystemSoundID_Vibrate)) { }
//            barCodeFound(code: stringValue)
            
//            If network available then check barcode is valid or not, otherwise store it into local database or core data
            if appDelegate.reachability.connection == .unavailable {
                self.saveBarCodeToUserDefaults(code: stringValue)
            } else {
                self.checkBarCodeStatus(scannedBarCode: stringValue)
            }
        }
        
        dismiss(animated: true)
    }
    
//    func barCodeFound(code: String) {
//        print(code)
//        print(UserDefaults.standard.array(forKey: "scannedBarcodes"))
//        self.checkBarCodeStatus(scannedBarCode: code)
//    }
    
    func checkBarCodeStatus(scannedBarCode: String) {
        ShowLoaderWithMessage(message: "Please wait...")
        SurgeryServices.checkBarcodeStatus(barCode: scannedBarCode) { response, error in
            HIDE_CUSTOM_LOADER()
            guard let responseData = response else {
                self.showInvalidBarCodeError()
                return
            }

            if let barCodeStatus = responseData.barCodeStatusModel, barCodeStatus.status != "invalid_barcode" {
                self.saveBarCodeToUserDefaults(code: scannedBarCode)
            } else {
                self.showInvalidBarCodeError()
            }
        }
    }
    
    func showInvalidBarCodeError() {
        GlobalFunctions.showToast(controller: self, message: "Invalid barcode. Please scan again", seconds: errorDismissTime) {
            self.captureSession.startRunning()
        }
    }
    
//    func saveBarCodeToUserDefaults(code: String) {
//        isBarCodeAvailable = true
//        var currentStoredArr: [BarCodeModel] = UserSessionManager.shared.barCodes//UserDefaults.standard.array(forKey: "scannedBarcodes") as? [String] ?? []
////        When user scan for Surgery then he/she allows to scan maximum 10 barcodes
//        if ((currentStoredArr.count > 10) && (isFromAddSurgery)) {
//            openScanAgainDialog(isShowWarning: true)
//            return
//        }
//        currentStoredArr.append(BarCodeModel(barcode: code, dateTime: convertDateToString()))
//        UserSessionManager.shared.barCodes = currentStoredArr
//        openScanAgainDialog(isShowWarning: false)
//
//    }
    func saveBarCodeToUserDefaults(code: String) {
        isBarCodeAvailable = true
        self.manualEntryArr = UserSessionManager.shared.manualEntryData
        self.barCodeArr = UserSessionManager.shared.barCodes
//        When user scan for Surgery then he/she allows to scan maximum 10 barcodes
        let currentStoredArr = barCodeArr.count + manualEntryArr.count
        if ((currentStoredArr > 10) && (isFromAddSurgery)) {
//            openScanAgainDialog(isShowWarning: true)
            GlobalFunctions.showToast(controller: self, message: "You are not allowed to scan more than 10 barcodes.", seconds: successDismissTime, completionHandler: nil)
            return
        }
        barCodeArr.append(BarCodeModel(barcode: code, dateTime: convertDateToString()))
        UserSessionManager.shared.barCodes = self.barCodeArr
//        openScanAgainDialog(isShowWarning: false)
        
        self.reloadCollectionViews()

//        let arr = barCodeArr.filter { item in
//            item.barcode == code
//        }
//        if arr.count > 0 {
////            show duplication error
//            GlobalFunctions.showToast(controller: self, message: "Barcode exist already.", seconds: successDismissTime, completionHandler: nil)
//        } else {
//            barCodeArr.append(BarCodeModel(barcode: code, dateTime: convertDateToString()))
//            UserSessionManager.shared.barCodes = self.barCodeArr
//    //        openScanAgainDialog(isShowWarning: false)
//
//            self.reloadCollectionViews()
//        }
    }
    
    private func reloadCollectionViews() {
//        Reload barcode collectionView
        self.barcodeScanCVHeightConstraint.constant = barCodeArr.isEmpty ? 0 : 100
        self.barcodeScanCollectionView.reloadData()
//        Reload Manual entry barcode collection view
        self.manualBarcodeCVHeightConstraint.constant = manualEntryArr.isEmpty ? 0 : 80
        self.manualBarcodeCollectionView.reloadData()
    }
    
    @IBAction func scanAgainBtnClicked(_ sender: Any) {
        captureSession.startRunning()
    }
    
    @IBAction func submitBtnClicked(_ sender: Any) {
        self.manualEntryArr = UserSessionManager.shared.manualEntryData
        self.barCodeArr = UserSessionManager.shared.barCodes
//        When user scan for Surgery then he/she allows to scan maximum 10 barcodes
        let currentStoredArrCount = barCodeArr.count + manualEntryArr.count
        if currentStoredArrCount <= 0 {
            GlobalFunctions.showToast(controller: self, message: UserMessages.scanAtLeastOneCodeError, seconds: errorDismissTime, completionHandler: nil)
        } else {
            delegate?.submitScannedData()
        }
    }
    
//    func openScanAgainDialog(isShowWarning: Bool) {
//        let popUpVC = mainStoryboard.instantiateViewController(withIdentifier: "ScanAgainPopUpVC") as! ScanAgainPopUpVC
//        popUpVC.delegate = self
//        self.addChild(popUpVC)
//        popUpVC.view.frame = CGRect(x: 0, y: 0, width: DeviceConstant.deviceWidth, height: self.view.frame.height)
//        self.view.addSubview(popUpVC.view)
//        if isShowWarning {
//            popUpVC.successMsgLbl.text = "You are not allowed to scan more than 10 barcodes."
//            popUpVC.askScanAgainLbl.text = "Would you like to submit your data?"
//            popUpVC.askScanAgainLbl.numberOfLines = 2
//            popUpVC.titleLbl.text = "Warning"
//            popUpVC.scanAgainBtn.setTitle("Cancel", for: .normal)
//        }
//        popUpVC.didMove(toParent: self)
//    }
        
}

//extension BarCodeScannerVC: ScanAgainViewDelegate {
//
//    func submitScannedBarCodes() {
//        delegate?.submitScannedData()
//    }
//
//    func scanAgain() {
//        captureSession.startRunning()
//    }
//
//}

extension BarCodeScannerVC: ManualEntryDelegate {
    
    func addManualSurgeryData(manuallyAddedData: ManualEntryModel) {
        isBarCodeAvailable = true
//        var currentManualEntryArr: [ManualEntryModel] = UserSessionManager.shared.manualEntryData
//        let currentStoredArr: [BarCodeModel] = UserSessionManager.shared.barCodes
        self.manualEntryArr = UserSessionManager.shared.manualEntryData
        self.barCodeArr = UserSessionManager.shared.barCodes

//        When user scan for Surgery then he/she allows to scan maximum 10 barcodes
        
        let totalArr = barCodeArr.count + manualEntryArr.count
        
        if ((totalArr > 10) && (isFromAddSurgery)) {
//            openScanAgainDialog(isShowWarning: true)
            GlobalFunctions.showToast(controller: self, message: "You are not allowed to scan more than 10 barcodes.", seconds: successDismissTime, completionHandler: nil)
            return
        }
        
//        let arr = manualEntryArr.filter { item in
//            item.sku == manuallyAddedData.sku
//        }
        
        manualEntryArr.append(manuallyAddedData)
        UserSessionManager.shared.manualEntryData = manualEntryArr
        self.reloadCollectionViews()

//        if arr.count > 0 {
////            show duplication error
//            GlobalFunctions.showToast(controller: self, message: "Barcode exist already.", seconds: successDismissTime, completionHandler: nil)
//        } else {
//            manualEntryArr.append(manuallyAddedData)
//            UserSessionManager.shared.manualEntryData = manualEntryArr
//            self.reloadCollectionViews()
//        }
//        GlobalFunctions.showToast(controller: self, message: "Your data has been saved successfully.", seconds: successDismissTime, completionHandler: nil)
//        openScanAgainDialog(isShowWarning: false)
    }
}

//#MARK: Collectionview delegate and datasource
extension BarCodeScannerVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case barcodeScanCollectionView:
            return barCodeArr.count
        default:
            return manualEntryArr.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! BarCodeCell
        switch collectionView {
        case barcodeScanCollectionView:
            let str = "Scan#\(indexPath.row + 1)\n"
            cell.titleLbl.text = str + barCodeArr[indexPath.row].barcode
            GlobalFunctions.printToConsole(message: "Barcode str: \(barCodeArr[indexPath.row].barcode)")
        default:
            let str = "Manual entry#\(indexPath.row + 1)\n"
            GlobalFunctions.printToConsole(message: "manualEntry str: \(manualEntryArr[indexPath.row].sku)")
            cell.titleLbl.text = str + (manualEntryArr[indexPath.row].sku ?? "N/A")
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView {
        case barcodeScanCollectionView:
            return CGSize(width: 180, height: 80)
        default:
            return CGSize(width: 180, height: 60)
        }
    }
}
