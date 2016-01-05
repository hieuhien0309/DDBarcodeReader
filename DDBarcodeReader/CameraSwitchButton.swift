//
//  CameraSwitchButton.swift
//  DDBarcodeReader
//
//  Created by Chi Hieu on 9/16/15.
//  Copyright (c) 2015 Dream Digits. All rights reserved.
//

import UIKit

class CameraSwitchButton: UIButton {

    var edgeColor:UIColor!
    var fillColor:UIColor!
    var edgeHighlightedColor:UIColor!
    var fillHighlightedColor:UIColor!

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.edgeColor            = UIColor.whiteColor()
        self.fillColor            = UIColor.darkGrayColor()
        self.edgeHighlightedColor = UIColor.whiteColor()
        self.fillHighlightedColor = UIColor.blackColor()
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        
        let width:CGFloat  = rect.size.width;
        let height:CGFloat = rect.size.height;
        let center:CGFloat = width / 2;
        let middle:CGFloat = height / 2;
        
        let strokeLineWidth:CGFloat = 2;
        

        var paintColor:UIColor  = (self.state != UIControlState.Highlighted) ? self.fillColor : self.fillHighlightedColor
        var strokeColor:UIColor = (self.state != UIControlState.Highlighted) ? self.edgeColor : self.edgeHighlightedColor;
        
        // Camera box
        
        let cameraWidth:CGFloat = width * 0.4;
        let cameraHeight:CGFloat = cameraWidth * 0.6;
        let cameraX:CGFloat      = center - cameraWidth / 2;
        let cameraY:CGFloat      = middle - cameraHeight / 2;
        let cameraRadius:CGFloat = cameraWidth / 80;
        
        let boxPath:UIBezierPath = UIBezierPath(roundedRect: CGRectMake(cameraX, cameraY, cameraWidth, cameraHeight), cornerRadius:cameraRadius)
        
        // Camera lens
        
        let outerLensSize:CGFloat = cameraHeight * 0.8;
        let outerLensX:CGFloat    = center - outerLensSize / 2;
        let outerLensY:CGFloat    = middle - outerLensSize / 2;
        
        let innerLensSize:CGFloat = outerLensSize * 0.7;
        let innerLensX:CGFloat    = center - innerLensSize / 2;
        let innerLensY:CGFloat    = middle - innerLensSize / 2;
        
        let outerLensPath:UIBezierPath = UIBezierPath(rect: CGRectMake(outerLensX, outerLensY, outerLensSize, outerLensSize))
        
        let innerLensPath:UIBezierPath = UIBezierPath(ovalInRect: CGRectMake(innerLensX, innerLensY, innerLensSize, innerLensSize))
        
        // Draw flash box
        
        let flashBoxWidth:CGFloat      = cameraWidth * 0.8;
        let flashBoxHeight:CGFloat     = cameraHeight * 0.17;
        let flashBoxDeltaWidth:CGFloat = flashBoxWidth * 0.14;
        let flashLeftMostX:CGFloat     = cameraX + (cameraWidth - flashBoxWidth) * 0.5;
        let flashBottomMostY:CGFloat   = cameraY;
        
        let flashPath:UIBezierPath = UIBezierPath().bezierPathByReversingPath()//[UIBezierPath bezierPath];
        flashPath.moveToPoint(CGPointMake(flashLeftMostX, flashBottomMostY))
        flashPath.addLineToPoint(CGPointMake(flashLeftMostX + flashBoxWidth, flashBottomMostY))
        flashPath.addLineToPoint(CGPointMake(flashLeftMostX + flashBoxWidth - flashBoxDeltaWidth, flashBottomMostY - flashBoxHeight))
        flashPath.addLineToPoint(CGPointMake(flashLeftMostX + flashBoxDeltaWidth, flashBottomMostY - flashBoxHeight))
        flashPath.closePath()

        flashPath.lineCapStyle = kCGLineCapRound;
        flashPath.lineJoinStyle = kCGLineJoinRound;
        
        // Arrows
        
