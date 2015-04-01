//
//  TMLoginViewController.swift
//  TMBusiness
//
//  Created by ZhangMing on 15/4/2.
//  Copyright (c) 2015年 南京寻觅信息科技有限公司. All rights reserved.
//

import UIKit

class TMLoginViewController: BaseViewController {
    
    private var loginView: TMLoginView!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hex: 0xF4F4F4)
        loginView = TMLoginView(frame: CGRectMake(293, 250, 440, 352))
        view.addSubview(loginView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
