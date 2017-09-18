//
//  Circle.swift
//  CircleAnimation
//
//  Created by franze on 2017/9/17.
//  Copyright © 2017年 franze. All rights reserved.
//

import UIKit

class Circle: UIView {
    private var back_Circle:CAShapeLayer!
    private var static_Circle:CAShapeLayer!
    private var floating_Circle:UIView!
    
    private var link:CADisplayLink!
    private var A:CGPoint!
    private var B:CGPoint!
    private var C:CGPoint!
    private var D:CGPoint!
    private var O:CGPoint!
    private var P:CGPoint!
    private var c2:CGPoint!
    private var c1:CGPoint!
    private var R:CGFloat!
    private var open:Bool = true
    private var color:UIColor!
    
    override init(frame: CGRect) {
        super.init(frame:frame)
    }
    
    func initialize(color:UIColor){
        self.color = color
        c1 = CGPoint(x: bounds.width/2, y: bounds.height/2)

        link = CADisplayLink(target: self, selector: #selector(updatePath))
        link.add(to: .current, forMode: .commonModes)
        link.isPaused = true
        
        floating_Circle = UIView(frame: CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height))
        floating_Circle.backgroundColor = color
        floating_Circle.center = CGPoint(x: bounds.width/2, y: bounds.width/2)
        floating_Circle.layer.cornerRadius = bounds.width/2
        addSubview(floating_Circle)
        
        back_Circle = CAShapeLayer()
        back_Circle.fillColor = color.cgColor
        layer.addSublayer(back_Circle)
        
        static_Circle = CAShapeLayer()
        static_Circle.fillColor = color.cgColor
        layer.addSublayer(static_Circle)
        
        back_Circle.actions = ["fillColor":NSNull()]
        static_Circle.actions = ["fillColor":NSNull()]
        
        floating_Circle.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(Pan)))
    }
    
    @objc private func Pan(gesture:UIPanGestureRecognizer){
        c2 = gesture.location(in: self)
        
        let x1 = CGFloat(c1.x)
        let x2 = CGFloat(c2.x)
        let y1 = CGFloat(c1.y)
        let y2 = CGFloat(c2.y)
        let dx = (x2-x1)*(x2-x1)
        let dy = (y2-y1)*(y2-y1)
        let d = sqrt(dx+dy)
        let r2 = floating_Circle.bounds.width/2
        let r1 = floating_Circle.bounds.width/2-d/15
        let sin = (y2-y1)/d
        let cos = (x2-x1)/d
        A = CGPoint(x: x1+r1*sin, y: y1-r1*cos)
        B = CGPoint(x: x1-r1*sin, y: y1+r1*cos)
        C = CGPoint(x: x2-r2*sin, y: y2+r2*cos)
        D = CGPoint(x: x2+r2*sin, y: y2-r2*cos)
        let dP = CGPoint(x: (C.x+B.x)/2, y: (C.y+B.y)/2)
        let dO = CGPoint(x: (D.x+A.x)/2, y: (A.y+D.y)/2)
        let a:CGFloat = r2/3
        P = CGPoint(x: dP.x+a*sin, y: dP.y-a*cos)
        O = CGPoint(x: dO.x-a*sin, y: dO.y+a*cos)
        R = r1
        
        if gesture.state == .ended{
            open = true
            link.isPaused = true
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0, options: [], animations: {
                self.floating_Circle.center = self.c1
            }, completion: { _ in
                self.static_Circle.fillColor = self.color.cgColor
                self.back_Circle.fillColor = self.color.cgColor
            })
            layerReset(radius: r2)
        }
        else if d > 140{
            open = false
            layerReset(radius: r2)
        }
        else{
            link.isPaused = false
        }
    }
    
    @objc private func updatePath(){
        floating_Circle.center = c2
        if open{
            back_Circle.path = getPath()
            let path = UIBezierPath(arcCenter: c1, radius: R, startAngle: 0, endAngle: CGFloat.pi*360, clockwise: true)
            static_Circle.path = path.cgPath
        }
    }
    
    private func layerReset(radius:CGFloat){
        static_Circle.fillColor = UIColor.clear.cgColor
        back_Circle.fillColor = UIColor.clear.cgColor
        
        let path = UIBezierPath(arcCenter: floating_Circle.center, radius: radius, startAngle: 0, endAngle: CGFloat.pi/180*360, clockwise: true)
        static_Circle.path = path.cgPath
        back_Circle.path = path.cgPath
    }
    
    private func getPath()->CGPath{
        let path = UIBezierPath()
        path.move(to: A)
        path.addQuadCurve(to: D, controlPoint: O)
        path.addLine(to: C)
        path.addQuadCurve(to: B, controlPoint: P)
        path.close()
        return path.cgPath
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
