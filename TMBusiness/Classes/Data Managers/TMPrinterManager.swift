//
//  TMPrinterManager.swift
//  TMBusiness
//
//  Created by ZhangMing on 5/15/15.
//  Copyright (c) 2015 南京寻觅信息科技有限公司. All rights reserved.
//

import UIKit

class TMPrinterManager: NSObject {
    
    lazy var asyncSocket: AsyncSocket = {
        var socket = AsyncSocket(delegate: self)
        return socket
        }()
    
    var failedClosure: (() -> ())?
    
    var ipAddress: String = ""
    
    var retryCount: Int = 3
    
    lazy var command: ESCCommand = ESCCommand()
    
    lazy var cmdUtils: PrinterCmdUtils = PrinterCmdUtils()
    
    class var sharedInstance: TMPrinterManager {
        struct Singleton {
            static let instance = TMPrinterManager()
        }
        return Singleton.instance
    }
    
    func connect(host: String) -> Bool {
        ipAddress = host
        if !asyncSocket.isConnected() {
            asyncSocket.disconnect()
            
            return asyncSocket.connectToHost(host, onPort: 9100, withTimeout: 500, error: nil)
//            return asyncSocket.connectToHost(host, onPort: 9100, error: nil)
        }
        
        return true
    }
    
    func print(order: TMOrder, user: TMUser?, shop: TMShop, immediate: Bool = false) {
        encapsulateOrder(order, user, shop)
        
        if !asyncSocket.isConnected() {
            
            if count(ipAddress) == 0 {
                if let closure = failedClosure {
                    closure()
                }
            }
            
            asyncSocket.disconnect()
            if !connect(ipAddress) {
                return
            }
        } else {
            asyncSocket.writeData(command.content, withTimeout: -1, tag: 0)
        }
        
//        var command = ESCCommand()
//        var cmdUtils = PrinterCmdUtils()
        
    }
    
