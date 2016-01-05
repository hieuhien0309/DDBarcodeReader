//
//  BarcodeReaderViewController.swift
//  DDBarcodeReader
//
//  Created by Chi Hieu on 9/16/15.
//  Copyright (c) 2015 Dream Digits. All rights reserved.
//

import UIKit
import AVFoundation


protocol BarCodeReaderDelegate :NSObjectProtocol{
    func reader(reader:BarcodeReaderViewController,result:NSString)
}

class BarcodeReaderViewController: UIViewController,AVCaptureMetadataOutputObjectsDelegate {
    
   // var torchActiveObservationContext:Void! = (voi)torchActiveObservationContext

    var delegate:BarCodeReaderDelegate!
    
    
    var torchActiveObservationContext:Void = ()
    
    
    private var switchCameraButton:CameraSwitchButton!
    
    private var cameraView:BarcodeOverlayView!
    private var highlightView:UIView!
    private var cancelButton:UIButton!
    
    private var torchLevel:Float = 0.0
    
    
    private var defaultDevice:AVCaptureDevice!
    private var defaultDeviceInput:AVCaptureDeviceInput!
    private var frontDevice:AVCaptureDevice!
    private var frontDeviceInput:AVCaptureDeviceInput!
    private var metadataOutput:AVCaptureMetadataOutput!
    private var session:AVCaptureSession!
    private var previewLayer:AVCaptureVideoPreviewLayer!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupAVComponents()
        self.configureDefaultComponents()
        
