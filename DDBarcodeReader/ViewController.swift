//
//  ViewController.swift
//  DDBarcodeReader
//
//  Created by Chi Hieu on 9/16/15.
//  Copyright (c) 2015 Dream Digits. All rights reserved.
//

import UIKit

class ViewController: UIViewController,BarCodeReaderDelegate {

    
    static var reader:BarcodeReaderViewController!=nil
    static var onceToken: dispatch_once_t = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let testButton = UIButton.buttonWithType(UIButtonType.System) as! UIButton
        testButton.frame = CGRectMake(100, 100, 100, 50)
        testButton.setTitle("TestClick", forState: UIControlState.Normal)
        testButton.addTarget(self, action: Selector("test"), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(testButton)
        
        
    }

    
    func test(){
        
        dispatch_once(&ViewController.onceToken) {
            ViewController.reader = BarcodeReaderViewController()
            ViewController.reader.modalPresentationStyle = UIModalPresentationStyle.FormSheet
            ViewController.reader.delegate = self
        }
        self.presentViewController(ViewController.reader, animated: true, completion: nil)
        
    }
    
    func reader(reader: BarcodeReaderViewController, result: NSString) {
        
        reader.dismissViewControllerAnimated(true, completion: {
            let alert = UIAlertView(title: "OK", message:result as String, delegate: nil, cancelButtonTitle: "OK")
            alert.show()
        })
    
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
}

