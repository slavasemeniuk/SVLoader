//
//  Loader.swift
//  Loader
//
//  Created by Slava Semeniuk on 12/12/16.
//  Copyright © 2016 Slava Semeniuk. All rights reserved.
//

import UIKit

open class SVLoader: NSObject {
    
    internal static let sharedLoader = SVLoader()
    internal var holderView: HolderView!
    
    open static fileprivate(set) var animating = false {
        didSet {
            sharedLoader.holderView.shouldAnimate = animating
        }
    }
    
    override init() {
        super.init()
        holderView = HolderView(frame: UIScreen.main.bounds)
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidBecomeActive), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
    }
    
    //MARK: - Window
    fileprivate func addHolderView() {
        guard let window = frontWindow() else { return }
        SVLoader.animating = true
        holderView.alpha = 0
        window.addSubview(holderView)
        UIView.animate(withDuration: 0.4, animations: {
            self.holderView!.alpha = 1
        })
    }
    
    fileprivate func hideHolderView(completion: (()->Void)?) {
        UIView.animate(withDuration: 0.4, animations: {
            self.holderView?.alpha = 0
            }, completion: {
                if $0 {
                    SVLoader.animating = false
                    SVLoader.sharedLoader.holderView.resetAllLayers()
                    self.holderView.removeFromSuperview()
                    completion?()
                }
        })
    }
    
    fileprivate func frontWindow() -> UIWindow? {
        for window in UIApplication.shared.windows.reversed() {
            let onMainScreen = window.screen == UIScreen.main
            let windowLevelSupported = window.windowLevel <= UIWindowLevelNormal
            let windowsIsVisible = !window.isHidden && window.alpha > 0
            if onMainScreen && windowsIsVisible && windowLevelSupported {
                return window
            }
        }
        return nil
    }
    
    //MARK: - Appication actions
    
    @objc fileprivate func applicationDidBecomeActive() {
        guard SVLoader.animating else { return }
        holderView.animateDots()
    }
    
    //MARK: - Interface
    open class func showLoaderWith(message: String) {
        if SVLoader.animating { return }
        sharedLoader.addHolderView()
        sharedLoader.holderView.showWith(message)
    }
    
    open class func show() {
        showLoaderWith(message: SVLoaderSettings.defaultLoadingMessage)
    }
    
    open class func showLoaderWith(messages: [String], changeInA seconds: TimeInterval) {
        if SVLoader.animating { return }
        sharedLoader.addHolderView()
        sharedLoader.holderView.showWith(messages: messages, timeInterval: seconds)
    }
    
    open class func hideWithSuccess(message: String? = nil, completion: (() -> Void)? = nil) {
        if !SVLoader.animating {
            completion?()
            return
        }
        var successMessage = ""
        if let text = message {
            successMessage = text
        } else {
            successMessage = SVLoaderSettings.defaultSuccessMessage
        }
        
        sharedLoader.holderView.hideWithSuccess(message: successMessage, completion: {
            sharedLoader.hideHolderView(completion: completion)
        })
    }
    
    open class func hideLoader(_ completion: (() -> Void)? = nil) {
        guard SVLoader.animating else {
            completion?()
            return
        }
        sharedLoader.hideHolderView(completion: completion)
    }
}
