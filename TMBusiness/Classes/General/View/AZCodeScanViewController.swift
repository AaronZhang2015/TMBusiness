//
//  QRCodeScanViewController.swift
//  TMBusiness
//
//  Created by ZhangMing on 4/20/15.
//  Copyright (c) 2015 南京寻觅信息科技有限公司. All rights reserved.
//

import UIKit
import AVFoundation

/**
*  二维码扫描
*/
class AZCodeScanViewController: UIViewController {
    
    var session: AVCaptureSession!
    var device: AVCaptureDevice!
    var input: AVCaptureDeviceInput!
    var output: AVCaptureMetadataOutput!
    var previewLayer: AVCaptureVideoPreviewLayer!
    
    lazy var maskView: UIView = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()

        session = AVCaptureSession()
        device = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        var error: NSError?
        
        input = AVCaptureDeviceInput.deviceInputWithDevice(device, error: &error) as! AVCaptureDeviceInput
        
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
        
        view.addSubview(maskView)
        
        maskView.layer.addSublayer(previewLayer)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        session.startRunning()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        session.stopRunning()
    }
}

extension AZCodeScanViewController: AVCaptureMetadataOutputObjectsDelegate {
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
