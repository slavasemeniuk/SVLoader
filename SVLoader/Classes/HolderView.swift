//
//  HolderView.swift
//  Loader
//
//  Created by Slava Semeniuk on 12/12/16.
//  Copyright © 2016 Slava Semeniuk. All rights reserved.
//

import UIKit

class HolderView: UIView {

    var leftOvalLayer: OvalLayer!
    var rigthOvalLayer: OvalLayer!
    var centralOvalLayer: OvalLayer!
    var checkmarkLayer: CheckmarkLayer!
    var rectLayer: CALayer!
    var shouldAnimate = false
    var label: UILabel!
    
    //MARK: - Init
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.black.withAlphaComponent(0.4)
        addRectLayer()
        addOvalLayers()
        addCheckmarkLayer()
        addViews()
    }
    
    //MARK: - UI
    fileprivate func addOvalLayers() {
        centralOvalLayer = OvalLayer(center: CGPoint(x: bounds.size.width / 2, y: bounds.size.height / 2 + 15))
        leftOvalLayer = OvalLayer(center: CGPoint(x: bounds.size.width / 2 - 20, y: bounds.size.height / 2 + 15))
        rigthOvalLayer = OvalLayer(center: CGPoint(x: bounds.size.width / 2 + 20, y: bounds.size.height / 2 + 15))
        layer.addSublayer(leftOvalLayer)
        layer.addSublayer(centralOvalLayer)
        layer.addSublayer(rigthOvalLayer)
    }
    
    fileprivate func addRectLayer() {
        rectLayer = CALayer()
        rectLayer.backgroundColor = UIColor.black.cgColor
        rectLayer.shadowColor = UIColor.black.cgColor
        rectLayer.shadowOffset = CGSize(width: 1, height: 1)
        rectLayer.shadowOpacity = 0.4
        rectLayer.shadowRadius = 1.0
        let width: CGFloat = 200
        let height: CGFloat = 120
        rectLayer.frame = CGRect(x: (bounds.size.width - width) / 2, y: (bounds.size.height - height) / 2, width: width, height: height)
        rectLayer.cornerRadius = 8
        layer.addSublayer(rectLayer)
    }
    
    fileprivate func addCheckmarkLayer() {
        checkmarkLayer = CheckmarkLayer(center: CGPoint(x: bounds.size.width / 2 + 3, y: bounds.size.height / 2 + 25))
        layer.addSublayer(checkmarkLayer)
    }
    
    fileprivate func addViews() {
        let labelFrame = CGRect(x: rectLayer.frame.origin.x + 10, y: bounds.size.height / 2 - 30, width: rectLayer.frame.size.width - 15, height: 30)
        label = UILabel(frame: labelFrame)
        label.textAlignment = .center
        label.textColor = UIColor.white
        addSubview(label)
    }
    
    @objc fileprivate func changeTextOfLabelWithAnimtion(_ string: String) {
        if !shouldAnimate { return }
        let animation = CATransition()
        animation.timingFunction = CAMediaTimingFunction(name:
            kCAMediaTimingFunctionEaseInEaseOut)
        animation.type = kCATransitionFade
        animation.duration = 0.2
        label.layer.add(animation, forKey: kCATransitionPush)
        label.text = string
    }
    
    func animateDots() {
        if !shouldAnimate { return }
        leftOvalLayer.animationInA(0, period: 1.2)
        centralOvalLayer.animationInA(0.4, period: 1.2)
        rigthOvalLayer.animationInA(0.8, period: 1.2)
    }
    
    //MARK: - Managing
    func showWith(_ message: String) {
        label.text = message
        animateDots()
    }
    
    func showWith(messages: [String], timeInterval: TimeInterval) {
        if messages.count == 0 {
            showWith(SVLoaderSettings.defaultLoadingMessage)
            return
        }
        for (index, message) in messages.enumerated() {
            let _ = Timer.scheduledTimer(timeInterval: timeInterval * Double(index),
                                                   target: self,
                                                   selector: #selector(changeTextTimer(_:)),
                                                   userInfo: message,
                                                   repeats: false)
        }
        animateDots()
    }
    
    func hideWithSuccess(message: String, completion: (() -> Void)?) {
        changeTextOfLabelWithAnimtion(message)
        finishDotsAnimation()
        shouldAnimate = false
        checkmarkLayer.animate()
        let time = DispatchTime.now() + Double(Int64(SVLoaderSettings.timeBeforeDissmiss * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: time) { 
            completion?()
        }
    }
    
    func resetAllLayers() {
        finishDotsAnimation()
        checkmarkLayer.removeAllAnimations()
    }
    
    func finishDotsAnimation() {
        [leftOvalLayer, centralOvalLayer, rigthOvalLayer].forEach({
            $0.removeAllAnimations()
        })
    }
    
    //MARK: - Timers
    @objc fileprivate func changeTextTimer(_ timer: Timer) {
        if !shouldAnimate { return }
        let text = timer.userInfo as! String
        changeTextOfLabelWithAnimtion(text)
    }
}
