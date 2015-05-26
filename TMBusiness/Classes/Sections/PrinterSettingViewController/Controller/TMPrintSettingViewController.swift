//
//  TMPrintSettingViewController.swift
//  TMBusiness
//
//  Created by ZhangMing on 5/19/15.
//  Copyright (c) 2015 南京寻觅信息科技有限公司. All rights reserved.
//

import UIKit
import Snap

class TMPrintSettingViewController: UITableViewController {
    
    lazy var switchOn = UISwitch()
    lazy var textField = UITextField()
    var phoneNumber: String = ""
    var printStatus: Bool = false
    
    lazy var detaiViewController: TMPrintDetailSettingViewController = TMPrintDetailSettingViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "reuseIdentifier")
        tableView.tableFooterView = UIView()
        
        var phoneNumberKey = "\(TMShop.sharedInstance.shop_id)_PhoneNumber"
        var printStatusKey = "\(TMShop.sharedInstance.shop_id)_PrintStatus"
        if let value = NSUserDefaults.standardUserDefaults().valueForKey(phoneNumberKey) as? String {
            phoneNumber = value
        }
        
        printStatus = NSUserDefaults.standardUserDefaults().boolForKey(printStatusKey)
        tableView.reloadData()
        
        var temporaryBarButtonItem = UIBarButtonItem()
        temporaryBarButtonItem.title = "";
        navigationItem.backBarButtonItem = temporaryBarButtonItem;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func handlePrintStatus(switchOn: UISwitch) {
        printStatus = switchOn.on
        var printStatusKey = "\(TMShop.sharedInstance.shop_id)_PrintStatus"
        NSUserDefaults.standardUserDefaults().setBool(printStatus, forKey: printStatusKey)
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier") as? UITableViewCell

        if cell == nil {
            cell = UITableViewCell(style: .Value1, reuseIdentifier: "reuseIdentifier")
        }
        
        if indexPath.row == 0 {
            cell!.textLabel!.text = "是否开启打印机功能"
            cell?.accessoryType = UITableViewCellAccessoryType.None
            cell?.selectionStyle = .None
            switchOn.addTarget(self, action: "handlePrintStatus:", forControlEvents: .ValueChanged)
            switchOn.on = printStatus
            cell?.contentView.addSubview(switchOn)
            switchOn.frame = CGRectMake(cell!.width , (cell!.height - 31) / 2, 51, 31)
        } else if indexPath.row == 1 {
            cell!.textLabel!.text = "打印机设置"
            cell?.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        } else if indexPath.row == 2 {
            cell!.textLabel!.text = "请输入小票打印的电话联系方式"
            cell?.accessoryType = UITableViewCellAccessoryType.None
            cell?.selectionStyle = .None
        } else if indexPath.row == 3 {
            textField.text = phoneNumber
            textField.keyboardType = UIKeyboardType.NumberPad
            textField.frame = CGRectMake(20, 7, cell!.width, 30)
            textField.borderStyle = UITextBorderStyle.RoundedRect
            textField.delegate = self
            cell?.contentView.addSubview(textField)
            cell?.selectionStyle = .None
        }

        return cell!
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if indexPath.row == 1 {
            navigationController?.pushViewController(detaiViewController, animated: true)
        }
    }
    
}

extension TMPrintSettingViewController: UITextFieldDelegate {
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        phoneNumber = textField.text
        var phoneNumberKey = "\(TMShop.sharedInstance.shop_id)_PhoneNumber"
        NSUserDefaults.standardUserDefaults().setValue(textField.text, forKey: phoneNumberKey)
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        phoneNumber = textField.text
        var phoneNumberKey = "\(TMShop.sharedInstance.shop_id)_PhoneNumber"
        NSUserDefaults.standardUserDefaults().setValue(textField.text, forKey: phoneNumberKey)
        return true
    }
}
