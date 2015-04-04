//
//  TMTakeOrderViewController.swift
//  TMBusiness
//
//  Created by ZhangMing on 4/2/15.
//  Copyright (c) 2015 南京寻觅信息科技有限公司. All rights reserved.
//

import UIKit
import Snap

let takeOrderListCellReuseIdentifier = "TakeOriderListCell"

class TMTakeOrderViewController: BaseViewController {
    
    private lazy var shopDataManager: TMShopDataManager = {
        return TMShopDataManager()
        }()
    
    private var orderListHeaderView: TMTakeOrderListHeaderView!
    private var tableView: UITableView!
    private var orderDetailView: TMTakeOrderDetailView!
    private var orderPayWayView: TMTakeOrderPayWayView!
    private var productListContainerView: UIView!
    
    var editCell: TMTakeOrderListCell?
    var editIndexPath: NSIndexPath?
    
    // 商品列表
    private var data: [TMCategory] = [TMCategory]()
    
    // 点单列表
    private var orderProductList: [TMProduct] = [TMProduct]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        fetchCategoryList()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func configureView() {
        var bgView = UIView(frame: CGRectMake(8, 10, 444, 556))
        bgView.backgroundColor = UIColor.whiteColor()
        view.addSubview(bgView)
        
        var bgImageView = UIImageView(image: UIImage(named: "xiaopiaobg"))
        bgImageView.frame = CGRectMake(0, 0, 444, 556)
        bgView.addSubview(bgImageView)
        
        var orderContentView = UIView(frame: CGRectMake(5, 34, 434, 365))
        orderContentView.layer.borderWidth = 1
        orderContentView.layer.borderColor = UIColor(hex: 0xD4D4D4).CGColor
        bgView.addSubview(orderContentView)
        
        orderListHeaderView = TMTakeOrderListHeaderView(frame: CGRectMake(0, 0, 434, 31))
        orderContentView.addSubview(orderListHeaderView)
        
        tableView = UITableView(frame: CGRectMake(0, 31, 434, 334))
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 50.0
        tableView.separatorStyle = .None
        orderContentView.addSubview(tableView)
        
        // Register class
        tableView.registerClass(TMTakeOrderListCell.self, forCellReuseIdentifier: takeOrderListCellReuseIdentifier)
        
        orderDetailView = TMTakeOrderDetailView(frame: CGRectMake(0, 399, 444, 157))
        bgView.addSubview(orderDetailView)
        
        orderPayWayView = TMTakeOrderPayWayView(frame: CGRectMake(0, 566, 558, 134))
        view.addSubview(orderPayWayView)
        
        productListContainerView = UIView(frame: CGRectMake(465, 0, 559, view.height - 64))
        view.addSubview(productListContainerView)
    }
    
    // 设置菜单列表
    func configureProductListView() {
        var controllers: [TMProductListViewController] = [TMProductListViewController]()
        
        for var index = 0; index < data.count; ++index {
            var controller = TMProductListViewController()
            controller.delegate = self
            var category = data[index]
            controller.productList = category.products!
            controller.title = category.category_name
            controllers.append(controller)
        }
        
        var containerViewController = AZPagingContainerViewController(controllers: controllers, parentViewController: self)
        
        addChildViewController(containerViewController)
        containerViewController.view.frame = productListContainerView.bounds
        productListContainerView.addSubview(containerViewController.view)
        containerViewController.didMoveToParentViewController(self)
    }
    
    // 加载菜单
    func fetchCategoryList() {
        shopDataManager.fetchEntityProductList(TMShop.sharedInstance.shop_id!, completion: { (list, error) -> Void in
            if let e = error {
                
            } else {
                self.data = list!
                self.configureProductListView()
            }
        })
    }
    
    /**
    更新价格之类的详情
    */
    func updateOrderDetail() {
        var totalPrice: NSNumber = 0.00
        for var index = 0; index < orderProductList.count; ++index {
            var product = orderProductList[index]
            var price = product.official_quotation.doubleValue * product.quantity.doubleValue + totalPrice.doubleValue
            totalPrice = NSNumber(double: price)
        }
        
        // 更新价格
        orderDetailView.consumeAmountLabel.text = NSString(format: "%.2f", totalPrice.doubleValue)
    }
}

extension TMTakeOrderViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        println("didSelectRowAtIndexPath")
        if editCell != nil {
            if editIndexPath != nil {
                if editIndexPath != indexPath {
                    editCell!.editOrderData(false)
                } else {
                    return
                }
            }
        }
        
        let cell = tableView.cellForRowAtIndexPath(indexPath) as TMTakeOrderListCell
        cell.editOrderData(true)
        editIndexPath = indexPath
        editCell = cell
    }
}

extension TMTakeOrderViewController: UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderProductList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(takeOrderListCellReuseIdentifier, forIndexPath: indexPath) as TMTakeOrderListCell
        cell.delegate = self
        cell.configureData(orderProductList[indexPath.row])
        
        if let editIndexPath = self.editIndexPath {
            if editIndexPath.row == indexPath.row && editIndexPath.section == editIndexPath.section {
                cell.editOrderData(true)
            }
        }
        
        return cell
    }
}

extension TMTakeOrderViewController: TMTakeOrderListCellDelegate {
    func orderListDidDelete(product: TMProduct) {
//        var index = orderProductList
        editCell = nil
        editIndexPath = nil
        
        var index = 0
        for ; index < orderProductList.count; ++index {
            if orderProductList[index] == product {
                break
            }
        }
        
        orderProductList.removeAtIndex(index)
        tableView.reloadData()
        updateOrderDetail()
    }
    
    func orderListDidSubtract(product: TMProduct) {
        var quantity = product.quantity.integerValue - 1
        
        if quantity < 1 {
            quantity = 1
        }
        
        product.quantity = NSNumber(integer: quantity)
        tableView.reloadRowsAtIndexPaths([editIndexPath!], withRowAnimation: UITableViewRowAnimation.None)
        tableView.selectRowAtIndexPath(editIndexPath, animated: false, scrollPosition: .None)
        updateOrderDetail()
    }
    
    func orderListDidPlus(product: TMProduct) {
        var quantity = product.quantity.integerValue + 1
        
        product.quantity = NSNumber(integer: quantity)
        tableView.reloadRowsAtIndexPaths([editIndexPath!], withRowAnimation: UITableViewRowAnimation.None)
        tableView.selectRowAtIndexPath(editIndexPath, animated: false, scrollPosition: .None)
        
        updateOrderDetail()
    }
}

// MARK: - 点击菜品

extension TMTakeOrderViewController: TMProductListViewControllerDelegate {
    
    func productListViewController(viewController: TMProductListViewController, didSelectedProduct: TMProduct) {
        
        var orderProduct: TMProduct?
        
        var index = 0
        for ; index < orderProductList.count; ++index {
            var record = orderProductList[index]
            if record.product_id == didSelectedProduct.product_id {
                orderProduct = record
                break
            }
        }
        
        if orderProduct != nil {
            var quantity: Int = orderProduct!.quantity.integerValue
            quantity += 1
            orderProduct!.quantity = NSNumber(integer: quantity)
        } else {
            orderProduct = didSelectedProduct
            orderProduct?.quantity = 1
            orderProductList.append(orderProduct!)
        }
        
        updateOrderDetail()
        tableView.reloadData()
        tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: index, inSection: 0), atScrollPosition: UITableViewScrollPosition.Bottom, animated: true)
    }
}