        let arrowHeadHeigth:CGFloat = cameraHeight * 0.5;
        let arrowHeadWidth:CGFloat  = ((width - cameraWidth) / 2) * 0.3;
        let arrowTailHeigth:CGFloat = arrowHeadHeigth * 0.6;
        let arrowTailWidth:CGFloat  = ((width - cameraWidth) / 2) * 0.7;
        
        // Draw left arrow
        
        let arrowLeftX:CGFloat = center - cameraWidth * 0.2;
        let arrowLeftY:CGFloat = middle + cameraHeight * 0.45;
        
        let leftArrowPath:UIBezierPath =  UIBezierPath().bezierPathByReversingPath()// [UIBezierPath bezierPath];
        
        leftArrowPath.moveToPoint(CGPointMake(arrowLeftX, arrowLeftY))
    
        leftArrowPath.addLineToPoint(CGPointMake(arrowLeftX - arrowHeadWidth, arrowLeftY - arrowHeadHeigth / 2))
        
        leftArrowPath.addLineToPoint(CGPointMake(arrowLeftX - arrowHeadWidth, arrowLeftY - arrowTailHeigth / 2))
        
        leftArrowPath.addLineToPoint(CGPointMake(arrowLeftX - arrowHeadWidth - arrowTailWidth, arrowLeftY - arrowTailHeigth / 2))
        leftArrowPath.addLineToPoint(CGPointMake(arrowLeftX - arrowHeadWidth - arrowTailWidth, arrowLeftY + arrowTailHeigth / 2))
        leftArrowPath.addLineToPoint(CGPointMake(arrowLeftX - arrowHeadWidth, arrowLeftY + arrowTailHeigth / 2))
        leftArrowPath.addLineToPoint(CGPointMake(arrowLeftX - arrowHeadWidth, arrowLeftY + arrowHeadHeigth / 2))
        leftArrowPath.closePath()
        
        // Right arrow

        let arrowRightX:CGFloat = center + cameraWidth * 0.2;
        let arrowRightY:CGFloat = middle + cameraHeight * 0.60;
        
        let rigthArrowPath = UIBezierPath().bezierPathByReversingPath()// [UIBezierPath bezierPath];
        rigthArrowPath.moveToPoint(CGPointMake(arrowRightX, arrowRightY))
        rigthArrowPath.addLineToPoint(CGPointMake(arrowRightX + arrowHeadWidth, arrowRightY - arrowHeadHeigth / 2))
        rigthArrowPath.addLineToPoint(CGPointMake(arrowRightX + arrowHeadWidth, arrowRightY - arrowTailHeigth / 2))
        rigthArrowPath.addLineToPoint(CGPointMake(arrowRightX + arrowHeadWidth + arrowTailWidth, arrowRightY - arrowTailHeigth / 2))
        rigthArrowPath.addLineToPoint(CGPointMake(arrowRightX + arrowHeadWidth + arrowTailWidth, arrowRightY + arrowTailHeigth / 2))
        rigthArrowPath.addLineToPoint(CGPointMake(arrowRightX + arrowHeadWidth, arrowRightY + arrowTailHeigth / 2))
        rigthArrowPath.addLineToPoint(CGPointMake(arrowRightX + arrowHeadWidth, arrowRightY + arrowHeadHeigth / 2))
        rigthArrowPath.closePath()
        
        // Drawing

        paintColor.setFill()
        rigthArrowPath.fill()
        strokeColor.setStroke()
        rigthArrowPath.lineWidth = strokeLineWidth
        rigthArrowPath.stroke()
        
        paintColor.setFill()
        boxPath.fill()
        strokeColor.setStroke()
        boxPath.lineWidth = strokeLineWidth
        boxPath.stroke()
        
        [strokeColor.setFill];
        [outerLensPath.fill];
        
        paintColor.setFill()
        innerLensPath.fill()
        
        paintColor.setFill()
        flashPath.fill()
        strokeColor.setStroke()
        flashPath.lineWidth = strokeLineWidth;
        flashPath.stroke()
        
        paintColor.setFill()
        leftArrowPath.fill()
        strokeColor.setStroke()
        leftArrowPath.lineWidth = strokeLineWidth;
        leftArrowPath.stroke() 
    }
    

}
