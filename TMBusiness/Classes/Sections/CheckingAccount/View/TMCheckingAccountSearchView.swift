//
//  TMCheckingAccountSearchView.swift
//  TMBusiness
//
//  Created by ZhangMing on 4/27/15.
//  Copyright (c) 2015 南京寻觅信息科技有限公司. All rights reserved.
//

import UIKit
import Snap

class TMCheckingAccountSearchView: TMModalView {
    
    var searchButton: UIButton!
    var printButton: UIButton!
    
    var popoverVC: UIPopoverController!
    var isStartDate: Bool = true
    
    lazy var datePickerView: UIDatePicker = {
        var pickerView = UIDatePicker()
        pickerView.datePickerMode = UIDatePickerMode.Date
        pickerView.addTarget(self, action: "dateChanged:", forControlEvents: .ValueChanged)
        return pickerView
        }()
    
    lazy var popoverView: UIView = {
        var view = UIView(frame: CGRectMake(0, 0, 320, 216))
        
        return view
        }()
    
    
    var startDateButton: UIButton!
    
    var endDateButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(hex: 0xF5F5F5)
        
        var startDateLabel = UILabel()
        startDateLabel.text = "起始时间"
        startDateLabel.font = UIFont.systemFontOfSize(20.0)
        startDateLabel.textColor = UIColor(hex: 0x222222)
        addSubview(startDateLabel)
        startDateLabel.snp_makeConstraints { (make) -> Void in
            make.leading.equalTo(100)
            make.centerY.equalTo(snp_centerY)
            make.width.equalTo(80)
        }
        
        startDateButton = UIButton.buttonWithType(.Custom) as! UIButton
        startDateButton.setBackgroundImage(UIImage(named: "checking_account_input"), forState: .Normal)
        addSubview(startDateButton)
        startDateButton.setTitleColor(UIColor(hex: 0x222222), forState: .Normal)
        startDateButton.addTarget(self, action: "handleDatePickerAction:", forControlEvents: .TouchUpInside)
        startDateButton.snp_makeConstraints { (make) -> Void in
            make.size.equalTo(CGSizeMake(225, 50))
            make.leading.equalTo(startDateLabel.snp_trailing).offset(17)
            make.top.equalTo(20.0)
        }
        
        var endDateLabel = UILabel()
        endDateLabel.text = "结束时间"
        endDateLabel.font = UIFont.systemFontOfSize(20.0)
        endDateLabel.textColor = UIColor(hex: 0x222222)
        addSubview(endDateLabel)
        endDateLabel.snp_makeConstraints { (make) -> Void in
            make.leading.equalTo(startDateButton.snp_trailing).offset(38)
            make.centerY.equalTo(snp_centerY)
            make.width.equalTo(80)
        }
        
        endDateButton = UIButton.buttonWithType(.Custom) as! UIButton
        endDateButton.setTitleColor(UIColor(hex: 0x222222), forState: .Normal)
        endDateButton.setBackgroundImage(UIImage(named: "checking_account_input"), forState: .Normal)
        addSubview(endDateButton)
        endDateButton.addTarget(self, action: "handleDatePickerAction:", forControlEvents: .TouchUpInside)
        endDateButton.snp_makeConstraints { (make) -> Void in
            make.size.equalTo(CGSizeMake(225, 50))
            make.leading.equalTo(endDateLabel.snp_trailing).offset(17)
            make.top.equalTo(20.0)
        }
        
        searchButton = UIButton.buttonWithType(.Custom) as! UIButton
        searchButton.setBackgroundImage(UIImage(named: "checking_account_search"), forState: .Normal)
        searchButton.setBackgroundImage(UIImage(named: "checking_account_search_on"), forState: .Highlighted)
        searchButton.setTitle("搜索", forState: .Normal)
        searchButton.setTitleColor(UIColor(hex: 0x1E8EBC), forState: .Normal)
        searchButton.setTitleColor(UIColor.whiteColor(), forState: .Highlighted)
        addSubview(searchButton)
        searchButton.snp_makeConstraints { (make) -> Void in
            make.leading.equalTo(endDateButton.snp_trailing).offset(25)
            make.size.equalTo(CGSizeMake(88, 40))
            make.centerY.equalTo(snp_centerY)
        }
        
        printButton = UIButton.buttonWithType(.Custom) as! UIButton
        printButton.setBackgroundImage(UIImage(named: "checking_account_search"), forState: .Normal)
        printButton.setBackgroundImage(UIImage(named: "checking_account_search_on"), forState: .Highlighted)
        printButton.setTitle("打印", forState: .Normal)
        printButton.setTitleColor(UIColor(hex: 0x1E8EBC), forState: .Normal)
        printButton.setTitleColor(UIColor.whiteColor(), forState: .Highlighted)
        addSubview(printButton)
        printButton.snp_makeConstraints { (make) -> Void in
            make.leading.equalTo(searchButton.snp_trailing).offset(25)
            make.size.equalTo(CGSizeMake(88, 40))
            make.centerY.equalTo(snp_centerY)
        }
        
        // 设置datePickerView
        var contentVC = UIViewController()
        popoverView.addSubview(datePickerView)
        contentVC.view = popoverView
        contentVC.preferredContentSize = CGSizeMake(320, 216)
        popoverVC = UIPopoverController(contentViewController: contentVC)
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func handleDatePickerAction(sender: UIButton) {

        if sender == startDateButton {
            isStartDate = true
            
            if let title = startDateButton.titleLabel?.text {
                datePickerView.date = NSDate(fromString: title, format: .Custom("yyyy-MM-dd"))
            } else {
                startDateButton.setTitle(NSDate().toString(format: .Custom("yyyy-MM-dd")), forState: .Normal)
            }
            
            if let title = endDateButton.titleLabel!.text {
                var endDate = NSDate(fromString: title, format: .Custom("yyyy-MM-dd"))
                
                datePickerView.maximumDate = endDate
                datePickerView.minimumDate = nil
            }
            
        } else {
            isStartDate = false
            
            if let title = endDateButton.titleLabel?.text {
                datePickerView.date = NSDate(fromString: title, format: .Custom("yyyy-MM-dd"))
            } else {
                endDateButton.setTitle(NSDate().toString(format: .Custom("yyyy-MM-dd")), forState: .Normal)
            }
            
            if let title = startDateButton.titleLabel!.text {
                var startDate = NSDate(fromString: title, format: .Custom("yyyy-MM-dd"))
                
                datePickerView.minimumDate = startDate
                datePickerView.maximumDate = nil
                var date = NSDate()
                endDateButton.setTitle(date.toString(format: .Custom("yyyy-MM-dd")), forState: .Normal)
                datePickerView.date = date
            }
        }
        
        popoverVC.presentPopoverFromRect(CGRectMake(40, 50, 10, 10), inView: sender, permittedArrowDirections: .Any, animated: true)
    }
    
    func dateChanged(sender: UIDatePicker) {
        var date = sender.date
        if isStartDate {
            startDateButton.setTitle(date.toString(format: .Custom("yyyy-MM-dd")), forState: .Normal)
        } else {
            endDateButton.setTitle(date.toString(format: .Custom("yyyy-MM-dd")), forState: .Normal)
        }
    }
}
