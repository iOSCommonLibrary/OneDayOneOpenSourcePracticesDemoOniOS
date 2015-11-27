//
//  UIBezierPathExtension.swift
//  MySimpleSmoothScribble
//
//  Created by su xinde on 15/11/16.
//  Copyright © 2015年 com.su. All rights reserved.
//

import Foundation
import UIKit

extension UIBezierPath
{
    func interpolatePointsWithHermite(interpolutationPoints : [CGPoint]) {
        let n = interpolutationPoints.count-1;
        
        for var idx = 0; idx < n; ++idx
        {
            
            var curPoint = interpolutationPoints[idx]
            
            if idx == 0
            {
                self.moveToPoint(interpolutationPoints[0])
            }
            
            var nextIdx = (idx + 1) % interpolutationPoints.count
            var preIdx = (idx - 1 < 0 ? interpolutationPoints.count - 1 : idx - 1)
            var prePoint = interpolutationPoints[preIdx]
            var nextPoint = interpolutationPoints[nextIdx]
            let endPoint = nextPoint
            var x : CGFloat = 0.0
            var y : CGFloat  = 0.0
            
            if idx > 0 {
                x = (nextPoint.x - curPoint.x) * 0.5 + (curPoint.x - prePoint.x) * 0.5;
                
                y = (nextPoint.y - curPoint.y) * 0.5 + (curPoint.y -  prePoint.y) * 0.5;
            } else {
                x = (nextPoint.x - curPoint.x) * 0.5;
                y = (nextPoint.y - curPoint.y) * 0.5;
            }
            
            
            let controlpoint1 = CGPoint(x: curPoint.x + x / 3.0, y: curPoint.y + y / 3.0)

            curPoint = interpolutationPoints[nextIdx]
            nextIdx = (nextIdx + 1) % interpolutationPoints.count
            preIdx = idx;
            prePoint = interpolutationPoints[preIdx]
            nextPoint = interpolutationPoints[nextIdx]
            
            if idx < n - 1 {
                x = (nextPoint.x - curPoint.x) * 0.5 + (curPoint.x - prePoint.x) * 0.5;
                y = (nextPoint.y - curPoint.y) * 0.5 +  (curPoint.y - prePoint.y) * 0.5;
            }
            else {
                x = (curPoint.x - prePoint.x) * 0.5 + (curPoint.y - prePoint.y) * 0.5;
            }
            
            let controlPoint2 = CGPoint(x: curPoint.x - x / 3.0, y: curPoint.y - y / 3.0)
            
            self.addCurveToPoint(endPoint, controlPoint1: controlpoint1, controlPoint2: controlPoint2)
        }
        
    }
}