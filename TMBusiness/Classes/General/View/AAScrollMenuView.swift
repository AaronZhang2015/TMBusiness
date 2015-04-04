//
//  AAScrollMenuView.swift
//  AAContainerViewControllerDemo
//
//  Created by ZhangMing on 3/31/15.
//  Copyright (c) 2015 ZhangMing. All rights reserved.
//

import UIKit

let AAScrollMenuViewWidth: CGFloat = 80
let AAScrollMenuViewMargin: CGFloat = 10

protocol AAScrollMenuViewDelegate: class {
    func scrollMenuView(menuView: AAScrollMenuView, didSelectedIndex: Int)
}

class AAMenuView: UIView {
    var imageView: UIImageView!
    var titleLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        imageView = UIImageView(frame: bounds)
        addSubview(imageView)
        
        titleLabel = UILabel(frame: bounds)
        titleLabel.backgroundColor = UIColor.clearColor()
        titleLabel.textAlignment = .Center
        addSubview(titleLabel)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

class AAScrollMenuView: UIView {
    
    weak var delegate: AAScrollMenuViewDelegate?
    var bgView: UIImageView!
    var scrollView: UIScrollView!
    var itemViewNormalImage: String!
    var itemViewSelectedImage: String!
    var itemTitleColor: UIColor!
    var itemTitleHightlightedColor: UIColor!
    var currentSelectedIndex: Int = 0 {
        didSet {
            var currentItemView = itemViewList[oldValue]
            currentItemView.imageView.highlighted = false
            currentItemView.titleLabel.highlighted = false
            
            currentItemView = itemViewList[currentSelectedIndex]
            currentItemView.imageView.highlighted = true
            currentItemView.titleLabel.highlighted = true
        }
    }
    
    // 如果已经选中，那么就不执行点击事件
    var shouldTriggerWhenHighlighted: Bool = false
    
    var itemTitleList: [String]! = [String](){
        didSet {
            if oldValue != itemTitleList {
                if oldValue != nil {
                    // remove
                    if itemTitleList != nil {
                        for itemView in itemViewList {
                            itemView.removeFromSuperview()
                        }
                    }
                    
                    itemViewList.removeAll(keepCapacity: false)
                    
                    // add
                    for var index = 0; index < itemTitleList.count; ++index {
                        var frame = CGRectMake(0, 0, AAScrollMenuViewWidth, height)
                        var itemView = AAMenuView(frame: frame)
                        itemView.tag = index
                        
                        if let image = itemViewNormalImage {
                            itemView.imageView.image = UIImage(named: image)
                        }
                        if let image = itemViewSelectedImage {
                            itemView.imageView.highlightedImage = UIImage(named: image)
                        }
                        if let color = itemTitleColor {
                            itemView.titleLabel.textColor = color
                        }
                        if let color = itemTitleHightlightedColor {
                            itemView.titleLabel.highlightedTextColor = color
                        }
                        
                        itemView.titleLabel.text = itemTitleList[index]
                        scrollView.addSubview(itemView)
                        var tapGesture = UITapGestureRecognizer(target: self, action: "itemViewTapAction:")
                        itemView.addGestureRecognizer(tapGesture)
                        
                        itemViewList.append(itemView)
                    }
                    
                    currentSelectedIndex = 0
                }
            }
        }
    }
    var itemViewList: [AAMenuView] = [AAMenuView]()
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.whiteColor()
        bgView = UIImageView(image: UIImage(named: "product_category_bg")!.resizableImageWithCapInsets(UIEdgeInsetsMake(0, 4, 0, 4)))
        addSubview(bgView)
        
        scrollView = UIScrollView(frame: bounds)
        scrollView.backgroundColor = UIColor.clearColor()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.scrollsToTop = false
        addSubview(scrollView)
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        bgView.frame = bounds
        
        var x = AAScrollMenuViewMargin
        for var index = 0; index < itemViewList.count; ++index {
            var width = AAScrollMenuViewWidth
            var itemView = itemViewList[index]
            itemView.frame = CGRectMake(x, 0, width, scrollView.height)
            x += width + AAScrollMenuViewMargin
        }
        
        
        scrollView.contentSize = CGSizeMake(x, scrollView.height)
        
        var frame = scrollView.frame
        if frame.width > x {
            frame.x = (frame.width - x) / 2.0
            frame.width = x
        } else {
            frame.x = 0;
            frame.width = frame.width;
        }
        
        scrollView.frame = frame
        scrollView.frame = bounds
    }
    
    // MARK: - Button Action
    func itemViewTapAction(recognizer: UITapGestureRecognizer) {
        if let delegate = self.delegate {
            if let view = recognizer.view {
                
                if view.tag == currentSelectedIndex {
                    if !shouldTriggerWhenHighlighted {
                        return
                    } else {
                        delegate.scrollMenuView(self, didSelectedIndex: view.tag)
                        return
                    }
                }
                
                currentSelectedIndex = view.tag
                
                delegate.scrollMenuView(self, didSelectedIndex: view.tag)
            }
        }
    }
}