    func encapsulateOrder(order: TMOrder, _ user: TMUser?, _ shop: TMShop) {
        command.content = NSMutableData()
        // 初始化
        command.addCommand(cmdUtils.printerInit())
        // ------- 设置店铺名称 -------
        // 设置字体大小
        command.addCommand(cmdUtils.setFontSizeWithWidth(1, height: 1, underline: false))
        command.addCommand(cmdUtils.align(PrinterAlignmentCenter))
        command.addText(shop.shop_name)
        command.addCommand(cmdUtils.nextLine(2))
        // ------- 结账单 -------
        // 恢复字体大小
        command.addCommand(cmdUtils.setFontSize(1))
        command.addText("结 账 单")
        command.addCommand(cmdUtils.nextLine(1))
        // ------- 桌号备注 --------
        // 设置成左对齐
        command.addCommand(cmdUtils.align(PrinterAlignmentLeft))
        command.addText("桌号备注：")
        command.addText(order.order_description)
        command.addCommand(cmdUtils.nextLine(1))
        // ------- 单号 --------
        command.addText("单号：")
        command.addText(order.order_index)
        command.addCommand(cmdUtils.nextLine(1))
        // ------- 收银员 --------
        command.addText("收银员：")
        if let admin_name = shop.admin_name where count(admin_name) > 0  {
            command.addText(admin_name)
        } else {
            command.addText("SYSTEM")
        }
        command.addCommand(cmdUtils.nextLine(1))
        // ------- 下单时间 --------
        command.addText("下单时间：")
        
        if let date = order.register_time {
            command.addText(date.toString(format: .Custom("yyyy年MM月dd日 HH:mm")))
        }
        // ------- 下划线 --------
        command.addCommand(cmdUtils.nextLine(1))
        command.addText("--------------------------------")
        command.addCommand(cmdUtils.nextLine(1))
        // ------- 标题抬头 -------
        command.addText("品名            数量  价格  金额")
        command.addCommand(cmdUtils.nextLine(1))
        for var index = 0; index < order.product_records.count; ++index {
            var record = order.product_records[index]
            var productString = handleProductContent(record)
            command.addText(productString)
            command.addCommand(cmdUtils.nextLine(1))
        }
        
        command.addText("--------------------------------")
        command.addCommand(cmdUtils.nextLine(1))
        
        let format = ".2"
        // 消费金额
        command.addText("消费金额：")
        command.addText("\(order.payable_amount.doubleValue.format(format))")
        command.addCommand(cmdUtils.nextLine(1))
        
        
        // 折扣
        let discountFormat = ".1"
        command.addText("折扣：")
        if let discount = order.discount where discount.doubleValue > 0 {
            command.addText("\(discount.doubleValue.format(discountFormat))折")
        } else {
            command.addText("无")
        }
        
        // 应收金额
        command.addText("      ")
        command.addText("应收：")
        
        // 字体高度扩大一倍
        command.addCommand(cmdUtils.setFontSizeWithWidth(0, height: 1, underline: false))
        command.addText("\(order.actual_amount.doubleValue.format(format))")
        command.addCommand(cmdUtils.nextLine(1))
        // 恢复字体大小
        command.addCommand(cmdUtils.setFontSize(1))
        
        
        // 会员
        if let user = user {
            command.addText("会员：")
            command.addText(user.mobile_number)
            
            // 如果是即时打印，则还会有余额显示
            command.addText(" 余额：")
            if let user_account_balance = user.user_account_balance where user_account_balance.count > 0 {
                var balance = user_account_balance[0].amount.doubleValue
                var actualAmount = order.actual_amount.doubleValue
                var remain = balance - actualAmount
                if remain < 0 {
                    command.addText("0.00")
                } else {
                    command.addText("\(remain.format(format))")
                }
                
            } else {
                command.addText("0.00")
            }
            
            command.addCommand(cmdUtils.nextLine(1))
        } else if let user_mobile_number = order.user_mobile_number where count(user_mobile_number) > 0 {
            command.addText("会员：")
            command.addText(user_mobile_number)
            command.addCommand(cmdUtils.nextLine(1))
        }
        
        if order.status == .TransactionDone {
            // 支付方式
            var transactionMode = ""
            switch order.transaction_mode {
            case .Cash:
                transactionMode = "现金支付:"
            case .CashAndBalance:
                transactionMode = "现金及余额支付:"
            case .IBoxPay:
                transactionMode = "刷卡支付:"
            case .Balance:
                transactionMode = "余额支付:"
            case .Other:
                transactionMode = "其他支付:"
            }
            command.addText(transactionMode)
            command.addText("\(order.actual_amount.doubleValue.format(format))")
            command.addCommand(cmdUtils.nextLine(1))
        } else {
            command.addText("支付状态：未支付")
            command.addCommand(cmdUtils.nextLine(1))
        }
        
        // 电话
        var phoneNumberKey = "\(TMShop.sharedInstance.shop_id)_PhoneNumber"
        if let value = NSUserDefaults.standardUserDefaults().valueForKey(phoneNumberKey) as? String {
            command.addText("电话：")
            command.addText(value)
            command.addCommand(cmdUtils.nextLine(1))
        }
        
        
        // 地址
        command.addText("地址：")
        if let address = shop.address {
            command.addText(address)
        }
        command.addCommand(cmdUtils.nextLine(5))
        
//        asyncSocket.writeData(command.content, withTimeout: -1, tag: 0)
    }
    
    func printCheckingAccount(checkingAccount: TMCheckingAccount, shop: TMShop, startDate: NSDate, endDate: NSDate) {
        encapsulateCheckingAccount(checkingAccount, shop, startDate, endDate)
        
        if !asyncSocket.isConnected() {
            if count(ipAddress) == 0 {
                if let closure = failedClosure {
                    closure()
                }
            }
            asyncSocket.disconnect()
            if !connect(ipAddress) {
                return
            }
        } else {
            asyncSocket.writeData(command.content, withTimeout: -1, tag: 0)
        }
    }
    
