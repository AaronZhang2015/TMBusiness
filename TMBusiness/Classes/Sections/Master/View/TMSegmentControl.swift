//
//  TMSegmentControl.swift
//  TMBusiness
//
//  Created by ZhangMing on 4/2/15.
//  Copyright (c) 2015 南京寻觅信息科技有限公司. All rights reserved.
//

import UIKit

let TMSegmentDefaultWidth: CGFloat = 98
let TMSegmentDefaultHeight: CGFloat = 33

class TMSegmentItemView: UIView {
    var backgroundView: UIImageView!
    
    var titleLabel: UILabel!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundView = UIImageView(frame: bounds)
        addSubview(backgroundView)
        
        titleLabel = UILabel(frame: bounds)
        titleLabel.textAlignment = .Center
        titleLabel.textColor = UIColor.whiteColor()
        titleLabel.highlightedTextColor = UIColor.blackColor()
        titleLabel.backgroundColor = UIColor.clearColor()
        addSubview(titleLabel)
    }
}

class TMSegmentControl: UIControl {
    
    var font: UIFont = UIFont.systemFontOfSize(15.0) {
        didSet {
            setNeedsLayout()
        }
    }
    
    lazy var items: [String] = {
        return [String]()
        }()
    
    lazy var itemViewList: [TMSegmentItemView] = {
        return [TMSegmentItemView]()
        }()
    
    var selectedIndex: Int = -1 {
        didSet {
            if oldValue == selectedIndex {
                return
            }
            
            if oldValue >= 0 {
                var itemView = itemViewList[oldValue]
                itemView.backgroundView.highlighted = false
                itemView.titleLabel.highlighted = false
            }
            
            var itemView = itemViewList[selectedIndex]
            itemView.backgroundView.highlighted = true
            itemView.titleLabel.highlighted = true
            
            sendActionsForControlEvents(.ValueChanged)
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        var backgroundImageView = UIImageView(frame: self.bounds)
        backgroundImageView.image = UIImage(named: "menubg")
        addSubview(backgroundImageView)
    }
    
    convenience init(frame: CGRect, items: [String]) {
        // 计算所有的长度
        self.init(frame: frame)
        self.items = items
        
        for var index = 0; index < items.count; ++index {
            var item = items[index]
            var itemView = TMSegmentItemView(frame: CGRectMake(1 + CGFloat(index) * (TMSegmentDefaultWidth + 1), 1, TMSegmentDefaultWidth, TMSegmentDefaultHeight))
            itemView.tag = index
            if index == 0 {
                itemView.backgroundView.image = UIImage(named: "menu_left")
                itemView.backgroundView.highlightedImage = UIImage(named: "menu_left_on")
            } else if index == items.count - 1 {
                itemView.backgroundView.image = UIImage(named: "menu_right")
                itemView.backgroundView.highlightedImage = UIImage(named: "menu_right_on")
            } else {
                itemView.backgroundView.image = UIImage(named: "menu_center")
                itemView.backgroundView.highlightedImage = UIImage(named: "menu_center_on")
            }
            var tapGesture = UITapGestureRecognizer(target: self, action: "itemViewTapAction:")
            itemView.addGestureRecognizer(tapGesture)
            itemView.titleLabel.text = item
            itemView.titleLabel.font = font
            addSubview(itemView)
            itemViewList.append(itemView)
        }
        
        if (itemViewList.count > 0 && selectedIndex >= 0) {
            var itemView = itemViewList[selectedIndex]
            itemView.backgroundView.highlighted = true
            itemView.titleLabel.highlighted = true
        }
    }
    
    func itemViewTapAction(recognizer: UITapGestureRecognizer) {
        
        if let view = recognizer.view {
            selectedIndex = view.tag
        }
    }
}
