//
//  BarcodeOverlayView.swift
//  DDBarcodeReader
//
//  Created by Chi Hieu on 9/16/15.
//  Copyright (c) 2015 Dream Digits. All rights reserved.
//

import UIKit

class BarcodeOverlayView: UIView {
    
    private var overlay: CAShapeLayer = {
        var overlay = CAShapeLayer()
        overlay.backgroundColor = UIColor.clearColor().CGColor
        overlay.fillColor       = UIColor.clearColor().CGColor
        overlay.strokeColor     = UIColor.whiteColor().CGColor
        overlay.lineWidth       = 2
        overlay.lineDashPattern = [7.0, 7.0]
        overlay.lineDashPhase   = 0
        
        return overlay
        }()
    
    init() {
        super.init(frame: CGRectZero)  // Workaround for init in iOS SDK 8.3
        
        layer.addSublayer(overlay)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.addSublayer(overlay)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        layer.addSublayer(overlay)
    }
    
    override func drawRect(rect: CGRect) {
        var innerRect  = CGRectInset(rect, 50, 50)
        
        let minSize = min(innerRect.width, innerRect.height)
        if innerRect.width != minSize {
            innerRect.origin.x   += (innerRect.width - minSize) / 2
            innerRect.size.width = minSize
        }
        else if innerRect.height != minSize {
            innerRect.origin.y    += (innerRect.height - minSize) / 2
            innerRect.size.height = minSize
        }
        
        let offsetRect = CGRectOffset(innerRect, 0, 15)
        
        overlay.path  = UIBezierPath(roundedRect: offsetRect
            , cornerRadius: 5).CGPath

    }


    /*
    var overlay:CAShapeLayer!
    var overlayCenter:CGPoint!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addOverlay()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
   
    override func drawRect(rect: CGRect) {
    
        var  innerRect:CGRect = CGRectInset(rect, 50, 50);
        let minSize:CGFloat =  max(innerRect.size.width, innerRect.size.height)
        
        
        if innerRect.size.width != minSize {
            innerRect.origin.x   += (innerRect.size.width - minSize) / 2
            innerRect.size.width = minSize
        }
        
        if (innerRect.size.width != minSize) {
            innerRect.origin.x   += (innerRect.size.width - minSize) / 2;
            innerRect.size.width = minSize;
        }
        else if (innerRect.size.height != minSize) {
            innerRect.origin.y    += (innerRect.size.height - minSize) / 2;
            innerRect.size.height = minSize;
        }
        
        var offsetRect:CGRect = CGRectOffset(innerRect, 0, 15);
        
        
        self.overlay.path = UIBezierPath(roundedRect: offsetRect, cornerRadius: 5).CGPath

        self.overlayCenter = CGPointMake(self.overlay.frame.origin.x + self.overlay.frame.size.width/2, self.overlay.frame.origin.y + self.overlay.frame.size.height/2);
    }
    

    func addOverlay(){
        self.overlay = CAShapeLayer()
        self.overlay.backgroundColor = UIColor.clearColor().CGColor
        self.overlay.fillColor       = UIColor.clearColor().CGColor
        self.overlay.strokeColor     = UIColor.redColor().CGColor
        self.overlay.lineWidth       = 2
        self.overlay.lineDashPattern = [7.0,7.0]
        self.overlay.lineDashPhase   = 0
        self.layer.addSublayer(self.overlay)
    }
    */
}
