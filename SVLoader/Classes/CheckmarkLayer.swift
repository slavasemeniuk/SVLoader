//
//  CheckmarkLayer.swift
//  Pods
//
//  Created by Slava Semeniuk on 12/24/16.
//
//

import UIKit

class CheckmarkLayer: CAShapeLayer {

    fileprivate var centralPoint: CGPoint!
    
    fileprivate var checkmarkPath: UIBezierPath {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: centralPoint.x - 5.25, y: centralPoint.y - 5.13))
        path.addLine(to: centralPoint)
        path.addLine(to: CGPoint(x: centralPoint.x + 12.93, y: centralPoint.y - 13.72))
        path.lineCapStyle = .round
        return path
    }
    
    convenience init(center: CGPoint) {
        self.init()
        strokeColor = UIColor.white.cgColor
        opacity = 0
        lineWidth = Checkmark.lineWidth
        centralPoint = center
        path = checkmarkPath.cgPath
    }
    
    func animate() {
        let checkmarkAnimation = CABasicAnimation(keyPath: "strokeEnd")
        checkmarkAnimation.duration = Checkmark.animationDuration
        checkmarkAnimation.isRemovedOnCompletion = false
        checkmarkAnimation.fillMode = kCAFillModeBoth
        checkmarkAnimation.fromValue = 0
        checkmarkAnimation.toValue = 1
        
        let opacityAnimation = CABasicAnimation(keyPath: "opacity")
        opacityAnimation.duration = Checkmark.animationDuration
        opacityAnimation.isRemovedOnCompletion = false
        opacityAnimation.fillMode = kCAFillModeBoth
        opacityAnimation.fromValue = 0
        opacityAnimation.toValue = 1
        
        let animationGroup = CAAnimationGroup()
        animationGroup.animations = [checkmarkAnimation, opacityAnimation]
        animationGroup.duration = Checkmark.animationDuration
        animationGroup.fillMode = kCAFillModeBoth
        animationGroup.isRemovedOnCompletion = false
        add(animationGroup, forKey: nil)
    }
}
