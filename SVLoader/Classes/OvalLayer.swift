//
//  OvalLayer.swift
//  Loader
//
//  Created by Slava Semeniuk on 12/12/16.
//  Copyright © 2016 Slava Semeniuk. All rights reserved.
//

import UIKit

class OvalLayer: CAShapeLayer {
    
    var centralPoint: CGPoint!
    
    var ovalPath: UIBezierPath {
        return UIBezierPath(ovalIn: CGRect(x: centralPoint.x, y: centralPoint.y, width: 8, height: 8))
    }
    
    var expandedOvalPath: UIBezierPath {
        return UIBezierPath(ovalIn: CGRect(x: centralPoint.x - 2, y: centralPoint.y - 2, width: 12, height: 12))
    }
    
    convenience init(center: CGPoint) {
        self.init()
        fillColor = UIColor.white.cgColor
        centralPoint = center
        opacity = 0
        path = ovalPath.cgPath
    }
    
    func animationInA(_ seconds: CFTimeInterval, period: CFTimeInterval) {
        let opacityAnimation = CABasicAnimation(keyPath: "opacity")
        opacityAnimation.fromValue = 0
        opacityAnimation.toValue = 1
        opacityAnimation.isRemovedOnCompletion = false
        opacityAnimation.fillMode = kCAFillModeBoth
        add(opacityAnimation, forKey: "opacity")
        
        let animation = CABasicAnimation(keyPath: "path")
        animation.fromValue = ovalPath.cgPath
        animation.toValue = expandedOvalPath.cgPath
        animation.beginTime = seconds
        animation.duration = 0.2
        animation.autoreverses = true
            
        let animationGroup = CAAnimationGroup()
        animationGroup.animations = [animation]
        animationGroup.beginTime = 0
        animationGroup.duration = period
        animationGroup.fillMode = kCAFillModeForwards
        animationGroup.repeatCount = Float.infinity

        add(animationGroup, forKey: nil)
    }
}
