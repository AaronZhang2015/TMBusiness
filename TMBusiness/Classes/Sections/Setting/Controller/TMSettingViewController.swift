//
//  TMSettingViewController.swift
//  TMBusiness
//
//  Created by ZhangMing on 5/13/15.
//  Copyright (c) 2015 南京寻觅信息科技有限公司. All rights reserved.
//

import UIKit

protocol TMSettingViewControllerDelegate {
    func dismissSettingViewController()
}

class TMSettingViewController: UITableViewController {
    
    var delegate: TMSettingViewControllerDelegate!
    
    var boxPayViewController: BoxPaySettingViewController = BoxPaySettingViewController()
    
    lazy var printViewController: TMPrintSettingViewController = TMPrintSettingViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        var cancelBarButtonItem = UIBarButtonItem(title: "取消", style: UIBarButtonItemStyle.Done, target: self, action: "handleCancelAction")
        cancelBarButtonItem.tintColor = UIColor.whiteColor()
        navigationItem.rightBarButtonItems = [cancelBarButtonItem]
        tableView.rowHeight = 50.0
        tableView.tableFooterView = UIView()
        
        var temporaryBarButtonItem = UIBarButtonItem()
        temporaryBarButtonItem.title = "";
        navigationItem.backBarButtonItem = temporaryBarButtonItem;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func handleCancelAction() {
        delegate.dismissSettingViewController()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("SettingCell") as? UITableViewCell
        
        if cell == nil {
            cell = UITableViewCell(style: .Value1, reuseIdentifier: "SettingCell")
        }
        
        switch indexPath.row {
        case 0:
            cell?.textLabel!.text = "软件说明"
            cell?.detailTextLabel?.text = ""
        case 1:
            cell?.textLabel!.text = "版本"
            cell?.detailTextLabel?.text = "V1.0"
        case 2:
            cell?.textLabel!.text = "盒子支付设置"
            cell?.detailTextLabel?.text = ""
        case 3:
            cell?.textLabel!.text = "商家设置"
            cell?.detailTextLabel?.text = ""
        default:
            break
        }

        return cell!
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        switch indexPath.row {
        case 0:
            println()
        case 1:
            println()
        case 2:
            navigationController?.pushViewController(boxPayViewController, animated: true)
        case 3:
            navigationController?.pushViewController(printViewController, animated: true)
        default:
            break
        }
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
