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
    
    var captureSession:AVCaptureSession!
    var videoPreviewLayer:AVCaptureVideoPreviewLayer!
    var isFromAddSurgery: Bool = false
    var isBarCodeAvailable: Bool = false
    weak var delegate: BarCodeScannerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavBar()
////        TODO: this is temporary
//        UserDefaults.standard.removeObject(forKey: "scannedBarcodes")
        self.setBackCamera()
//        checkCameraPermission()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        GlobalFunctions.configureStatusNavBar(navController: self.navigationController!, bgColor: ColorConstant.mainThemeColor, textColor: UIColor.white)

        if (captureSession?.isRunning == false) {
            captureSession.startRunning()
        }
    }
    
    func setNavBar() {
        self.navigationController?.navigationBar.backgroundColor = ColorConstant.mainThemeColor
        self.navigationItem.title = "Scan"

        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "ic_back"), style: .plain, target: self, action: #selector(self.backButtonPressed))
    }
    
    @objc func backButtonPressed() {
        if (captureSession?.isRunning == true) {
            captureSession.stopRunning()
        }
        if isBarCodeAvailable {
            let alertController = UIAlertController(title: "Warning", message: "Would you like to save data?", preferredStyle: .alert)
            let yesAction = UIAlertAction(title: "YES", style: .default) { _ in
                self.submitScannedBarCodes()
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
            captureMetadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.code39, AVMetadataObject.ObjectType.code128, AVMetadataObject.ObjectType.code39Mod43, AVMetadataObject.ObjectType.code93, AVMetadataObject.ObjectType.ean8, AVMetadataObject.ObjectType.ean13, AVMetadataObject.ObjectType.aztec, AVMetadataObject.ObjectType.pdf417, AVMetadataObject.ObjectType.itf14, AVMetadataObject.ObjectType.interleaved2of5, AVMetadataObject.ObjectType.dataMatrix, AVMetadataObject.ObjectType.upce]
            
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
    
    func saveBarCodeToUserDefaults(code: String) {
        isBarCodeAvailable = true
        var currentStoredArr: [BarCodeModel] = UserSessionManager.shared.barCodes//UserDefaults.standard.array(forKey: "scannedBarcodes") as? [String] ?? []
//        When user scan for Surgery then he/she allows to scan maximum 10 barcodes
        if ((currentStoredArr.count > 0) && (isFromAddSurgery)) {
            openScanAgainDialog(isShowWarning: true)
            return
        }
        currentStoredArr.append(BarCodeModel(barcode: code, dateTime: convertDateToString()))
        UserSessionManager.shared.barCodes = currentStoredArr
        openScanAgainDialog(isShowWarning: false)

    }
    
    func openScanAgainDialog(isShowWarning: Bool) {
        let popUpVC = mainStoryboard.instantiateViewController(withIdentifier: "ScanAgainPopUpVC") as! ScanAgainPopUpVC
        popUpVC.delegate = self
        self.addChild(popUpVC)
        popUpVC.view.frame = CGRect(x: 0, y: 0, width: DeviceConstant.deviceWidth, height: self.view.frame.height)
        self.view.addSubview(popUpVC.view)
        if isShowWarning {
            popUpVC.successMsgLbl.text = "You are not allowed to scan more than 10 barcodes."
            popUpVC.askScanAgainLbl.text = "Would you like to submit your data?"
            popUpVC.askScanAgainLbl.numberOfLines = 2
            popUpVC.titleLbl.text = "Warning"
            popUpVC.scanAgainBtn.setTitle("Cancel", for: .normal)
        }
        popUpVC.didMove(toParent: self)
    }
        
}

extension BarCodeScannerVC: ScanAgainViewDelegate {
  
    func submitScannedBarCodes() {
        delegate?.submitScannedData()
    }
    
    func scanAgain() {
        captureSession.startRunning()
    }
    
}