        let str = NSLocalizedString("Cancel", tableName: nil, bundle: NSBundle.mainBundle(), value: "Cancel", comment: "Cancel")
        self.setupUIComponentsWithCancelButtonTitle(str)
        self.setupAutoLayoutConstraints()
        self.cameraView.layer.insertSublayer(self.previewLayer, atIndex: 0)
    }

    
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!){
      
        
        var highlightViewRect:CGRect! = CGRectZero
        
        var barCodeObject:AVMetadataMachineReadableCodeObject!
        
        var scannedResult:String! = nil;
        
        for metadata in metadataObjects {
            if metadata.isKindOfClass(AVMetadataMachineReadableCodeObject.self) {
                for type in self.metadataOutput.metadataObjectTypes {
                    if metadata.type == type as! String  {
                        barCodeObject = self.previewLayer.transformedMetadataObjectForMetadataObject(metadata as! AVMetadataMachineReadableCodeObject) as! AVMetadataMachineReadableCodeObject
                        highlightViewRect = barCodeObject.bounds
                        scannedResult = metadata.stringValue
                        break
                    }
                }
            }
            self.delegate.reader(self, result: scannedResult)
            self.stopScanning()
            break
        }

        
        /*
        for metadata in metadataObjects {
            if metadata.isKindOfClass(AVMetadataMachineReadableCodeObject.self) {
                for type in self.metadataOutput.metadataObjectTypes {
                    
                    if metadata.type == type as! String {
                         barCodeObject = self.previewLayer.transformedMetadataObjectForMetadataObject(metadata as! AVMetadataMachineReadableCodeObject) as! AVMetadataMachineReadableCodeObject
                        highlightViewRect = barCodeObject.bounds
                        scannedResult = metadata.stringValue
                        break
                    }
                }
            }else{
                self.delegate.reader(self, result: scannedResult)
                break
            }
        }
        */
        self.highlightView.frame = highlightViewRect;
    }
    
    func setupAVComponents(){
        self.defaultDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)//[AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        if (self.defaultDevice != nil) {
      
            
            self.defaultDeviceInput = AVCaptureDeviceInput.deviceInputWithDevice(self.defaultDevice, error: nil) as! AVCaptureDeviceInput
            
            
            self.metadataOutput     = AVCaptureMetadataOutput()
            self.session            = AVCaptureSession()
            self.previewLayer       = AVCaptureVideoPreviewLayer.layerWithSession(self.session) as! AVCaptureVideoPreviewLayer
    
            
            for device in AVCaptureDevice.devicesWithMediaType(AVMediaTypeVideo) {
                if (device.position == AVCaptureDevicePosition.Front) {
                    self.frontDevice = device as! AVCaptureDevice;
                }
            }
            
            if ((self.frontDevice) != nil) {
                self.frontDeviceInput = AVCaptureDeviceInput.deviceInputWithDevice(self.frontDevice, error: nil) as!  AVCaptureDeviceInput
            }
            
            self.defaultDevice.addObserver(self, forKeyPath:"torchActive", options: NSKeyValueObservingOptions.New, context: UnsafeMutablePointer(nilLiteral: torchActiveObservationContext))
            
        }
    }
    
    override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>) {
        
        if context == UnsafeMutablePointer(nilLiteral: torchActiveObservationContext) {
           self.controlTorchLevel()
        }
        //super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context)
    }
    
    func controlTorchLevel(){
        
        if self.defaultDevice.hasTorch && self.defaultDevice.hasFlash {
            if self.defaultDevice.torchMode == AVCaptureTorchMode.Auto {
                if self.defaultDevice.torchActive {
                    self.setTorchStatus(true)
                }else{
                    self.setTorchStatus(false)
                }
            }else{
                self.setTorchStatus(false)
            }
        }
    }
    
    
  
    func setTorchStatus(Status:Bool){
        self.defaultDevice.lockForConfiguration(nil)
        if (self.defaultDevice.hasTorch && self.defaultDevice.hasFlash){
            if (Status) {
                self.defaultDevice.lockForConfiguration(nil)
                let torchOn = !self.defaultDevice.torchActive
                self.defaultDevice.setTorchModeOnWithLevel(1.0, error: nil)
                //self.defaultDevice.torchMode = torchOn ? AVCaptureTorchMode.On : AVCaptureTorchMode.Off
                //self.defaultDevice.setTorchModeOnWithLevel(1.0, error: nil)
            }else{
                self.defaultDevice.torchMode = AVCaptureTorchMode.Auto
            }
        }
        
        self.defaultDevice.unlockForConfiguration()
    }
    
    func configureDefaultComponents(){
        self.setTorchStatus(false)
        self.session.addOutput(self.metadataOutput)
        if (self.defaultDeviceInput != nil) {
            self.session.addInput(self.defaultDeviceInput)
        }

        self.metadataOutput.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
        var barcodeTypes: [AnyObject] = [AVMetadataObjectTypeUPCECode, AVMetadataObjectTypeCode39Code, AVMetadataObjectTypeCode39Mod43Code, AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode93Code, AVMetadataObjectTypeCode128Code, AVMetadataObjectTypePDF417Code, AVMetadataObjectTypeQRCode, AVMetadataObjectTypeAztecCode]
        self.metadataOutput.metadataObjectTypes = barcodeTypes
    
        self.previewLayer.frame = self.view.bounds;
        self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        
        switch (UIDevice.currentDevice().orientation) {
            
        case .LandscapeLeft:
            previewLayer.connection.videoOrientation = .LandscapeLeft
            break
            
        case .LandscapeRight:
            previewLayer.connection.videoOrientation = .LandscapeRight
            break
            
        case .PortraitUpsideDown:
            previewLayer.connection.videoOrientation = .PortraitUpsideDown
            break
            
        case .Portrait:
            previewLayer.connection.videoOrientation = .Portrait
            break
            
        default:
            previewLayer.connection.videoOrientation = .Portrait
            break
        }
        
        self.view.layer.addSublayer(self.previewLayer)
    }
    
    
    func setupUIComponentsWithCancelButtonTitle(cancelTitle:String){
        self.cameraView = BarcodeOverlayView(frame: self.view.frame)
        self.cameraView.setTranslatesAutoresizingMaskIntoConstraints(false)
        //self.cameraView.autoresizingMask = UIViewAutoresizing.FlexibleTopMargin | UIViewAutoresizing.FlexibleLeftMargin | UIViewAutoresizing.FlexibleRightMargin | UIViewAutoresizing.FlexibleBottomMargin
        self.cameraView.clipsToBounds = true
        self.view.addSubview(self.cameraView)
        
        self.highlightView = UIView()
        self.highlightView.autoresizingMask = UIViewAutoresizing.FlexibleTopMargin | UIViewAutoresizing.FlexibleLeftMargin | UIViewAutoresizing.FlexibleRightMargin | UIViewAutoresizing.FlexibleBottomMargin
        self.highlightView.layer.borderColor = UIColor.greenColor().CGColor
        self.highlightView.layer.borderWidth = 2
        self.cameraView.addSubview(self.highlightView)
        
        if (self.frontDevice != nil) {
            self.switchCameraButton = CameraSwitchButton()
            self.switchCameraButton.setTranslatesAutoresizingMaskIntoConstraints(false)
            self.switchCameraButton.addTarget(self, action: "switchCameraAction:", forControlEvents: UIControlEvents.TouchUpInside)
            self.view.addSubview(self.switchCameraButton)
        }
        
        self.cancelButton = UIButton()
        self.cancelButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.cancelButton.setTitle(cancelTitle, forState: UIControlState.Normal)
        self.cancelButton.setTitleColor(UIColor.grayColor(), forState: UIControlState.Highlighted)
        self.cancelButton.addTarget(self, action: "cancelAction:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(self.cancelButton)
    }
    
    func setupAutoLayoutConstraints(){
        
        let views: [NSObject: AnyObject] = ["cameraView": cameraView, "cancelButton": cancelButton]
        
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[cameraView][cancelButton(40)]|", options: .allZeros, metrics: nil, views: views))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[cameraView]|", options: .allZeros, metrics: nil, views: views))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-[cancelButton]-|", options: .allZeros, metrics: nil, views: views))
        
        if let _switchCameraButton = switchCameraButton {
            let switchViews: [NSObject: AnyObject] = ["switchCameraButton": _switchCameraButton]
            
            view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[switchCameraButton(50)]", options: .allZeros, metrics: nil, views: switchViews))
            view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[switchCameraButton(70)]|", options: .allZeros, metrics: nil, views: switchViews))
        }
    }
    
    
    func startScanning(){
        if !self.session.running {
            self.highlightView.frame = CGRectZero
        }
         self.session.startRunning()
    }
  
    
    func stopScanning(){
        if self.session.running {
            self.session.stopRunning()
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        self.startScanning()
        self.ReloadCamera()
    }
    
    func ReloadCamera(){
        self.cameraView.setNeedsDisplay()
        
        switch (UIDevice.currentDevice().orientation) {
            
        case .LandscapeLeft:
            previewLayer.connection.videoOrientation = .LandscapeLeft
            break
            
        case .LandscapeRight:
            previewLayer.connection.videoOrientation = .LandscapeRight
            break
            
        case .PortraitUpsideDown:
            previewLayer.connection.videoOrientation = .PortraitUpsideDown
            break
            
        case .Portrait:
            previewLayer.connection.videoOrientation = .Portrait
            break
            
        default:
            previewLayer.connection.videoOrientation = .Portrait
            break
        }
    }
    
    override func viewDidDisappear(animated: Bool) {
        self.stopScanning()
    }
    
    override func viewDidLayoutSubviews() {
        self.previewLayer.frame = self.view.bounds
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func  willAnimateRotationToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
        self.ReloadCamera()
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
