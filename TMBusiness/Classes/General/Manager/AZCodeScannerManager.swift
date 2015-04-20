//
//  AZCodeScannerManager.swift
//  TMBusiness
//
//  Created by ZhangMing on 15/4/20.
//  Copyright (c) 2015年 南京寻觅信息科技有限公司. All rights reserved.
//

import UIKit
import AVFoundation

public class AZCodeScannerManager: NSObject {
    var previewLayer: AVCaptureVideoPreviewLayer!
    
    override init() {
        super.init()
        
        var session = AVCaptureSession()
        var device = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        var error: NSError?
        
        var input = AVCaptureDeviceInput.deviceInputWithDevice(device, error: &error) as! AVCaptureDeviceInput
        
        if let e = error {
            println("error = \(error)")
        } else {
            session.addInput(input)
        }
        
        var output = AVCaptureMetadataOutput()
        session.addOutput(output)
        
        output.metadataObjectTypes = [AVMetadataObjectTypeQRCode]
        output.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
        
        previewLayer = AVCaptureVideoPreviewLayer.layerWithSession(session) as! AVCaptureVideoPreviewLayer
        previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
    }
    
    public class var sharedInstance: AZCodeScannerManager {
        struct Singleton {
            static let instance = AZCodeScannerManager()
        }
        return Singleton.instance
    }
}

extension AZCodeScannerManager: AVCaptureMetadataOutputObjectsDelegate {
    public func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        for metadata in metadataObjects {
            var metadata = metadata as! AVMetadataObject
            if metadata.type == AVMetadataObjectTypeQRCode {
                var transformed = previewLayer.transformedMetadataObjectForMetadataObject(metadata) as! AVMetadataMachineReadableCodeObject
            }
        }
    }
}

