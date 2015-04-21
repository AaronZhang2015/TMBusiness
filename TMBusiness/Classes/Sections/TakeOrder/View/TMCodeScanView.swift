//
//  TMCodeScanView.swift
//  TMBusiness
//
//  Created by ZhangMing on 4/20/15.
//  Copyright (c) 2015 南京寻觅信息科技有限公司. All rights reserved.
//

import UIKit
import Snap
import AVFoundation

class TMCodeScanView: UIView {

    var backButton: UIButton!
    var leftPanelImageView: UIImageView!
    var panelImageView: UIImageView!
    
    var session: AVCaptureSession!
    var device: AVCaptureDevice!
    var input: AVCaptureDeviceInput!
    var output: AVCaptureMetadataOutput!
    var previewLayer: AVCaptureVideoPreviewLayer!
    
    var presentView: UIView!
    var overlayView: UIImageView!
    var titleLabel: UILabel!
    
    var inputButton: UIButton!
    
    var isDraging: Bool = false
    var backClosure: (() -> ())?
    var inputClosure: (() -> ())?
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor(hex: 0xFCFCFC)
        
        session = AVCaptureSession()
        device = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        var error: NSError?
        
        var input = AVCaptureDeviceInput.deviceInputWithDevice(device, error: &error) as! AVCaptureDeviceInput!
        
        if input == nil {
            return
        }
        
        if let e = error {
            println("error = \(error)")
        } else {
            session.addInput(input)
        }
        
        var output = AVCaptureMetadataOutput()
        session.addOutput(output)
        
        output.metadataObjectTypes = [AVMetadataObjectTypeQRCode]
        output.rectOfInterest = CGRectMake(128.0 / width, 121.0 / height, 302, 302)
        output.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
        
        previewLayer = AVCaptureVideoPreviewLayer.layerWithSession(session) as! AVCaptureVideoPreviewLayer
        previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        previewLayer.connection.videoOrientation = AVCaptureVideoOrientation(rawValue: UIApplication.sharedApplication().statusBarOrientation.rawValue)!
        layer.addSublayer(previewLayer)
        
        overlayView = UIImageView(image: UIImage(named: "scan_overlayview"))
        addSubview(overlayView)
        overlayView.snp_makeConstraints { make in
            make.leading.equalTo(0)
            make.top.equalTo(0)
            make.trailing.equalTo(0)
            make.bottom.equalTo(0)
        }
        
        titleLabel = UILabel()
        titleLabel.textColor = UIColor.whiteColor()
        titleLabel.font = UIFont.systemFontOfSize(19.0)
        titleLabel.textAlignment = .Center
        titleLabel.text = "将取景框对准二维码，即可自动扫描"
        addSubview(titleLabel)
        titleLabel.snp_makeConstraints { make in
            make.top.equalTo(snp_bottom).offset(-217)
            make.leading.equalTo(0)
            make.trailing.equalTo(0)
            make.height.equalTo(19)
        }
        
        leftPanelImageView = UIImageView(image: UIImage(named: "panel"))
        leftPanelImageView.highlightedImage = UIImage(named: "panel_on")
        addSubview(leftPanelImageView)
        leftPanelImageView.snp_makeConstraints { make in
            make.width.equalTo(3)
            make.height.equalTo(self.snp_height)
            make.left.equalTo(0)
            make.top.equalTo(0)
        }
        
        panelImageView = UIImageView(image: UIImage(named: "panel_button"))
        panelImageView.highlightedImage = UIImage(named: "panel_button_on")
        addSubview(panelImageView)
        panelImageView.snp_makeConstraints { make in
            make.width.equalTo(27)
            make.height.equalTo(32)
            make.left.equalTo(self.leftPanelImageView.snp_trailing)
            make.centerY.equalTo(self.leftPanelImageView.snp_centerY)
        }
        
        // 返回按钮
        backButton = UIButton.buttonWithType(.Custom) as! UIButton
        backButton.setTitle("返回", forState: .Normal)
        backButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        backButton.titleEdgeInsets = UIEdgeInsetsMake(0, -100, 0, 0)
        backButton.setImage(UIImage(named: "back"), forState: .Normal)
        backButton.setImage(UIImage(named: "back_on"), forState: .Highlighted)
        backButton.imageEdgeInsets = UIEdgeInsetsMake(0, 50, 0, 0)
        backButton.addTarget(self, action: "handleBackAction", forControlEvents: .TouchUpInside)
        addSubview(backButton)
        backButton.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(12)
            make.left.equalTo(25)
            make.width.equalTo(100)
            make.height.equalTo(35)
        }

        
        inputButton = UIButton.buttonWithType(.Custom) as! UIButton
        inputButton.setBackgroundImage(UIImage(named: "scan_input"), forState: .Normal)
        inputButton.setBackgroundImage(UIImage(named: "scan_input_on"), forState: .Highlighted)
        inputButton.setTitleColor(UIColor(hex: 0x1E8EBC), forState: .Normal)
        inputButton.setTitleColor(UIColor.whiteColor(), forState: .Highlighted)
        inputButton.setTitle("手动输入", forState: .Normal)
        inputButton.addTarget(self, action: "handleInputAction", forControlEvents: .TouchUpInside)
        addSubview(inputButton)
        inputButton.snp_makeConstraints { make in
            make.size.equalTo(CGSizeMake(107, 107))
            make.trailing.equalTo(snp_trailing).offset(-37)
            make.bottom.equalTo(snp_bottom).offset(-28)
        }
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "statusBarOrientationWillChange:", name: UIApplicationDidChangeStatusBarOrientationNotification, object: nil)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        previewLayer.frame = bounds
    }
    
    override func willMoveToSuperview(newSuperview: UIView?) {
        super.willMoveToSuperview(newSuperview)
        
        if let superView = newSuperview {
            session.startRunning()
        } else {
            session.stopRunning()
        }
    }
    
    func statusBarOrientationWillChange(notification: NSNotification) {
        previewLayer.connection.videoOrientation = AVCaptureVideoOrientation(rawValue: UIApplication.sharedApplication().statusBarOrientation.rawValue)!
        // 计算
        output.rectOfInterest = CGRectMake(128.0 / width, 121.0 / height, 302, 302)
    }
    
    /**
    后退按钮事件
    */
    func handleBackAction() {
        if let backClosure = backClosure {
            backClosure()
        }
    }
    
    /**
    手动输入
    */
    func handleInputAction() {
        if let inputClosure = inputClosure {
            inputClosure()
        }
    }
}

extension TMCodeScanView: AVCaptureMetadataOutputObjectsDelegate {
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        for metadata in metadataObjects {
            var metadata = metadata as! AVMetadataObject
            if metadata.type == AVMetadataObjectTypeQRCode {
                var transformed = previewLayer.transformedMetadataObjectForMetadataObject(metadata) as! AVMetadataMachineReadableCodeObject
                
                println(transformed.stringValue)
            }
        }
    }
}
