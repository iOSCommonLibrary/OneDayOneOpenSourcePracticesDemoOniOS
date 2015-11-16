//
//  MyScribblable.swift
//  MySimpleSmoothScribble
//
//  Created by su xinde on 15/11/16.
//  Copyright © 2015年 com.su. All rights reserved.
//

import Foundation
import UIKit

// 接口
protocol MyScribblable
{
    func beginScribble(point : CGPoint)
    func appendScribble(point: CGPoint)
    func endScribble()
    func clearScribble()
}

// 涂鸦父类
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
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        titleLabel.frame = CGRect(x: 0,
            y: frame.height-titleLabel.intrinsicContentSize().height-2,
            width: frame.width,
            height: titleLabel.intrinsicContentSize().height);
    }
}

// 涂鸦视图类
class MySimpleScribbleView : MyScribbleView, MyScribblable {
    
    let simplePath = UIBezierPath();
    
    func beginScribble(point: CGPoint) {
        simplePath.removeAllPoints();
        simplePath.moveToPoint(point)
    }
    
    func appendScribble(point: CGPoint) {
        simplePath.addLineToPoint(point)
        drawingLayer.path = simplePath.CGPath
    }
    
    func endScribble() {
        if let backgroundPath = backgroundLayer.path {
            simplePath.appendPath(UIBezierPath(CGPath: backgroundPath))
        }
        backgroundLayer.path = simplePath.CGPath
        simplePath .removeAllPoints()
        drawingLayer.path = simplePath.CGPath
    }
    
    func clearScribble() {
        backgroundLayer.path = nil
    }
}

// 插入涂鸦视图类
class MyHermiteScribbleView : MyScribbleView, MyScribblable {
    
    let hermitePath = UIBezierPath()
    var interpolationPoints = [CGPoint]()
    
    func beginScribble(point: CGPoint) {
        interpolationPoints = [point]
    }
    
    func appendScribble(point: CGPoint) {
        
        interpolationPoints.append(point)
        
        hermitePath.removeAllPoints()
        hermitePath.interpolatePointsWithHermite(interpolationPoints)
        
        drawingLayer.path = hermitePath.CGPath
    }
    
    func endScribble() {
        if let backgroundPath = backgroundLayer.path {
            hermitePath.appendPath(UIBezierPath(CGPath: backgroundPath))
        }
        backgroundLayer.path = hermitePath.CGPath
        hermitePath.removeAllPoints()
        drawingLayer.path = hermitePath.CGPath
        
    }
    
    func clearScribble() {
        backgroundLayer.path = nil
    }
    
}