    func encapsulateCheckingAccount(checkingAccount: TMCheckingAccount, _ shop: TMShop, _ startDate: NSDate, _ endDate: NSDate) {
        command.content = NSMutableData()
        // 初始化
        command.addCommand(cmdUtils.printerInit())
        // ------- 设置店铺名称 -------
        // 设置字体大小
        command.addCommand(cmdUtils.setFontSizeWithWidth(1, height: 1, underline: false))
        command.addCommand(cmdUtils.align(PrinterAlignmentCenter))
        command.addText(shop.shop_name)
        command.addCommand(cmdUtils.nextLine(2))
        // ------- 结账单 -------
        // 恢复字体大小
        command.addCommand(cmdUtils.setFontSize(1))
        command.addText("对 账 单")
        command.addCommand(cmdUtils.nextLine(2))
        
        command.addCommand(cmdUtils.align(PrinterAlignmentLeft))
        // 起始时间
        command.addText("起始时间：")
        command.addText(startDate.toString(format: .Custom("yyyy年MM月dd日 HH:mm")))
        command.addCommand(cmdUtils.nextLine(1))
        command.addText("结算时间：")
        command.addText(endDate.toString(format: .Custom("yyyy年MM月dd日 HH:mm")))
        command.addCommand(cmdUtils.nextLine(1))
        
        let format = ".2"
        //        let discountFormat = ".1"
        // ------- 下划线 --------
        command.addText("--------------------------------")
        command.addCommand(cmdUtils.nextLine(1))
        // 项目，金额
        command.addText("项目      金额")
        command.addCommand(cmdUtils.nextLine(1))
        // 应收
        command.addText("应收：")
        command.addText(checkingAccount.amount.doubleValue.format(format))
        command.addCommand(cmdUtils.nextLine(1))
        // 折扣
        command.addText("折扣：")
        command.addText(checkingAccount.discount_amount.doubleValue.format(format))
        command.addCommand(cmdUtils.nextLine(1))
        // 优惠券
        command.addText("优惠券：")
        command.addText(checkingAccount.coupon_amount.doubleValue.format(format))
        command.addCommand(cmdUtils.nextLine(1))
        // 实收
        command.addText("实收：")
        command.addText(checkingAccount.actual_amount.doubleValue.format(format))
        command.addCommand(cmdUtils.nextLine(1))
        // 会员卡消费
        command.addText("会员卡消费：")
        command.addText(checkingAccount.balance_amount.doubleValue.format(format))
        command.addCommand(cmdUtils.nextLine(1))
        // 刷卡消费
        command.addText("刷卡消费：")
        command.addText(checkingAccount.box_amount.doubleValue.format(format))
        command.addCommand(cmdUtils.nextLine(1))
        // 现金消费
        command.addText("现金消费：")
        command.addText(checkingAccount.cash_amount.doubleValue.format(format))
        command.addCommand(cmdUtils.nextLine(1))
        // 会员卡充值总额
        command.addText("会员卡充值总额：")
        command.addText(checkingAccount.recharge_amount.actual_amount.doubleValue.format(format))
        command.addCommand(cmdUtils.nextLine(1))
        // 刷卡实际充值
        command.addText("刷卡实际充值：")
        command.addText(checkingAccount.recharge_box.actual_amount.doubleValue.format(format))
        command.addCommand(cmdUtils.nextLine(1))
        // 刷卡充值后
        command.addText("刷卡充值后：")
        command.addText(checkingAccount.recharge_box.total_amount.doubleValue.format(format))
        command.addCommand(cmdUtils.nextLine(1))
        // 现金实际充值
        command.addText("现金实际充值：")
        command.addText(checkingAccount.recharge_cash.actual_amount.doubleValue.format(format))
        command.addCommand(cmdUtils.nextLine(1))
        // 现金充值后
        command.addText("现金充值后：")
        command.addText(checkingAccount.recharge_cash.total_amount.doubleValue.format(format))
        command.addCommand(cmdUtils.nextLine(1))
        // 支付宝实际充值
        command.addText("支付宝实际充值：")
        command.addText(checkingAccount.recharge_alipay.actual_amount.doubleValue.format(format))
        command.addCommand(cmdUtils.nextLine(1))
        // 支付宝充值后
        command.addText("支付宝充值后：")
        command.addText(checkingAccount.recharge_alipay.total_amount.doubleValue.format(format))
        command.addCommand(cmdUtils.nextLine(1))
        // 其他实际充值
        command.addText("其他实际充值：")
        command.addText(checkingAccount.recharge_other.actual_amount.doubleValue.format(format))
        command.addCommand(cmdUtils.nextLine(1))
        // 其他充值后
        command.addText("其他充值后：")
        command.addText(checkingAccount.recharge_other.total_amount.doubleValue.format(format))
        command.addCommand(cmdUtils.nextLine(1))
        // ------- 下划线 --------
        command.addText("--------------------------------")
        // 寻觅充值补贴
        command.addText("寻觅充值补贴：")
        command.addText(checkingAccount.subsidy.total.doubleValue.format(format))
        command.addCommand(cmdUtils.nextLine(1))
        // 未结算
        command.addText("未结算：")
        command.addText(checkingAccount.subsidy.unclear.doubleValue.format(format))
        command.addCommand(cmdUtils.nextLine(1))
        // 已结算
        command.addText("已结算：")
        command.addText((checkingAccount.subsidy.total.doubleValue - checkingAccount.subsidy.unclear.doubleValue).format(format))
        command.addCommand(cmdUtils.nextLine(1))
        // ------- 下划线 --------
        command.addText("--------------------------------")
        // 对账
        command.addText("对账：")
        command.addText((checkingAccount.recharge_amount.actual_amount.doubleValue + checkingAccount.cash_amount.doubleValue + checkingAccount.box_amount.doubleValue + checkingAccount.recharge_box.actual_amount.doubleValue).format(format))
        command.addCommand(cmdUtils.nextLine(1))
        // 现金收入合计
        command.addText("现金收入合计：")
        command.addText((checkingAccount.recharge_amount.actual_amount.doubleValue + checkingAccount.cash_amount.doubleValue).format(format))
        command.addCommand(cmdUtils.nextLine(1))
        // 刷卡收入总额
        command.addText("刷卡收入总额：")
        command.addText((checkingAccount.box_amount.doubleValue + checkingAccount.recharge_box.actual_amount.doubleValue).format(format))
        command.addCommand(cmdUtils.nextLine(1))
        // ------- 下划线 --------
        command.addText("--------------------------------")
        // ------- 标题抬头 -------
        command.addText("品名            数量  价格  金额")
        command.addCommand(cmdUtils.nextLine(1))
        command.addText("--------------------------------")
        
        for var index = 0; index < checkingAccount.products.count; ++index {
            var record = checkingAccount.products[index]
            var productString = handleProductContent(record)
            command.addText(productString)
            command.addCommand(cmdUtils.nextLine(1))
        }
        command.addCommand(cmdUtils.nextLine(5))
    }
    
    
    func handleProductContent(product: TMProductRecord) -> String {
        var content = NSMutableString()
        let cfEnc = CFStringEncodings.GB_18030_2000
        let enc = CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(cfEnc.rawValue))
        var productNameLength = product.product_name.lengthOfBytesUsingEncoding(enc)
        // 如果长度<= 16, 那么在字符串后面补充空格
        if productNameLength <= 16 {
            content.appendString(product.product_name)
            // 创建空格字符串
            var paddingString = "".stringByPaddingToLength(16 + 1 - productNameLength, withString: " ", startingAtIndex: 0)
            content.appendString(paddingString)
        } else {
            // 处理长度大于16字节的字符串
            var count: Int = productNameLength / 16
            if (productNameLength % 16) > 0 {
                ++count
            }
            
            var tempString = product.product_name as NSString
            for var index = 0; index < count; ++index {
                var subIndex = findIndex(tempString as String)
                var subString = tempString.substringToIndex(subIndex)
                // 获取截取的字符串
                tempString = tempString.substringFromIndex(subIndex)
                content.appendString(subString)
                var tempLength = subString.lengthOfBytesUsingEncoding(enc)
                
                if index < count - 1 {
                    var paddingString = "".stringByPaddingToLength(32 - tempLength, withString: " ", startingAtIndex: 0)
                    content.appendString(paddingString)
                } else {
                    var paddingString = "".stringByPaddingToLength(16 + 1 - tempLength, withString: " ", startingAtIndex: 0)
                    content.appendString(paddingString)
                }
            }
        }
        
