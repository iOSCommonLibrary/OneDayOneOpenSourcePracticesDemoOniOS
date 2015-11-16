//
//  ViewController.swift
//  MySimpleSmoothScribble
//
//  Created by su xinde on 15/11/16.
//  Copyright © 2015年 com.su. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let stackView = UIStackView()
    
    let hermiteScribbleView = MyHermiteScribbleView(title: "Hermite")
    let simpleScribbleView = MySimpleScribbleView(title: "Simple")
    
    var touchOrigin : MyScribbleView?
    
    func initView() {
        view.addSubview(stackView)
        stackView.addArrangedSubview(hermiteScribbleView)
        stackView.addArrangedSubview(simpleScribbleView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.initView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

// MARK: -
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       guard let
            location = touches.first?.locationInView(self.view) else {
            return
        }
        
        if hermiteScribbleView.frame.contains(location) {
            touchOrigin = hermiteScribbleView
        }else if simpleScribbleView.frame.contains(location) {
            touchOrigin = simpleScribbleView
        }else {
            touchOrigin = nil
            return
        }
        
        if let adjustedLocationInView = touches.first?.locationInView(touchOrigin) {
            hermiteScribbleView.beginScribble(adjustedLocationInView)
            simpleScribbleView.beginScribble(adjustedLocationInView)
        }
        
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        guard let
            touch = touches.first,
            coalescedTouches = event?.coalescedTouchesForTouch(touch),
            touchOrigin = touchOrigin
            else
        {
            return
        }
        
        coalescedTouches.forEach
            {
                hermiteScribbleView.appendScribble($0.locationInView(touchOrigin))
                simpleScribbleView.appendScribble($0.locationInView(touchOrigin))
        }

    }

    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        hermiteScribbleView.endScribble()
        simpleScribbleView.endScribble()
    }
    
    override func motionBegan(motion: UIEventSubtype, withEvent event: UIEvent?) {
        if motion == UIEventSubtype.MotionShake
        {
            hermiteScribbleView.clearScribble()
            simpleScribbleView.clearScribble()
        }
    }
    
    override func viewDidLayoutSubviews() {
        stackView.frame = CGRect(x: 0,
            y: topLayoutGuide.length,
            width: view.frame.width,
            height: view.frame.height - topLayoutGuide.length).insetBy(dx: 10, dy: 10)
        
        stackView.axis = view.frame.width > view.frame.height ?
            UILayoutConstraintAxis.Horizontal : UILayoutConstraintAxis.Vertical
        
        stackView.spacing = 10
        stackView.distribution = UIStackViewDistribution.FillEqually
    }
}

