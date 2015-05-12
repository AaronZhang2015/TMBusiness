//
//  BaseViewController.swift
//  ThinMeBussiness
//
//  Created by ZhangMing on 15/3/5.
//  Copyright (c) 2015年 ZhangMing. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
//    lazy var hudMaskView: UIView = {
//        var view = UIView(frame: UIScreen.mainScreen().bounds)
//        view.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.2)
//        return view
//        }()
    
    
    lazy var config: SwiftLoader.Config = {
        var c = SwiftLoader.Config()
        c.size = 170
        c.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.6)
        c.spinnerColor = UIColor.whiteColor()
        c.titleTextColor = UIColor(red:0.88, green:0.26, blue:0.18, alpha:1)
        c.spinnerLineWidth = 4.0
        return c
        }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func presentInfoAlertView(message: String) {
        var alertView = UIAlertView(title: "提示", message: message, delegate: nil, cancelButtonTitle: "确定")
        alertView.show()
    }
    
    
    func startActivity() {
        println("startActivity")
//        SwiftLoader.setConfig(config)
//        SwiftLoader.show(animated: false)
        var window = UIApplication.sharedApplication().keyWindow!
        var indicator = WIndicator.showIndicatorAddedTo(window, animation: true)
        indicator.text = "请稍等"

    }
    
    func stopActivity() {
        println("stopActivity")
        var window = UIApplication.sharedApplication().keyWindow!
        WIndicator.removeIndicatorFrom(window, animation: true)
//        SwiftLoader.hide()
//        delay(seconds: 0.0) { () -> () in
//            SwiftLoader.hide()
//        }
    }
    
    func showMessage(message: String, timeout: Double = 1.0) {
        var window = UIApplication.sharedApplication().keyWindow!
        WIndicator.showMsgInView(window, text: message, timeOut: timeout)
    }
    
    
    func delay(#seconds: Double, completion:()->()) {
        let popTime = dispatch_time(DISPATCH_TIME_NOW, Int64( Double(NSEC_PER_SEC) * seconds ))
        
        dispatch_after(popTime, dispatch_get_main_queue()) {
            completion()
        }
    }
    /*
    func startActivity() {
        if hudMaskView.superview == nil {
            view.addSubview(hudMaskView)
        }
        
        view.bringSubviewToFront(hudMaskView)
        
        if activityIndicatorView.superview == nil {
            activityIndicatorView.center = hudMaskView.center
            hudMaskView.addSubview(activityIndicatorView)
        }
        
        hudMaskView.alpha = 0.7
        activityIndicatorView.startActivity()
    }
    */

}
