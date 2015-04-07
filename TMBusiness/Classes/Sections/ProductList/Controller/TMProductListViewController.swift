//
//  TMProductListViewController.swift
//  TMBusiness
//
//  Created by ZhangMing on 4/2/15.
//  Copyright (c) 2015 南京寻觅信息科技有限公司. All rights reserved.
//

import UIKit

let productListReuseIdentifier = "productCell"

protocol TMProductListViewControllerDelegate: class {
    func productListViewController(viewController: TMProductListViewController, didSelectedProduct: TMProduct)
}

class TMProductListViewController: BaseViewController {
    
    var collectionView: UICollectionView!
    var productList: [TMProduct] = [TMProduct]()
    weak var delegate: TMProductListViewControllerDelegate?
    private var selectedIndexPath: NSIndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var flowLayout = UICollectionViewFlowLayout();
        flowLayout.itemSize = CGSizeMake(170, 105)
        flowLayout.sectionInset = UIEdgeInsetsMake(14, 15, 14, 15)
        flowLayout.scrollDirection = .Vertical
        flowLayout.minimumLineSpacing = 10
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.headerReferenceSize = CGSizeZero
        flowLayout.footerReferenceSize = CGSizeZero
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: flowLayout)
        collectionView.dataSource = self
        collectionView.delegate = self
        view.addSubview(collectionView)
        
        collectionView?.backgroundColor = UIColor.whiteColor()
        // Register cell classes
        collectionView!.registerClass(TMProductCell.self, forCellWithReuseIdentifier: productListReuseIdentifier)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if let indexPath = selectedIndexPath {
            collectionView.deselectItemAtIndexPath(indexPath, animated: true)
        }
        
        selectedIndexPath = nil
    }
    
    override func viewDidLayoutSubviews() {
        collectionView.frame = view.bounds
    }
}

extension TMProductListViewController: UICollectionViewDataSource {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productList.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(productListReuseIdentifier, forIndexPath: indexPath) as TMProductCell
        let product = productList[indexPath.row]
        cell.productNameLabel.text = product.product_name
        
        return cell
    }
}

extension TMProductListViewController: UICollectionViewDelegate {
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        selectedIndexPath = indexPath
        if let delegate = self.delegate {
            let product = productList[indexPath.row]
            delegate.productListViewController(self, didSelectedProduct: product)
        }
    }
}
