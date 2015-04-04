//
//  AZPagingContainerMenuView.swift
//  AAPagingContainerViewControllerDemo
//
//  Created by ZhangMing on 4/3/15.
//  Copyright (c) 2015 ZhangMing. All rights reserved.
//

import UIKit

protocol AZPagingContainerMenuViewDelegate: class {
    
    func menuView(menuView: AZPagingContainerMenuView, didSelectedIndex index: Int)
    
    func menuViewDidExpandMenuList(expand: Bool)
}

let AZPagingItemViewDefaultWidth: CGFloat = 111
let AZPagingItemViewDefaultMargin: CGFloat = 0


class AZPagingExpandItemView: UIView {
    var expandButton: UIButton!
    var arrowImageView: UIImageView!
    var expand: Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        expandButton = UIButton.buttonWithType(.Custom) as UIButton
        expandButton.setBackgroundImage(UIImage(named: "category_expand"), forState: .Normal)
        expandButton.setBackgroundImage(UIImage(named: "category_expand_on"), forState: .Highlighted)
//        expandButton.addTarget(self, action: "expand", forControlEvents: .TouchUpInside)
        addSubview(expandButton)
        
        arrowImageView = UIImageView(image: UIImage(named: "product_arrow"))
        addSubview(arrowImageView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        expandButton.frame = bounds
        arrowImageView.center = bounds.center
        arrowImageView.centerX += 3
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

class AZPagingItemView: UIView {
    var imageView: UIImageView!
    var titleLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        imageView = UIImageView(frame: CGRectZero)
        imageView.image = UIImage(named: "product_category")
        imageView.highlightedImage = UIImage(named: "product_category_on")
        addSubview(imageView)
        
        titleLabel = UILabel(frame: CGRectZero)
        titleLabel.textColor = UIColor.whiteColor()
        titleLabel.highlightedTextColor = UIColor.blackColor()
        titleLabel.textAlignment = .Center
        titleLabel.font = UIFont.systemFontOfSize(15.0)
        addSubview(titleLabel)
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        imageView.frame = bounds
        titleLabel.frame = bounds
    }
}

class AZPagingContainerMenuView: UIView {
    
    var bgView: UIImageView!
    var menuScrollView: UIScrollView!
    var expandView: AZPagingExpandItemView!
    var needShowExpandButton: Bool = true {
        didSet {
            setNeedsLayout()
        }
    }

    var items: [String]! = [String]() {
        didSet {
            if items != oldValue {
                if itemViewList.count > 0 {
                    clearItemViews()
                }
                
                addItemViews()
                setNeedsLayout()
            }
        }
    }
    
    lazy var itemViewList: [AZPagingItemView] = {
        return [AZPagingItemView]()
        }()
    
    var selectedIndex: Int = 0 {
        didSet {
            var itemView = itemViewList[oldValue]
            itemView.titleLabel.highlighted = false
            itemView.imageView.highlighted = false
            
            itemView = itemViewList[selectedIndex]
            itemView.titleLabel.highlighted = true
            itemView.imageView.highlighted = true
            
            // reset menuView contentoffset
            var nextIndex = selectedIndex + 1
            var previousIndex = selectedIndex - 1
            
            var distance: CGFloat = 0.0
            
            if nextIndex > itemViewList.count - 1 {
                nextIndex = itemViewList.count - 1
                var nextItemView = itemViewList[nextIndex]
                var offsetX = menuScrollView.contentSize.width - menuScrollView.width
                distance = offsetX
            } else if previousIndex < 0 {
                previousIndex = 0
                distance = 0.0
            } else {
                var previousItemView = itemViewList[previousIndex]
                var nextItemView = itemViewList[nextIndex]
                
                var contentOffset = menuScrollView.contentOffset
                var currentOriginX = itemView.left - contentOffset.x
                var previousOriginX = previousItemView.left - contentOffset.x
                var nextOriginX = nextItemView.left - contentOffset.x
                
                var previousRight = previousOriginX + previousItemView.width
                var nextRight = nextOriginX + nextItemView.width
                
                var delta = menuScrollView.width - nextOriginX// -
                
                if previousRight > 40 && delta > 40 {
                    // do nothing
                    return
                } else {
                    distance = itemView.left - (previousRight + delta) / 2.0
                    
                    if distance > menuScrollView.contentSize.width - menuScrollView.width {
                        distance = menuScrollView.contentSize.width - menuScrollView.width
                    } else if distance < 0 {
                        distance = 0
                    }
                }
            }
            menuScrollView.setContentOffset(CGPointMake(distance, 0), animated: true)
        }
    }
    weak var delegate: AZPagingContainerMenuViewDelegate?
    
