//
//  QRCodeScanner.swift
//  Scanner
//
//  Created by Anil on 03/03/15.
//  Copyright (c) 2015 Variya Soft Solutions. All rights reserved.
//

import UIKit
import AVFoundation

class QRCodeScanner: UIViewController, AVCaptureMetadataOutputObjectsDelegate {

    var captureSession:AVCaptureSession?
    var videoPreviewLayer:AVCaptureVideoPreviewLayer?
    var qrCodeFrameView:UIView?
    var codeCount = 0
    
    @IBOutlet weak var messageLabel: UITextView!
    @IBOutlet weak var saveSuccess: UILabel!
    @IBOutlet weak var toggle: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.toggle.hidden = true
        self.messageLabel.hidden = true
    }
    
    @IBAction func startScan(sender: AnyObject) {
        
        self.codeCount = 0
        self.toggle.hidden = false
        self.openQRScanner()
    }
    
    @IBAction func toggelPressed(sender: AnyObject) {
        
        self.toggleFlash()
    }
    
    func toggleFlash() {
        let device = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        if (device.hasTorch) {
            device.lockForConfiguration(nil)
            if (device.torchMode == AVCaptureTorchMode.On) {
                device.torchMode = AVCaptureTorchMode.Off
            } else {
                device.setTorchModeOnWithLevel(1.0, error: nil)
            }
            device.unlockForConfiguration()
        }
    }
    
    func flashOff(){
        
        let device = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        if (device.hasTorch) {
            device.lockForConfiguration(nil)
            if (device.torchMode == AVCaptureTorchMode.On) {
                device.torchMode = AVCaptureTorchMode.Off
            }
            device.unlockForConfiguration()
        }
    }

    func openQRScanner(){
        
        // Get an instance of the AVCaptureDevice class to initialize a device object and provide the video
        // as the media type parameter.
        let captureDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        
        // Get an instance of the AVCaptureDeviceInput class using the previous device object.
        var error : NSError?
        let input : AnyObject! = AVCaptureDeviceInput.deviceInputWithDevice(captureDevice, error: &error)
        if (error != nil){
            
            // If any error occurs, simply log the description of it and don't continue any more.
            println("\(error?.description)")
            return
        }
        // Initialize the captureSession object.
        captureSession = AVCaptureSession()
        captureSession?.addInput(input as AVCaptureInput)
        
        // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.
        let captureMetadataOutput = AVCaptureMetadataOutput()
        captureSession?.addOutput(captureMetadataOutput)
        
        // Set delegate and use the default dispatch queue to execute the call back
        captureMetadataOutput.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
        captureMetadataOutput.metadataObjectTypes = [AVMetadataObjectTypeQRCode]
        
        // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        videoPreviewLayer?.frame = view.layer.bounds
        view.layer.addSublayer(videoPreviewLayer)
        
        // Start video capture.
        captureSession?.startRunning()
        
        // Move the message label to the top view
        view.bringSubviewToFront(self.toggle)
        
        // Initialize QR Code Frame to highlight the QR code
        qrCodeFrameView = UIView()
        qrCodeFrameView?.layer.borderColor = UIColor.greenColor().CGColor
        qrCodeFrameView?.layer.borderWidth = 2
        view.addSubview(qrCodeFrameView!)
        view.bringSubviewToFront(qrCodeFrameView!)
        
        
    }
    
    
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        
        // Check if the metadataObjects array is not nil and it contains at least one object.
        if metadataObjects == nil || metadataObjects.count == 0 {
            qrCodeFrameView?.frame = CGRectZero
            return
        }
        
        // Get the metadata object.
        let metadataObj = metadataObjects[0] as AVMetadataMachineReadableCodeObject
        
        if metadataObj.type == AVMetadataObjectTypeQRCode {
            // If the found metadata is equal to the QR code metadata then update the status label's text and set the bounds
            let barCodeObject = videoPreviewLayer?.transformedMetadataObjectForMetadataObject(metadataObj as AVMetadataMachineReadableCodeObject) as AVMetadataMachineReadableCodeObject
            qrCodeFrameView?.frame = barCodeObject.bounds;
            
            if metadataObj.stringValue != nil {
                
                self.messageLabel.hidden = false
                if self.codeCount == 0{
                    
                    self.messageLabel.text = metadataObj.stringValue
                    self.codeCount++
                }
                
                self.saveSuccess.text = "Data Saved SuccessFully"
                self.videoPreviewLayer?.removeFromSuperlayer()
                self.qrCodeFrameView?.removeFromSuperview()
                self.toggle.hidden = true
                self.flashOff()
            }
        }
    }
}
