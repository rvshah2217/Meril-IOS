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
    weak var delegate: BarCodeScannerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        TODO: this is temporary
        UserDefaults.standard.removeObject(forKey: "scannedBarcodes")
        self.navigationController?.navigationBar.backgroundColor = ColorConstant.mainThemeColor
        self.navigationItem.title = "Scan"
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
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            barCodeFound(code: stringValue)
        }
        
        dismiss(animated: true)
    }
    
    func barCodeFound(code: String) {
        print(code)
        print(UserDefaults.standard.array(forKey: "scannedBarcodes"))
        var currentStoredArr: [BarCodeModel] = UserSessionManager.shared.barCodes//UserDefaults.standard.array(forKey: "scannedBarcodes") as? [String] ?? []
        GlobalFunctions.printToConsole(message: "Total stored barcodes: \(currentStoredArr.count)")
        if ((currentStoredArr.count > 2) && (isFromAddSurgery)) {
            return
        }
        currentStoredArr.append(BarCodeModel(barcode: code, dateTime: convertDateToString()))
        UserSessionManager.shared.barCodes = currentStoredArr
//        currentStoredArr.append(code)
//        UserDefaults.standard.set(currentStoredArr, forKey: "scannedBarcodes")
        openScanAgainDialog()
//        captureSession.startRunning()
    }
    
    func openScanAgainDialog() {
        let popUpVC = mainStoryboard.instantiateViewController(withIdentifier: "ScanAgainPopUpVC") as! ScanAgainPopUpVC
        popUpVC.delegate = self
        self.addChild(popUpVC)
        popUpVC.view.frame = CGRect(x: 0, y: 0, width: DeviceConstant.deviceWidth, height: self.view.frame.height)
        self.view.addSubview(popUpVC.view)
        popUpVC.didMove(toParent: self)
    }
        
}

extension BarCodeScannerVC: ScanAgainViewDelegate {
  
    func submitScannedBarCodes() {
//        TODO: submit stored barcodes
        delegate?.submitScannedData()
    }
    
    func scanAgain() {
        captureSession.startRunning()
    }
    
}