    // MARK: - Initialize
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        bgView = UIImageView(image: UIImage(named: "product_category_bg"))
        addSubview(bgView)
        
        menuScrollView = UIScrollView(frame: CGRectZero)
        menuScrollView.backgroundColor = UIColor.clearColor()
        menuScrollView.delegate = self
        menuScrollView.scrollsToTop = false
        menuScrollView.showsHorizontalScrollIndicator = false
        menuScrollView.showsVerticalScrollIndicator = false
        addSubview(menuScrollView)
        
        expandView = AZPagingExpandItemView(frame: CGRectZero)
        expandView.expandButton.addTarget(self, action: "expandButtonTapAction:", forControlEvents: .TouchUpInside)
        addSubview(expandView)
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - Layout
    override func layoutSubviews() {
        super.layoutSubviews()

        bgView.frame = bounds
        
        // resize menuScrollView frame
        menuScrollView.frame = bounds
        
        // resize item view frame
        var offsetX: CGFloat = 0
        
        for var index = 0; index < itemViewList.count; ++index {
            var itemView = itemViewList[index]
            itemView.left = offsetX
            
            offsetX += itemView.width
        }
        
        if needShowExpandButton {
            expandView.frame = CGRectMake(width - 55, 0, 55, 51)
            offsetX += 55
        }
        
        expandView.hidden = !needShowExpandButton
        
        menuScrollView.contentSize = CGSizeMake(offsetX, menuScrollView.height)
    }
    
    /**
    删除之前添加的item view
    */
    func clearItemViews() {
        for itemView in itemViewList {
            if let sv = itemView.superview {
                itemView.removeFromSuperview()
            }
        }
        
        itemViewList.removeAll(keepCapacity: false)
    }
    
    /**
    添加item view
    */
    func addItemViews() {
        for var index = 0; index < items.count; ++index {
            var item = items[index]
            
            var itemView = AZPagingItemView(frame: CGRectZero)
            itemView.tag = index
            itemView.titleLabel.text = item
            
            // calculate item view width
            var string = item as NSString
            
            var width = string.boundingRectWithSize(CGSizeMake(CGFloat.max, height), options: NSStringDrawingOptions.UsesFontLeading, attributes: [NSFontAttributeName: itemView.titleLabel.font], context: nil).width
            
            if width <= AZPagingItemViewDefaultWidth {
                width = AZPagingItemViewDefaultWidth
            } else {
                width += AZPagingItemViewDefaultMargin
            }
            
            itemView.width = width
            itemView.height = height
            itemView.backgroundColor = UIColor.greenColor()
            
            // add gesture
            var tapGesture = UITapGestureRecognizer(target: self, action: "itemViewTapAction:")
            itemView.addGestureRecognizer(tapGesture)
            
            menuScrollView.addSubview(itemView)
            itemViewList.append(itemView)
            
            // highlighted
            if index == 0 {
                itemView.imageView.highlighted = true
                itemView.titleLabel.highlighted = true
            }
        }
    }
    
    // Item View Tap Action
    func itemViewTapAction(recognizer: UITapGestureRecognizer) {
        
        if let view = recognizer.view {
            if view.tag != selectedIndex {
                self.selectedIndex = view.tag
                if let delegate = self.delegate {
                    delegate.menuView(self, didSelectedIndex: selectedIndex)
                }
            }
        }
    }
    
    func expandButtonTapAction(sender: AnyObject) {
        if let sv = (sender.superview as? AZPagingExpandItemView) {
            sv.expand = !sv.expand
            if let delegate = self.delegate {
                delegate.menuViewDidExpandMenuList(sv.expand)
            }
        }
    }
}

extension AZPagingContainerMenuView: UIScrollViewDelegate {
    
}