        // 数量
        // startIndex = 18
        var quantity = "\(product.quantity.integerValue)"
        var quantityLength = quantity.lengthOfBytesUsingEncoding(enc)
        if quantityLength <= 16 {
            content.appendString(quantity)
        } else {
            content.appendString((quantity as NSString).substringToIndex(16))
            // 创建空格字符串
            var paddingString = "".stringByPaddingToLength(16 + 1 - productNameLength, withString: " ", startingAtIndex: 0)
            content.appendString(paddingString)
        }
        
        // 价格
        // startIndex = 22
        let format = ".2"
        var price = ""
        if product.price.doubleValue < 10 {
            price = " \(product.price.doubleValue.format(format))"
        } else {
            price = "\(product.price.doubleValue.format(format))"
        }
        var contentLength = content.lengthOfBytesUsingEncoding(enc)
        var remain = contentLength % 32
        if remain > 0 && remain < 32 {
            // 创建空格字符串
            var paddingString = "".stringByPaddingToLength(21 - remain, withString: " ", startingAtIndex: 0)
            content.appendString(paddingString)
        } else {
            // 创建空格字符串
            var paddingString = "".stringByPaddingToLength(32 - remain + 21, withString: " ", startingAtIndex: 0)
            content.appendString(paddingString)
        }
        content.appendString(price)
        content.appendString(" ")
        
