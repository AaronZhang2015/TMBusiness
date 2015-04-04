//
//  AZPagingContainerMenuListView.swift
//  TMBusiness
//
//  Created by ZhangMing on 4/3/15.
//  Copyright (c) 2015 南京寻觅信息科技有限公司. All rights reserved.
//

import UIKit

let AZPagingContainerMenuListReuseIdentifier = "AZPagingContainerMenuListReuseIdentifier"

protocol AZPagingContainerMenuListViewDelegate: class {
    func menuListView(menuListView: AZPagingContainerMenuListView, didSelectedInex index: Int)
}

class AZPagingContainerMenuListView: UIView {

    weak var delegate: AZPagingContainerMenuListViewDelegate?
    var collectionView: UICollectionView!
    var selectedIndex: Int = 0 {
        didSet {
            var selectedIndexPath = NSIndexPath(forRow: selectedIndex, inSection: 0)
            
            collectionView.selectItemAtIndexPath(selectedIndexPath, animated: true, scrollPosition: .None)
        }
    }
    
    var items: [String]! = [String]() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        var flowLayout = UICollectionViewFlowLayout();
        flowLayout.itemSize = CGSizeMake(110, 50)
        flowLayout.sectionInset = UIEdgeInsetsMake(14, 15, 14, 15)
        flowLayout.scrollDirection = .Vertical
        flowLayout.minimumLineSpacing = 10
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.headerReferenceSize = CGSizeZero
        flowLayout.footerReferenceSize = CGSizeZero
        
        collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: flowLayout)
        collectionView.dataSource = self
        collectionView.delegate = self
        addSubview(collectionView)
    
        collectionView?.backgroundColor = UIColor.whiteColor()
        // Register cell classes
        collectionView!.registerClass(AZPagingContainerMenuListCell.self, forCellWithReuseIdentifier: AZPagingContainerMenuListReuseIdentifier)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = bounds
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

extension AZPagingContainerMenuListView: UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(AZPagingContainerMenuListReuseIdentifier, forIndexPath: indexPath) as AZPagingContainerMenuListCell
        cell.productNameLabel.text = items[indexPath.row]
        
        return cell
    }
}

extension AZPagingContainerMenuListView: UICollectionViewDelegate {
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if let delegate = self.delegate {
            delegate.menuListView(self, didSelectedInex: indexPath.row)
        }
    }
}

class AZPagingContainerMenuListCell: UICollectionViewCell {
    var productNameLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundView = UIImageView(image: UIImage(named: "category_list_bg"))
        selectedBackgroundView = UIImageView(image: UIImage(named: "category_list_bg_on"))
        
        productNameLabel = UILabel(frame: bounds)
        productNameLabel.numberOfLines = 3
        productNameLabel.font = UIFont.systemFontOfSize(15.0)
        productNameLabel.textAlignment = .Center
        productNameLabel.backgroundColor = UIColor.clearColor()
        productNameLabel.textColor = UIColor.whiteColor()
        productNameLabel.highlightedTextColor = UIColor.blackColor()
        addSubview(productNameLabel)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
