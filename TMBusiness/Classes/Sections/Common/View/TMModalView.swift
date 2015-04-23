//
//  TMModalView.swift
//  TMBusiness
//
//  Created by ZhangMing on 4/23/15.
//  Copyright (c) 2015 南京寻觅信息科技有限公司. All rights reserved.
//

import UIKit

class TMModalView: UIView {

    lazy var maskModalView: UIControl = {
        var view = UIControl(frame: UIApplication.sharedApplication().keyWindow!.bounds)
        view.backgroundColor = UIColor.blackColor()
        view.alpha = 0
        return view
        }()

}