        var amount = "\((product.price.doubleValue * product.quantity.doubleValue).format(format))"
        if product.price.doubleValue * product.quantity.doubleValue < 10 {
            content.appendString(" ")
        }
        content.appendString(amount)
        
        return content as String
    }
    
    func findIndex(content: String, length: Int = 16) -> Int {
        
        let cfEnc = CFStringEncodings.GB_18030_2000
        let enc = CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(cfEnc.rawValue))
        if content.lengthOfBytesUsingEncoding(enc) <= 16 {
            return count(content)
        }
        var middle = length / 2
        var tempString  = (content as NSString).substringToIndex(middle)
        var contentLength = tempString.lengthOfBytesUsingEncoding(enc)
        
        while (contentLength < length) {
            middle += 1;
            var tempString  = (content as NSString).substringToIndex(middle)
            contentLength = tempString.lengthOfBytesUsingEncoding(enc)
        }
        
        if contentLength > length {
            --middle
        }
        
        return middle
    }
}


extension TMPrinterManager: AsyncSocketDelegate {
    func onSocket(sock: AsyncSocket!, didConnectToHost host: String!, port: UInt16) {
        println("didConnectToHost")
        asyncSocket.writeData(command.content, withTimeout: -1, tag: 0)
    }
    
    func onSocket(sock: AsyncSocket!, willDisconnectWithError err: NSError!) {
        println("willDisconnectWithError")
        
        if let closure = failedClosure {
            closure()
        }
    }
    
    func onSocketDidDisconnect(sock: AsyncSocket!) {
        println("onSocketDidDisconnect")
    }
    
    func onSocket(sock: AsyncSocket!, didReadData data: NSData!, withTag tag: Int) {
        println("didReadData")
    }
    
    func onSocket(sock: AsyncSocket!, didWriteDataWithTag tag: Int) {
        println("didWriteDataWithTag")
    }
}
