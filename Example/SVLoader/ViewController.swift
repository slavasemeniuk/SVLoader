//
//  ViewController.swift
//  SVLoader
//
//  Created by Slava Semeniuk on 12/12/2016.
//  Copyright (c) 2016 Slava Semeniuk. All rights reserved.
//

import UIKit
import SVLoader

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        SVLoaderSettings.font = UIFont(name: "HelveticaNeue", size: 15)!
        SVLoaderSettings.defaultSuccessMessage = "Complete."
    }
    
    @IBAction func startLoadingoTouched(_ sender: AnyObject) {
        SVLoader.showLoaderWith(messages: ["Prepearing data...", "Loading data...", "Handling response..."], changeInA: 1.5)
        Timer.scheduledTimer(timeInterval: 4.2, target: self, selector: #selector(hideLoader),
                                               userInfo: nil, repeats: false)
    }
    
    @IBAction func startWithSuccess(_ sender: AnyObject) {
        SVLoader.showLoaderWith(message: "Loading")
        Timer.scheduledTimer(timeInterval: 1.2, target: self, selector: #selector(hideWithSuccess),
                                               userInfo: nil, repeats: false)
    }
    
    func hideLoader() {
        SVLoader.hideLoader()
    }
    
    func hideWithSuccess() {
        SVLoader.hideWithSuccess()
    }
    
}

