//
//  BarCodeScanner.swift
//  Scanner
//
//  Created by Anil on 03/03/15.
//  Copyright (c) 2015 Variya Soft Solutions. All rights reserved.
//

import UIKit
import AVFoundation

class BarCodeScanner: RSCodeReaderViewController {

    @IBOutlet weak var userInfo: UILabel!
    @IBOutlet weak var resultText: UITextView!
    @IBOutlet weak var backImage: UIImageView!
    @IBOutlet weak var startScan: UIButton!
    @IBOutlet var toggle: UIButton!
    @IBOutlet weak var showHistory: UIButton!
    var codes:[String] = []
    var codeCount = 0
    
    @IBAction func toggle(sender: AnyObject?) {
        self.toggleTorch()
    }
    
    func toggleFlash() {
        
        let device = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        if (device.hasTorch) {
            device.lockForConfiguration(nil)
            if (device.torchMode == AVCaptureTorchMode.On) {
                device.torchMode = AVCaptureTorchMode.Off
            }
            device.unlockForConfiguration()
        }
    }
    
    override func viewDidLoad() {
        
        self.resultText.hidden = true
        self.showHistory.hidden = false
        super.viewDidLoad()

        var code = ""
        self.focusMarkLayer.strokeColor = UIColor.redColor().CGColor
        
        self.cornersLayer.strokeColor = UIColor.yellowColor().CGColor
        
        self.tapHandler = { point in
            println(point)
        }
        
        self.barcodesHandler = { barcodes in
            for barcode in barcodes {
                
                var code : String? = barcode.stringValue
                if let newCode = code{
                    
                    
                        dispatch_async(dispatch_get_main_queue()) {
                            
                            self.resultText.hidden = false
                            self.backImage.hidden = false
                            self.startScan.hidden = false
                            self.userInfo.hidden = false
                            self.userInfo.text = "Code Scan Successfull"
                            self.showHistory.hidden = false
                            self.toggleFlash()
                            self.toggle.hidden = true
                            if self.codeCount == 0{
                                
                                self.resultText.text = newCode
                                self.codeCount++
                        }
                    }
                    println("Got Value")
                }
            }
        }
        
        let types = NSMutableArray(array: self.output.availableMetadataObjectTypes)
        types.removeObject(AVMetadataObjectTypeQRCode)
        self.output.metadataObjectTypes = NSArray(array: types)
        
        // MARK: NOTE: If you layout views in storyboard, you should these 3 lines
        for subview in self.view.subviews {
            self.view.bringSubviewToFront(subview as UIView)
        }
        
        if !self.hasTorch() {
            self.toggle.enabled = false
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    @IBAction func startScanPressed(sender: AnyObject) {
        
        self.codeCount = 0
        self.toggle.hidden = false
        self.resultText.hidden = true
        self.backImage.hidden = true
        self.startScan.hidden = true
        self.userInfo.hidden = true
        self.showHistory.hidden = true
    }
    
}
