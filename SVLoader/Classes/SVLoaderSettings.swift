//
//  Settings.swift
//  Pods
//
//  Created by Slava Semeniuk on 12/25/16.
//
//

import UIKit

struct Checkmark {
    static let animationDuration: CFTimeInterval = 0.25
    static let lineWidth: CGFloat = 4
}

open class SVLoaderSettings: NSObject {
    open static var timeBeforeDissmiss: Double = 0.6
    open static var defaultSuccessMessage = ""
    open static var defaultLoadingMessage = "Loading..."
    open static var font: UIFont? {
        didSet {
            SVLoader.sharedLoader.holderView.label.font = font
        }
    }
}
