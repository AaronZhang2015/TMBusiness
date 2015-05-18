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
//        if let window = UIApplication.sharedApplication().keyWindow {
//            WIndicator.removeIndicatorFrom(window, animation: false)
//            var indicator = WIndicator.showIndicatorAddedTo(window, animation: false)
//            indicator.text = "请稍等"
//        } else {
//            WIndicator.removeIndicatorFrom(self.view, animation: false)
//            var indicator = WIndicator.showIndicatorAddedTo(self.view, animation: false)
//            indicator.text = "请稍等"
//        }
        
//        SVProgressHUD.showWithStatus("请稍等")
        SVProgressHUD.setBackgroundColor(UIColor.blackColor().colorWithAlphaComponent(0.6))
        SVProgressHUD.setForegroundColor(UIColor.whiteColor())
        SVProgressHUD.showWithMaskType(SVProgressHUDMaskType.Gradient)
    }
    
    func stopActivity() {
        SVProgressHUD.dismiss()
    }
    
    func showMessage(message: String, timeout: Double = 1.0) {
        SVProgressHUD.showErrorWithStatus(message)
        delay(seconds: timeout) { () -> () in
            SVProgressHUD.dismiss()
        }
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
