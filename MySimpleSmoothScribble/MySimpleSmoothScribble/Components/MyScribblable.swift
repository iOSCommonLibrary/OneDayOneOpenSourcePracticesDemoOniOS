//
//  MyScribblable.swift
//  MySimpleSmoothScribble
//
//  Created by zj－db0367 on 15/11/16.
//  Copyright © 2015年 com.su. All rights reserved.
//

import Foundation
import UIKit

protocol MyScribblable
{
    func beginScribble(point : CGPoint)
    func appendScribble(point: CGPoint)
    func endScribble()
    func clearScribble()
}

class MyScribbleView : UIView {
    
    let backgroundLayer = CAShapeLayer();
    let drawingLayer = CAShapeLayer();
    
    let titleLabel = UILabel()
    
    required init(title : String) {
        super.init(frame : CGRectZero)
        
        backgroundLayer.strokeColor = UIColor.darkGrayColor().CGColor;
        backgroundLayer.fillColor = nil
        backgroundLayer.lineWidth = 2
        
        drawingLayer.strokeColor = UIColor.blackColor().CGColor
        drawingLayer.fillColor = nil
        drawingLayer.lineWidth = 2
        
        layer.addSublayer(backgroundLayer)
        layer.addSublayer(drawingLayer)
        
        titleLabel.text = title
        titleLabel.textAlignment = NSTextAlignment.Center
        titleLabel.textColor = UIColor.blueColor()
        addSubview(titleLabel)
        
        layer.borderColor = UIColor.blueColor().CGColor
        layer.borderWidth = 1
        
        layer.masksToBounds = true
 
    }
    
};










